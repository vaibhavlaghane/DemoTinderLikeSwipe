//
//  MosaicLayout.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 2/1/22.
//

import UIKit

protocol MosaicLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexpath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
    func collectionView(_ collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat
}

class MosaicLayoutAttributes: UICollectionViewLayoutAttributes {
    var imageHeight: CGFloat = 0
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone) as! MosaicLayoutAttributes
        copy.imageHeight = imageHeight
        return copy
    }

    override func isEqual(_ object: Any?) -> Bool {
        if let attributes = object as? MosaicLayoutAttributes {
            if attributes.imageHeight == imageHeight {
                return super.isEqual(object)
            }
        }
        return false
    }
}

class MosaicViewLayout: UICollectionViewLayout {
    var delegate: MosaicLayoutDelegate!
    var numberOfColumns = 0
    var numberOfRows = 0
    var cellPadding: CGFloat = 0
    var heightConstant: CGFloat = 400
    var cache = [MosaicLayoutAttributes]()
    fileprivate var contentHeight: CGFloat = 400 // 0
    var calculatedWidth: CGFloat = 300
    var widthConstant: CGFloat = 300
    fileprivate var width: CGFloat {
        get {
            let insets = collectionView!.contentInset
            return collectionView!.bounds.width // - (insets.left + insets.right) - 50
        } set {
            self.width = newValue
        }
    }

    override var collectionViewContentSize: CGSize { 
        return CGSize(width: calculatedWidth, height: heightConstant)
    }

    override class var layoutAttributesClass: AnyClass {
        return MosaicLayoutAttributes.self
    }

    override func prepare() {
        if cache.isEmpty {
           
            prepareHelper()
        }
    }

    func prepareHelper() {
        let columnWidth = CGFloat(widthConstant) // width///CGFloat(numberOfColumns)
        let rowHeight = heightConstant

        var yOffsets = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            yOffsets.append(CGFloat(column) * rowHeight)
        }

        var xOffsets = [CGFloat](repeating: 0, count: numberOfColumns)

        var row = 0
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let width = columnWidth //- (cellPadding * 2)

            let x = CGFloat(item) * columnWidth
            let frame = CGRect(x: x, y: 0, width: width, height: rowHeight)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            let attributes = MosaicLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            calculatedWidth = x + columnWidth
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
}
