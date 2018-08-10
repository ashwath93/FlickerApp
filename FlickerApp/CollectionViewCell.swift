//
//  CollectionViewCell.swift
//  FlickerApp
//
//  Created by Ashwath R on 07/08/18.
//  Copyright © 2018 Ashwath R. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    class var reuseIdentifier: String { "CollectionViewCell" }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.textColor = UIColor.black
    }

    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
    }
}
