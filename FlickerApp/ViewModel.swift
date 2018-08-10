//
//  ViewModel.swift
//  FlickerApp
//
//  Created by Ashwath on 19/01/21.
//  Copyright © 2021 Ashwath R. All rights reserved.
//

import UIKit
import Combine

protocol ViewModelDelegate: AnyObject {
    func reloadCollection()
}

class ViewModel: NSObject {
    
    private(set) var xmlParser: XMLParser!
    private(set) var photos = [FlickerPhoto]()
    private var refreshCount = 0
    var isSearch = false
    let cache = NSCache<NSString, UIImage>()
    weak var delegate: ViewModelDelegate?
    let operationQueue = OperationQueue()
    private var operations = [String: DownloadOperation]()
    
    func fetchPhotos() {
        Presenter.fetchRecents { respData in
            self.initParser(withData: respData)
        }
    }
    
    func fetchMoreResults() {
        let id = photos.last?.photoId ?? ""
        Presenter.fetchMoreResults(with: id) { respData in
            self.initParser(withData: respData)
        }
    }
    
    func fetchSearchResults(for text: String) {
        Presenter.fetchSearchResults(text: text) { photos in
            self.photos = photos ?? []
            DispatchQueue.main.sync {
                self.delegate?.reloadCollection()
            }
        }
    }
    
    func fetchImage(atIndex index: Int, completion: @escaping (UIImage) -> ()) {
        let imageURL = photos[index].imageUrl
        if let image = cache.object(forKey: imageURL as NSString) {
            completion(image)
        } else {
            guard let url = URL(string: imageURL.description), operations[imageURL] == nil else { return }
            let downloadOperation = DownloadOperation(url: url)
            operations[imageURL] = downloadOperation
            downloadOperation.completionBlock = { [weak self] in
                let image = downloadOperation.image ?? UIImage(named: "placeholder")!
                self?.cache.setObject(image, forKey: imageURL as NSString)
                DispatchQueue.main.sync {
                    completion(image)
                }
            }
            operationQueue.addOperation(downloadOperation)
        }
    }
    
    func cancelImageFetch(atIndex index: Int) {
        let imageURL = photos[index].imageUrl
        operations[imageURL]?.cancel()
        operations[imageURL] = nil
    }
    
    //MARK: Private Method(s)
    private func initParser(withData data: Data?) {
        guard let nonNilData = data else { return }
        xmlParser = XMLParser(data: nonNilData)
        xmlParser.delegate = self
        xmlParser.parse()
    }
}

extension ViewModel: XMLParserDelegate {
    func parserDidEndDocument(_ parser: XMLParser) {
        debugPrint("Complete")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        if elementName == "photo" {
            refreshCount += 1
            self.photos.append(FlickerPhoto(attributeDict))
        }
        if refreshCount == 20 {
            DispatchQueue.main.sync {
                self.delegate?.reloadCollection()
                self.refreshCount = 0
            }
        }
    }
}
