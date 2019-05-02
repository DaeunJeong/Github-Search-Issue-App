//
//  Issue.swift
//  GithubSearchIsuueApp
//
//  Created by daeun on 02/05/2019.
//  Copyright © 2019 daeun. All rights reserved.
//

import Foundation

struct IssueModel: Codable {
    let htmlUrl: String
    let title: String
    let user: User
    let commentsNum: Int
    let date: String
    
    
    enum CodingKeys: String, CodingKey {
        case htmlUrl = "html_url"
        case title
        case user
        case commentsNum = "comments"
        case date = "created_at"
    }
    struct User: Codable {
        let userName: String
        
        enum CodingKeys: String, CodingKey {
            case userName = "login"
        }
    }
}
