//
//  DownloadOperation.swift
//  FlickerApp
//
//  Created by Ashwath on 19/01/21.
//  Copyright © 2021 Ashwath R. All rights reserved.
//

import UIKit

class DownloadOperation: Operation {

    override var isAsynchronous: Bool { true }
    override var isExecuting: Bool { _isExecuting }
    private var _isExecuting: Bool = false {
        didSet {
            willChangeValue(forKey: #keyPath(Operation.isExecuting))
            didChangeValue(forKey: #keyPath(Operation.isExecuting))
        }
    }
    override var isCancelled: Bool { _isCancelled }
    private var _isCancelled: Bool = false {
        didSet {
            willChangeValue(forKey: #keyPath(Operation.isCancelled))
            didChangeValue(forKey: #keyPath(Operation.isCancelled))
        }
    }
    override var isFinished: Bool { _isFinished }
    private var _isFinished: Bool = false {
        didSet {
            willChangeValue(forKey: #keyPath(Operation.isFinished))
            didChangeValue(forKey: #keyPath(Operation.isFinished))
        }
    }
    private var task: URLSessionTask!
    private let url: URL
    private(set) var image: UIImage?
    
    init(url: URL) {
        self.url = url
    }
    
    override func main() {
        task = URLSession(configuration: .ephemeral).dataTask(with: url) {
            data, response, error in
            guard let nonNilData = data,
                  let image = UIImage(data: nonNilData) else { return }
            self.image = image
            self._isFinished = true
            self._isCancelled = false
            self._isExecuting = false
        }
        _isFinished = false
        _isCancelled = false
        _isExecuting = true
        task.resume()
    }
    
    override func cancel() {
        _isFinished = false
        _isCancelled = true
        _isExecuting = false
        task?.cancel()
    }
}
