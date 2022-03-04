//
//  CollectionViewRoundedCell.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 2/1/22.
//

import UIKit

class CollectionViewRoundedCell: UICollectionViewCell {
    static let reuseCellIdentifier = CollectionViewRoundedCell.self
    @IBOutlet weak var title: UILabel! //= UILabel()
    @IBOutlet weak var userImage: UIImageView!// = UIImageView()
    
    @IBOutlet weak var info: UILabel! //= UILabel()
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
//    var user: UserData{
//        didSet{
//            if let tUser = user{
//                
//            }
//        }
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //fatalError("init(coder:) has not been implemented")
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
    override  func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let attributes = layoutAttributes as! MosaicLayoutAttributes
        //imageViewHeightConstraint.constant = 100//attributes.imageHeight
    }
}
