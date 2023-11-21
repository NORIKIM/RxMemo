//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by 김지나 on 2023/11/21.
//

import Foundation
import RxSwift

// 신코디네이터가 공통적으로 구현해야하는 맴버 선언
// @discardableResult: return을 해야하는 메서드에서 리턴을 할 필요가 없는 경우 리턴하지 않아도 경고가 발생하지 않는다.
protocol SceneCoordinatorType {
    @discardableResult
    // 새로운 신을 표시
    func transition(to scene: Scene, usint style: TransitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    // 현재 신을 닫고 이전으로 돌아감
    func close(animated: Bool) -> Completable
}
