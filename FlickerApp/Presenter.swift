//
//  Presenter.swift
//  FlickerApp
//
//  Created by Ashwath R on 10/08/18.
//  Copyright © 2018 Ashwath R. All rights reserved.
//

import UIKit

class Presenter: NSObject {

    class func fetchSearchResults(text: String, completion: @escaping([FlickerPhoto]?) -> ()) {
        if let url = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&format=json&nojsoncallback=1&safe_search=1&text=\(text)") {
            URLSession.shared.dataTask(with: url) {
                data, resp, err in
                guard let respData = data else {
                    completion(nil)
                    return
                }
                do {
                    let photos = try JSONDecoder().decode(Photos.self, from: respData)
                    completion(photos.photo.photos)
                } catch {
                    debugPrint(error.localizedDescription)
                    completion(nil)
                }
            }.resume()
        }
        else {
            debugPrint("URL not valid")
        }
    }
    
    class func fetchRecents(completion: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=3e7cc266ae2b0e0d78e279ce8e361736")!) {
            data, resp, err in
            completion(data)
        }.resume()
    }
    
    class func fetchMoreResults(with id: String, completion: @escaping (Data?) -> ()) {
        URLSession.shared.dataTask(with: URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=3e7cc266ae2b0e0d78e279ce8e361736&id=\(id)")!) {
            data, resp, err in
            completion(data)
        }.resume()
    }
}
