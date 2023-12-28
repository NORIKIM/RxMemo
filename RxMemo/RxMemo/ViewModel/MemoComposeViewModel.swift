//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by 김지나 on 2023/11/21.
//

import Foundation
import RxSwift
import RxCocoa
import Action

// 메모 추가 할 때, 편집할 때 화면 클래스
class MemoComposeViewModel: CommonViewModel {
    // 메모 저장 속성
    private let content: String?
    
    // 뷰에 바인딩 할 수 있도록 함
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }
    
    // 저장과 취소
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    // 아래 init을 통해 이전 화면에서 처리 방식을 동적으로 결정할 수 있다
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        self.content = content
        /*
         init의 파라미터를 보면 저장,취소 액션이 옵셔널이므로
         saveAction에 값을 전달할 때 한번 더 랩핑
         */
        self.saveAction = Action<String, Void> { input in
            // 1. action 실행 후
            if let action = saveAction {
                action.execute(input)
            }
            
            // 2. 화면 닫음
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
