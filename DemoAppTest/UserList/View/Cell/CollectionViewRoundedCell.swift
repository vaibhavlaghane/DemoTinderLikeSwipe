//
//  CollectionViewRoundedCell.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 2/1/22.
//

import UIKit

class CollectionViewRoundedCell: UICollectionViewCell {
    static let reuseCellIdentifier = CollectionViewRoundedCell.self // TODO: cell reuseIdentifiers are usually strings, not classes.  Additionally, since this is not ever used, I'd delete it altogether.
    static let reuseID = "CollectionViewRoundedCell"
    static let nibName = "CollectionViewRoundedCell"
    
    @IBOutlet weak var title: UILabel! // TODO: I'd rename title & info, to primaryTextLabel, and secondaryTextLabel
    @IBOutlet weak var userImage: UIImageView! // TODO: As this is just a general CollectionViewRoundedCell class (not specific to a user), I'd rename this to imageView
    
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!

    // TODO: I'd get rid of any unnecessary code.  Since you're overriding this init, but not doing anything, its just cluttering up the code
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented") // TODO: Delete this line
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 12.0
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor(red: 0.5, green: 0.47, blue: 0.25, alpha: 1.0).cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userImage.image = nil
        title.text = ""
        info.text = ""
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        // Using layout attributre is a good choice, but dont force unwrap
        guard let attributes = layoutAttributes as? MosaicLayoutAttributes else { return }
        imageViewHeightConstraint.constant = attributes.imageHeight // TODO: Consider setting all your constraints programatically.  In fact, I'd suggest not using xib for layouts, and possibly create all views programatically.
    }
}
