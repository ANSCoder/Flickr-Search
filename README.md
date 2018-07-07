# Flickr-Search

This is the basic example for the Flickr image search module. Its will search any keyword based on your keyword and 
it will display the images with the endless scrolling.

Inside this project **UISearchBar** using for type keywords and **UICollectionView** for display search results.
It will call request async and display new images based on page count in backgroud simuntaniously.

## Getting Started

- Clone the repo and run Flickr-Search.xcodeproj
- No pod install or carthage update needed directly use this projects
- Create a Flickr API key and replace placeholder with key in Router.swift 

## 🤔 Requirements

* Deployment target of your App is >= iOS 10.0
* XCode 9.3 or later
* Swift 4.0


## Keyword search request
UISearchBar priving for keyword search access.

```
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        
        //Reset old data first befor new search Results
        resetValuesForNewSearch()
        
        //Requesting here new keyword
        fetchSearchImages()
    }
```



## Endless Scrolling with pagination
For providing infinite scroll using here UIScrollView Delegate method it will calculate size which required for pagination 
new data model

```
//MARK :- Getting user scroll down event here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionResult{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= ((scrollView.contentSize.height) - ((scrollView.contentSize.height)/8))){
                
                //Start locading new data from here
                fetchSearchImages()
            }
        }
    }
```


- Collection View with flowlayout
- Image Cache

## Generics type Async Network request 

```
 router.requestFor(text: searchBar.text ?? "", with: pageCount.description, decode: { json -> Photos? in
        guard let flickerResult = json as? Photos else { return  nil }
        return flickerResult
 }) { [unowned self] result in
            self.labelLoading.text = ""
            switch result{
            case .success(let value):
                self.updateSearchResult(with: value.photos.photo, nil)
            case .failure(let error):
                print(error.debugDescription)
                self.showAlertWithError((error?.localizedDescription) ??
                "Please check your Internet connection or try again.", completionHandler: {[unowned self] status in
                    guard status else { return }
                    self.fetchSearchImages()
            })
      }
  }
```

## 👤 Author

**Anscoder** [(Anand Nimje)](https://twitter.com/anand8402) 



