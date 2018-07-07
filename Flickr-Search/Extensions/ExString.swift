//
//  ExString.swift
//  Flickr-Search
//
//  Created by Anand Nimje on 06/07/18.
//  Copyright © 2018 Anand. All rights reserved.
//

import Foundation

protocol SearchTextSpaceRemover{}

extension String: SearchTextSpaceRemover {
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

extension SearchTextSpaceRemover where Self == String {
    
    //MARK: - Removing space from String
    var removeSpace: String {
        if self.isNotEmpty {
           return self.components(separatedBy: .whitespaces).joined()
        }else{
           return ""
        }
    }
}
