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
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var issueListViewModel = IssueListViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
}

extension IssueListVC {
    func bindViewModel() {
        let input = IssueListViewModel.Input()
        let output = issueListViewModel.transform(input: input)
        
        //issueTableView bind
        output.issues.drive(issueTableView.rx.items(cellIdentifier: "issueCell", cellType: IssueCell.self)) { [weak self] row, issue, cell in
            guard let strongSelf = self else {return}
            cell.titleLabel.text = issue.title
            let index = issue.date.index(issue.date.startIndex, offsetBy: 10)
            cell.dateLabel.text = issue.date.substring(to: index)
            cell.userLabel.text = issue.user.userName
            cell.commentsNumLabel.text = "\(issue.commentsNum)"
            
            //tableView cell의 button click을 input으로 받은 후 output으로 새창으로 이동
            let cellInput = IssueListViewModel.CellInput(clickMove: cell.moveIssueDetail.rx.tap.asSignal(), clickIndex: Observable.of(row))
            
            let cellOutput = strongSelf.issueListViewModel.cellTransform(input: cellInput)
            
            cellOutput.htmlPath.asObservable().subscribe { htmlPath in
                guard let url = URL(string: htmlPath.element ?? "") else { return }
                UIApplication.shared.open(url)
                }.disposed(by: strongSelf.disposeBag)
            }.disposed(by: disposeBag)
        
        //request의 result에 따른 처리
        output.result.asObservable().subscribe { [weak self] result in
            guard let strongSelf = self else {return}
            if let result = result.element {
                switch result {
                case true: strongSelf.indicatorView.stopAnimating()
                default: strongSelf.indicatorView.stopAnimating()
                strongSelf.showAlert(self: strongSelf, title: "실패", message: "", actionTitle: "확인")
                }
            }
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
