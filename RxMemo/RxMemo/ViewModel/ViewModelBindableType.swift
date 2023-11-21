//
//  ViewModelBindableType.swift
//  RxMemo
//
//  Created by 김지나 on 2023/11/21.
//

import UIKit

// view와 viewmodel을 서로 바인딩 해주는 역할
protocol ViewModelBindableType {
    // 뷰모델의 타입은 뷰마다 달라지므로 프로토콜을 제네릭으로 선언해야함
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    // 바인딩에 필요한 메소드
    func bindViewModel()
}

extension ViewModelBindableType where Self: UIViewController {
    mutating func bind(viewModel: Self.ViewModelType) {
        // 뷰컨에 추가된 뷰모델 속성에, 파라미터로 전달된 실제 viewmodel을 저장하고 바인드뷰모델 메서드를 호출하도록 함 -> 뷰컨에 바인드뷰모델 메서드를 직접 호출할 필요가 없어 코드가 단순해짐
        self.viewModel = viewModel
        loadViewIfNeeded()
        bindViewModel()
    }
}
