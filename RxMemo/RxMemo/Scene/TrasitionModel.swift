//
//  TrasitionModel.swift
//  RxMemo
//
//  Created by 김지나 on 2023/11/21.
//

import Foundation

// 전환 방식
enum TransitionStyle {
    case root // 첫 화면
    case push // 새로운 화면
    case modal // 새로운 화면을 모달 형식으로 표시할 때
}

enum TransitionError: Error {
    case navigationControllerMissing // 네비컨트롤러가 없을 때
    case cannotPop // 네비스택의 뷰컨을 팝할 수 없을 떄
    case unKnown // 에러의 종류 할 수 없을 때 기본적으로 방출
}
