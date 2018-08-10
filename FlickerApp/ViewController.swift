//
//  ViewController.swift
//  FlickerApp
//
//  Created by Ashwath R on 07/08/18.
//  Copyright © 2018 Ashwath R. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel = ViewModel()
    private var dataSource: PhotosDelegateDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = PhotosDelegateDataSource(collectionView: collectionView, viewModel: viewModel)
        viewModel.fetchPhotos()
    }

    @IBAction func searchTapped(_ sender: Any) {
        let searchScreen = SearchCollectionViewController()
        navigationController?.pushViewController(searchScreen, animated: true)
        viewModel.operationQueue.cancelAllOperations()
    }
}
