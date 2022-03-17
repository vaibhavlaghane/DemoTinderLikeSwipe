//
//  CollectionViewRoundedCell.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 2/1/22.
//

import UIKit

class CollectionViewRoundedCell: UICollectionViewCell {
    static let reuseCellIdentifier = CollectionViewRoundedCell.self
    @IBOutlet var title: UILabel! // = UILabel()
    @IBOutlet var userImage: UIImageView! // = UIImageView()
    @IBOutlet var info: UILabel! // = UILabel()
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 12.0
        layer.borderWidth = 3
        layer.borderColor = UIColor(red: 0.5, green: 0.47, blue: 0.25, alpha: 1.0).cgColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        userImage.image = nil
        title.text = ""
        info.text = ""
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let attributes = layoutAttributes as! MosaicLayoutAttributes
        // imageViewHeightConstraint.constant = 100//attributes.imageHeight
    }
}
