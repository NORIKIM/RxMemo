//
//  MemoListViewController.swift
//  RxMemo
//
//  Created by 김지나 on 2023/11/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController, ViewModelBindableType {

    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    var viewModel: MemoListViewModel!
    
    func bindViewModel() {
        /*
         뷰모델에 저장되어 있는 타이틀을 네비게이션 타이틀과 바인딩
         -> 뷰모델에 저장되어 있는 타이틀이 네비게이션바에 표시됨
        */
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        /*
         메모 목록을 테이블뷰에 바인딩
         옵저버블과 테이블뷰를 바인딩 하는 방식으로 구현
         */
        viewModel.memoList
            .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, memo, cell in
                if #available(iOS 14.0, *) {
                    var config = UIListContentConfiguration.cell()
                    config.text = memo.content
                } else {
                    cell.textLabel?.text = memo.content
                }
            }
            .disposed(by: rx.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

}
