//
//  SearchController.swift
//  Flickr-Search
//
//  Created by Anand Nimje on 04/07/18.
//  Copyright © 2018 Anand. All rights reserved.
//

import UIKit

class SearchController: UIViewController, AlertMessage {
    
    fileprivate let downloadQueue = DispatchQueue(label: "Images cache", qos: DispatchQoS.background)
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionResult: UICollectionView!
    @IBOutlet weak var labelLoading: UILabel!
    fileprivate var searchPhotos = [Photo]()
    fileprivate lazy var router = Router()
    fileprivate var pageCount = 0
    fileprivate let imageProvider = ImageProvider()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Request search text
    @objc func fetchSearchImages(){
        pageCount+=1   //Count increment here
        
        router.requestFor(text: searchBar.text ?? "", with: pageCount.description, decode: { json -> Photos? in
            guard let flickerResult = json as? Photos else { return  nil }
            return flickerResult
        }) { [unowned self] result in
            DispatchQueue.main.async {
                self.labelLoading.text = ""
                switch result{
                case .success(let value):
                    self.updateSearchResult(with: value.photos.photo)
                case .failure(let error):
                    print(error.debugDescription)
                    self.showAlertWithError((error?.localizedDescription) ?? "Please check your Internet connection or try again.", completionHandler: {[unowned self] status in
                        guard status else { return }
                        self.fetchSearchImages()
                    })
                }
            }
        }
    }
    
    //MARK: - Handle response result
    func updateSearchResult(with photo: [Photo]){
        DispatchQueue.main.async { [unowned self] in
            let newItems = photo
            
            // update data source
            self.searchPhotos.append(contentsOf: newItems)
            
            //Reloading Collection view Data
            self.collectionResult.reloadData()
        }
    }
}

//MARK: - SearchBar Delegate
extension SearchController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        
        router.cancelTask()
        
        DispatchQueue.main.async {
            //Reset old data first befor new search Results
            self.resetValuesForNewSearch()
            
            //Requesting here new keyword
            self.fetchSearchImages()
        }
    }
    
    //MARK: - Clearing here old data search results with current running tasks
    func resetValuesForNewSearch(){
        pageCount = 0
        searchPhotos.removeAll()
        collectionResult.reloadData()
        labelLoading.text = "Searching Images..."
    }
}

//MARK: - Collection View DataSource
extension SearchController: UICollectionViewDataSource, RequestImages{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return searchPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        guard searchPhotos.count != 0 else {
            return cell
        }
        let model = searchPhotos[indexPath.row]
        guard let mediaUrl = model.getImagePath() else {
            return cell
        }
        let image = imageProvider.cache.object(forKey: mediaUrl as NSURL)
        cell.imageResult.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cell.imageResult.image = image
        if image == nil {
            imageProvider.requestImage(from :mediaUrl, completion: { (image) -> Void in
                collectionView.reloadItems(at: [indexPath])
            })
        }
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension SearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionWidth = collectionView.bounds.width;
        var itemWidth = collectionWidth / 3 - 1;
        
        if(UI_USER_INTERFACE_IDIOM() == .pad) {
            itemWidth = collectionWidth / 4 - 1;
        }
        return CGSize(width: itemWidth, height: itemWidth);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

//MARK: - Scrollview Delegate
extension SearchController: UIScrollViewDelegate {
    
    //MARK :- Getting user scroll down event here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionResult{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height)){
                
                //Start locading new data from here
                fetchSearchImages()
            }
        }
    }
}
