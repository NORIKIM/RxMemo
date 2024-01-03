//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by 김지나 on 2023/11/21.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var contentTextView: UITextView!
    
    var viewModel: MemoComposeViewModel!
    
    func bindViewModel() {
        /*
         ----->
         메모 쓰기 모드에서는 빈 문자열이 표시되고
         편집 모드에서는 편집할 메모가 표시됨
         */
        // 네비게이션 타이틀 바인딩
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        // initailText를 textView에 바인딩
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        // <-----
        
        // 취소버튼을 cancel액션과 바인딩
        // 취소 버튼을 탭했을 때 cancel 액션에 랩핑 되어 있는 코드가 실행된다.
        cancelButton.rx.action = viewModel.cancelAction
        
        // 저장버튼을 save액션과 바인딩
        // 버튼을 탭하면 텍스트뷰의 텍스트를 저장
        /*
         throttle - 0.5초마다 한번씩 처리
         withLatestFrom - 텍스트뷰에 입력되어 있는 텍스트 방출
         bind - 방출된 텍스트를 save 액션과 바인딩
         결과 =>
         save 버튼을 tap했을 때
         contentTextView에 있는 최신 텍스트가 방출되고
         이 텍스트가 saveAction에 있는 input으로 바인딩 된다
         */
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(contentTextView.rx.text.orEmpty)
            .bind(to: viewModel.saveAction.inputs)
            .disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 화면이 나타나면 텍스트뷰의 키보드 활성화
        contentTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 화면이 사라지면 텍스트뷰의 키보드 비활성화
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}
