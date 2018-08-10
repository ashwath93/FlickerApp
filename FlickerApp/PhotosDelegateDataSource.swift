//
//  PhotosDelegateDataSource.swift
//  FlickerApp
//
//  Created by Ashwath on 23/01/21.
//  Copyright © 2021 Ashwath R. All rights reserved.
//

import UIKit

class PhotosDelegateDataSource: NSObject, ViewModelDelegate {
    let collectionView: UICollectionView
    let viewModel: ViewModel
    
    init(collectionView: UICollectionView, viewModel: ViewModel) {
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
        collectionView.dataSource = self
        collectionView.delegate = self
        viewModel.delegate = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
    }
    
    func reloadCollection() {
        collectionView.reloadData()
    }
}

extension PhotosDelegateDataSource: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier,
                                                      for: indexPath) as! CollectionViewCell
        cell.titleLabel.text = viewModel.photos[indexPath.row].title
        viewModel.fetchImage(atIndex: indexPath.row) { image in
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        viewModel.cancelImageFetch(atIndex: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.contentOffset.y + scrollView.frame.size.height > scrollView.contentSize.height else { return }
        viewModel.fetchMoreResults()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        CGSize(width: collectionView.frame.width / 3 - 16, height: collectionView.frame.width / 3 - 16)
    }
}
