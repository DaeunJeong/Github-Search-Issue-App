//
//  NetworkingApi.swift
//  GithubSearchIsuueApp
//
//  Created by daeun on 02/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire

protocol NetworkingService {
    func searchIssues() -> Observable<(Bool,[IssueModel])>
}

final class NetworkingApi: NetworkingService {
    func searchIssues() -> Observable<(Bool,[IssueModel])> {
        return RxAlamofire.requestData(.get, "https://api.github.com/repos/nodejs/node/issues", parameters: ["state":"open","sort":"comments"], encoding: URLEncoding.queryString, headers: ["Content-Type" : "application/json"]).map { (response, data) -> (Bool,[IssueModel]) in
            
            var result = false
            
            switch response.statusCode {
            case 200: result = true
            default: result = false
            }
            
            guard let issueModel = try? JSONDecoder().decode([IssueModel].self, from: data) else {
                return (false,[])
            }
            return (result,issueModel)
        }
    }
}
