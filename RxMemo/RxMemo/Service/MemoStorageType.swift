//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by 김지나 on 2023/10/27.
//

import Foundation
import RxSwift

// 기본적인 CRUD 처리 프로토콜
protocol MemoStorageType {
    // @discardableResult: 작업 결과가 필요 없는 경우
    // -> Observable<Memo>: 원하는 방식으로 처리 할 수 있도록 해줌
    @discardableResult
    func createMemo(content: String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}
