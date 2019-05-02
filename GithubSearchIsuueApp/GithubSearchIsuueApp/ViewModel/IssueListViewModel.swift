//
//  MainViewModel.swift
//  GithubSearchIsuueApp
//
//  Created by daeun on 02/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class IssueListViewModel: ViewModelType {

    let disposeBag = DisposeBag()
    let api = NetworkingApi()
    let issues = Variable<[IssueModel]>([])
    
    struct Input {
        
    }
    
    struct Output {
        let result: Driver<Bool>
        let issues: Driver<[IssueModel]>
    }
    
    //request의 결과를 result와 issues모델로 변환
    func transform(input: Input) -> Output {
        
        let request = self.api.searchIssues()
        
        let result = request.map { request -> Bool in
            
            let (result, _) = request
            return result
            }.asDriver(onErrorJustReturn: false)
        
        let issueModels = request.map {[weak self] request -> [IssueModel] in
            let (_, issueModels) = request
            self?.issues.value = issueModels
            
            return issueModels
            }.asDriver(onErrorJustReturn: [])
        
        return Output(result: result, issues: issueModels)
    }
    
    struct CellInput {
        let clickMove: Signal<Void>
        let clickIndex: Observable<Int>
    }
    
    struct CellOutput {
        let htmlPath: Driver<String>
    }
    
    //click에 따라 htmlPath로 변환
    func cellTransform(input: CellInput) -> CellOutput {
        let htmlPath = input.clickMove.asObservable().withLatestFrom(input.clickIndex).flatMapLatest { [weak self] index -> Observable<String> in
            
            return Observable.of(self?.issues.value[index].htmlUrl ?? "")
        }.asDriver(onErrorJustReturn: "")
        
        return CellOutput(htmlPath: htmlPath)
    }
}
