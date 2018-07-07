//
//  Router.swift
//  Flickr-Search
//
//  Created by Anand Nimje on 05/07/18.
//  Copyright © 2018 Anand. All rights reserved.
//

import Foundation


class Router: RequestFlickrImages{
    
    //Replace your Flickr Key here
    fileprivate let flickrKey = "3e7cc266ae2b0e0d78e279ce8e361736"
    
    enum Result<value>{
        case success(value)
        case failure(Error?)
    }
    
    fileprivate var task: URLSessionTask?
    
    //MARK: - Make URL here based on keyword & page counts
    fileprivate func getURL_Path(_ pageCount: String, and text: String) -> URL?{
        guard let urlPath = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(flickrKey)&format=json&nojsoncallback=1&safe_search=\(pageCount)&text=\(text)") else {
            return nil
        }
        return urlPath
    }
    
    //MARK: - Cancel all previous tasks
    func cancelTask(){
        task?.cancel()
    }
    
}

extension Router: SearchTextSpaceRemover{
    
    func requestFor<T: Codable>(text: String, with pageCount: String, decode: @escaping (Codable) -> T?, completionHandler: @escaping(Result<T>) -> Void){
        
        //Removing here keywords spaces
        let keyword = text.removeSpace
        guard keyword.count != 0 else { return }
        
        let session = URLSession.shared
        guard let urlPath = getURL_Path(pageCount, and: keyword) else { return }
        
        //Set timeout for request
        requestTimeOut()
        
        task = session.photosTask(with: urlPath, decodingType: T.self, completionHandler: { photos, response, error in
            DispatchQueue.main.async {
                guard error == nil,
                    let result = photos else {
                        completionHandler(.failure(error))
                        return
                }
                //print(result)
                completionHandler(.success(result))
            }
        })
        task?.resume()
    }
    
    /**
     Adding here timeout for cancel current task if any case request not getting success or taking too much time because of internet. Default time out is 15 seconds.
     */
    fileprivate func requestTimeOut(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(20), execute: {
            self.task?.resume()
        })
    }
}


