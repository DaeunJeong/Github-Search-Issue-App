//
//  ViewController.swift
//  GithubSearchIsuueApp
//
//  Created by daeun on 02/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IssueListVC: UIViewController {
    @IBOutlet weak var issueTableView: UITableView!
    
    var issueListViewModel = IssueListViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let input = IssueListViewModel.Input()
        let output = issueListViewModel.transform(input: input)
        
        output.issues.drive(issueTableView.rx.items(cellIdentifier: "issueCell", cellType: IssueCell.self)) { [weak self] row, issue, cell in
            guard let strongSelf = self else {return}
            cell.titleLabel.text = issue.title
            let index = issue.date.index(issue.date.startIndex, offsetBy: 10)
            cell.dateLabel.text = issue.date.substring(to: index)
            cell.userLabel.text = issue.user.userName
            cell.commentsNumLabel.text = "\(issue.commentsNum)"
            
            let cellInput = IssueListViewModel.CellInput(clickMove: cell.moveIssueDetail.rx.tap.asSignal(), clickIndex: Observable.of(row))
            
            let output = strongSelf.issueListViewModel.cellTransform(input: cellInput)
            
            output.htmlPath.asObservable().subscribe { htmlPath in
                guard let url = URL(string: htmlPath.element ?? "") else { return }
                UIApplication.shared.open(url)
            }.disposed(by: strongSelf.disposeBag)
        }.disposed(by: disposeBag)
        
    }
}

class IssueCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentsNumLabel: UILabel!
    @IBOutlet weak var moveIssueDetail: UIButton!
}
