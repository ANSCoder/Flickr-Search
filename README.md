# Flickr-Search

This is the basic example for the Flickr image search module. Its will search any keyword based on your keyword and 
it will display the images with the endless scrolling.


![](https://github.com/ANSCoder/Flickr-Search/blob/master/Flickr-Search/Assets.xcassets/app_work.imageset/app_work.png?raw=true)

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

## Flickr API Documentation

Images are retrieved by hitting the [Flickr API](https://www.flickr.com/services/api/flickr.photos.search.html).

- **Search Path:**

```
https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=YOUR_FLICKR_API_KEY&format=json&nojsoncallback=1&safe_search=1&text=KEYWORD
```

- Response includes an array of photo objects, each represented as:

``` swift
{
    "id": "23451156376",
    "owner": "28017113@N08",
    "secret": "8983a8ebc7",
    "server": "578",
    "farm": 1,
    "title": "Merry Christmas!",
    "ispublic": 1,
    "isfriend": 0,
    "isfamily": 0
}
```

### To load the photo, you can build the full URL following this pattern:
```
http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
```
### Thus, using our Flickr photo model example above, the full URL would be:
```
http://farm1.static.flickr.com/578/23451156376_8983a8ebc7.jpg
```
### Generate your own here:
```
https://www.flickr.com/services/api/misc.api_keys.html
```

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



