//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 김지나 on 2023/11/21.
//

import Foundation
import RxSwift
import RxCocoa

// 메모 목록 화면 클래스
class MemoListViewModel: CommonViewModel {
    // 테이블뷰와 바인딩 할 수 있는 속성
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
}
