//
//  SearchCollectionViewController.swift
//  FlickerApp
//
//  Created by Ashwath R on 08/08/18.
//  Copyright © 2018 Ashwath R. All rights reserved.
//

import UIKit

class SearchCollectionViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel = ViewModel()
    private var dataSource: PhotosDelegateDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = PhotosDelegateDataSource(collectionView: collectionView, viewModel: viewModel)
        var workItem: DispatchWorkItem?
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification,
                                               object: nil,
                                               queue: OperationQueue()) { [weak self] _ in
            workItem?.cancel()
            workItem = DispatchWorkItem {
                self?.viewModel.fetchSearchResults(for: self!.textField.text!)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .init(0.5), execute: workItem!)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.operationQueue.cancelAllOperations()
    }
}
