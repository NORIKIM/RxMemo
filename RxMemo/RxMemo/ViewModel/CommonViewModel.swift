//
//  CommonViewModel.swift
//  RxMemo
//
//  Created by 김지나 on 2023/12/07.
//

import Foundation
import RxSwift
import RxCocoa

// 공통적으로 사용하는 뷰 모델
class CommonViewModel: NSObject {
    let title: Driver<String> // 네비게이션 아이템 쉽게 저장 가능
    let sceneCoordinator: SceneCoordinatorType
    let storage: MemoStorageType
    
    init(title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
