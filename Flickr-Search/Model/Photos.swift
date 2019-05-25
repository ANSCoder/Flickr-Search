//
//  Photos.swift
//  Flickr-Search
//
//  Created by Anand Nimje on 04/07/18.
//  Copyright © 2018 Anand. All rights reserved.
//

import Foundation

struct Photos: Codable {
    let photos: PhotosClass
}

struct PhotosClass: Codable {
    let page, pages, perpage: Int
    let total: String
    let photo: [Photo]
}

struct Photo: Codable, PhotoURL {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}

protocol PhotoURL {}

extension PhotoURL where Self == Photo{
    
    func getImagePath() -> URL?{
        let path = "http://farm\(self.farm).static.flickr.com/\(self.server)/\(self.id)_\(self.secret).jpg"
        return URL(string: path)
    }
    
}

