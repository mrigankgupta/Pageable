# Pageable

[![CI Status](https://img.shields.io/travis/mrigankgupta/Pageable.svg?style=flat)](https://travis-ci.org/mrigankgupta/Pageable)
[![Version](https://img.shields.io/cocoapods/v/Pageable.svg?style=flat)](https://cocoapods.org/pods/Pageable)
[![License](https://img.shields.io/cocoapods/l/Pageable.svg?style=flat)](https://cocoapods.org/pods/Pageable)
[![Platform](https://img.shields.io/cocoapods/p/Pageable.svg?style=flat)](https://cocoapods.org/pods/Pageable)

## Purpose
"[Pagination](https://en.wikipedia.org/wiki/Pagination), also known as paging, is the process of dividing a document into discrete pages, either electronic pages or printed pages."

It is most common technique to manage large data set at server/client side to distribute in chunks called as pages. In todays time, Social media client apps improvised this by inventing "Infinite scroll".
 
Infinite scrolling allows users to load content continuously, eliminating the need for user's explicit actions. App loads some initial data and then load the rest of the data when the user reaches the bottom of the visible content. This data is divided in pages.


## Basic Usage

So how do you use this library? Well, it's pretty easy. Just follow these steps..
# Step 0
Create a simple PageInteractor object. PageInteractor operates on two generics types. 

First generic is type of `Model` which TableView/CollectionView is listing.

Second generic is a type of unique items in model data for identifing duplicate entries to be filter out.
By default, the type can be given as `Any`, if filtering is not required or `Model` doesn't have any unique identifiable object.

```swift
 let pageInteractor: PageInteractor<Model, Any> = PageInteractor()
```

# Step 1
Now instance of pageInteractor to be setup in ViewDidLoad() to get first page data.
```swift
func setupPageInteractor() {
  // Require to provide instance of TableView/CollectionView
  pageInteractor.pageDelegate = self.tableView
  // NetworkManager is implementing PageableService protocol
  pageInteractor.service = networkManager
  pageInteractor.refreshPage()
}

override func viewDidLoad() {
   super.viewDidLoad()
   setupPageInteractor()
 }
 ```
 # Step 2
 TableView will ask for items count from PageInteractor.
 ```swift
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return pageInteractor.visibleRow()
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   // Fetch a cell of the appropriate type.
   if indexPath.row >= pageInteractor.count() {
        let loadingCell = tableView.dequeueReusableCell(withIdentifier: "loadingCell", for: indexPath)
        return loadingCell
    } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellTypeIdentifier", for: indexPath)
        let cellData = pageInteractor.item(for: indexPath.row)
        // Configure the cell’s contents.
        cell.textLabel!.text = cellData.name
        return cell
    }
}

func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    pageInteractor.shouldPrefetch(index: indexPath.row)
}
 ```
 # Step 3
Now most importent step is to provide data to PageInteractor. That is done by implementing `PagableService` protocol. It has got two methods in it.
 ```swift
 protocol PagableService: class {
    func loadPage<Item: Decodable>(_ page: Int, completion: @escaping (PageInfo<Item>?) -> Void)
    func cancelAllRequests()
}
```
When PageInteractor's refresh method gets called either by end of TableView load or pulling UIRefreshControl, it tracks page number and ask for next page load by calling 
`loadPage<Item: Decodable>(_ page: Int, completion: @escaping (PageInfo<Item>?) -> Void)`
Where `page` indicates the next page to load. Once page gets loaded, `PageInfo` struct needs to be return.
```swift
struct PageInfo<T> {
    var types: [T] // list of item returned from request
    var page: Int // current page
    var totalPageCount: Int // total page
}
```
how it can be done, is shown below.
```swift
extension NetworkManager: PagableService {
   func loadPage<Item: Decodable>(_ page: Int, completion: @escaping (PageInfo<Item>?) -> Void) {
        var info: PageInfo<Item>?
        getNextPage(page: page) { (response) in
        // paginated response will have page number as well as total page
            switch response {
            case let .success(result):
                // Provide PageInfo Object from the response or nil in case no response
                info = PageInfo(types: result.types,
                                page: result.page,
                                totalPageCount: result.totalPageCount)
            case let .failure(err):
                print(err)
            }
            // Returning PageInfo Object from callback to PageInteractor
            completion(info)
        }
    }
    
    func cancelAllRequests() {
        cancelAll()
    }
}
```

## Advance Usage
Pageable provide additional features like 
1. Configurable start page index to be fetched from server
2. Filtering out duplicate items while loading addition items in the list.

```
     If server has added new entry in previous page displayed in pagination,
     it results in repeat of last item in fetched new page.
     
     Displayed                      __1__        On Server
     ____________                 ____2_____
     |  __1__   |                |  __3__   |       1
     |  __2__   |                |  __4__   |       2
     |  __3__   |  +__10__ ==    |  __4__   |      10
     |____4_____|                |____5_____|       3
        __5__                       __6__
        __6__                       __7__
        __7__                       __8__   new fetch
        __8__                       __9__
```
In case if duplicate entries has to be filter out, It requires keypath of unique items in model data. It can be setup in initializer or later.
        
```swift
let pageInteractor: PageInteractor<UserModel, Int> = PageInteractor(firstPage: 1, service: networkManager, keyPath: \UserModel.id)
```

## Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Pageable is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Pageable'
```

## Author

mrigankgupta, mrigankgupta@gmail.com

## License

Pageable is available under the MIT license. See the LICENSE file for more info.
