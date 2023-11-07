//
//  MemoryStorage.swift
//  RxMemo
//
//  Created by 김지나 on 2023/10/27.
//

import Foundation
import RxSwift

// 메모리에 메모를 저장하는 클래스
class MemoryStorage: MemoStorageType {
    // 메모를 저장하는 배열
    /*
     obervable을 통해 외부에 공개된다.
     또한 이 obervable은 배열의 상태가 업데이트 되면 새로운 next 이벤트를 방출해야한다.
     더미 데이터 또한 초기에 표시해야 하므로 subject 중 behaviorSubject로 만들어야 한다.
    */
    private var list = [
        Memo(content: "Hello, RxSwift", insertDate: Date().addingTimeInterval(-10)),
        Memo(content: "byebye, RxSwift", insertDate: Date().addingTimeInterval(-20))
    ]
    // 기본값을 리스트로 사용하기 위해 lazy
    private lazy var store = BehaviorSubject<[Memo]>(value: list)
    
    @discardableResult
    func createMemo(content: String) -> RxSwift.Observable<Memo> {
        // 새로운 메모를 생성하고 배열에 추가
        let memo = Memo(content: content)
        list.insert(memo, at: 0)
        
        // 서브젝트에서 새로운 넥스트 이벤트 방출
        store.onNext(list)
        
        // 새로운 메모를 방출하는 옵저버블
        return Observable.just(memo)
    }
    
    @discardableResult
    // 외부에서는 항상 이 메서드를 통해 list에 접근하도록 함
    func memoList() -> RxSwift.Observable<[Memo]> {
        return store
    }
    
    @discardableResult
    /*
     파라미터
     memo: 기존의 메모
     content: 새로운 메모
     */
    func update(memo: Memo, content: String) -> RxSwift.Observable<Memo> {
        // 업데이트된 메모 인스턴스 생성
        let updated = Memo(original: memo, updateContent: content)
        
        // 배열에 저장된 원본인스턴스를 새로운 인스턴스로 교체
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
            list.insert(updated, at: index)
        }
        
        // 서브젝트에서 새로운 넥스트 이벤트 방출
        // 테이블뷰와 바인딩 시 새로운 데이터 이용, reloadData로는 업데이트 불가
        store.onNext(list)
        
        // 업데이트된 메모를 방출하는 옵저버블
        return Observable.just(updated)
    }
    
    @discardableResult
    func delete(memo: Memo) -> RxSwift.Observable<Memo> {
        // 리스트 배열에서 메모를 삭제하고 서브젝트에서 새로운 넥스트 이벤트 방출
        if let index = list.firstIndex(where: { $0 == memo }) {
            list.remove(at: index)
        }
            
        // 삭제된 메모를 방출하는 옵저버블
        return Observable.just(memo)
    }
    
    
}
