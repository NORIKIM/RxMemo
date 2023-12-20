//
//  Scene.swift
//  RxMemo
//
//  Created by 김지나 on 2023/11/21.
//

import UIKit

// 앱에서 구현할 scene
enum Scene {
    case list(MemoListViewModel) // 메모 목록 화면, 연관된 뷰모델을 연관값으로 갖도록 함
    case detail(MemoDetailViewModel) // 메모 보기 화면,
    case compose(MemoComposeViewModel) // 메모 쓰기 화면,
}

extension Scene {
    // 스토리보드의 신을 생성하고 연관값에 저장된 뷰모델을 바인딩 후 리턴
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let memoListViewModel):
            // 메모 목록 신 생성 후 뷰모델 바인딩 후 리턴
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else {
                fatalError()
            }
            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }
            /*
             앱을 실행하면 메모 목록 이라는 타이틀을 라지타이틀로 설정 했음에도 불구 하고 작게 나온다.
             그 이유는 테이블뷰가 이른 시점에 바인딩 되기 때문
             따라서 가장 간단히 바인딩 시점을 늦추면 해결 가능하다.
             */
            DispatchQueue.main.async {
                listVC.bind(viewModel: memoListViewModel)
            }
            
            
            return nav
            
        case .detail(let memoDetailViewModel):
            // 메모 상세 보기 신
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else {
                fatalError()
            }
            DispatchQueue.main.async {
                detailVC.bind(viewModel: memoDetailViewModel)
            }
            
            return detailVC
            
        case .compose(let memoComposeViewModel):
            // 메모 쓰기 신
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
                fatalError()
            }
            guard var compseVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            DispatchQueue.main.async {
                compseVC.bind(viewModel: memoComposeViewModel)
            }
            
            return nav
        }
    }
}

