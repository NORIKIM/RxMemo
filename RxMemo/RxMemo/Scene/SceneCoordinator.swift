//
//  SceneCoordinator.swift
//  RxMemo
//
//  Created by 김지나 on 2023/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class SceneCoordinator: SceneCoordinatorType {
    private let bag = DisposeBag()
    // 화면 전환을 처리 하기 때문에 윈도우 인스턴스와 현재 화면에 표시되어 있는 신을 가지고 있어야 함
    private var window: UIWindow
    private var currentVC: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    /*
     transition() 내의 'let subject = PublishSubject<Never>'
     처음 부터 컴플리터블을 생성해도 되지만, 크리에이트 연산자를 만들어야 하고 클로저 내부에서 구현해야 하기 때문에 코드가 길어짐
     그래서 PublishSubject와 asCompletable을 사용
     
     PublishSubject를 사용하지 않고 completable을 직접 구현하는 close()와 비교하여 이해할 것
     */
    
    @discardableResult
    func transition(to scene: Scene, usint style: TransitionStyle, animated: Bool) -> RxSwift.Completable {
        // 화면 전환 결과 방출
        let subject = PublishSubject<Never> // 화면전환의 성공여부만 방출(하므로 never)
        // 신 생성
        let target = scene.instantiate()
        
        // 트렌지션 스타일에 따라 화면 전환
        switch style {
        case .root:
            // 윈도우에서 루트뷰 컨트롤러만 바꿔주면됨~
            currentVC = target
            window.rootViewController = target
            subject.onCompleted()
            
        case .push:
            // 네비컨트롤러에 임배드 되어 있는지 확인
            guard let nav = currentVC.navigationController else {
                subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            nav.pushViewController(target, animated: animated)
            currentVC = target
            subject.onCompleted()
            
        case .modal:
            // 신을 프레젠트
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target
        }
        
        return subject.asCompletable()
    }
    
    @discardableResult
    func close(animated: Bool) -> RxSwift.Completable {
        return Completable.create { [unowned self] comletable in
            // 현재 신이 모달방식이면 dismiss
            if let presentinVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentinVC
                    Completable(.completed)
                }
            }
            
            // 현재 신이 네비스택에 푸시되어 있다면 현재 신 pop
            else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    Completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                
                self.currentVC = nav.viewControllers.last!
                Completable(.completed)
            }
            
            else {
                comletable(.error(TransitionError.unKnown))
            }
            
            return Disposables.create()
        }
    }
    
    
}
