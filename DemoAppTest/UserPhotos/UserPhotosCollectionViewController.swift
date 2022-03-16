//
//  UserPhotosCollectionViewController.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/30/22.
//

import UIKit

private let reuseIdentifier = "PhotosCell"
protocol UserPhotosDelegate {
    func didSwipeOutView()
    func didTapView()
}

class UserPhotosCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    var delegate: UserPhotosDelegate?
    var startFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var startX: CGFloat = 0.0
    var startY: CGFloat = 0.0

    @IBOutlet var interactiveSubView: [UICollectionView]! {
        didSet {
            for subview in interactiveSubView {
                let tapRecognizer = UITapGestureRecognizer(
                    target: self, action: #selector(handleTap)
                )
                tapRecognizer.delegate = self
                subview.addGestureRecognizer(tapRecognizer)
            }
        }
    }

    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {
        guard let recognizerView = recognizer.view else {
            return
        }
        let translation = recognizer.translation(in: view)
        recognizerView.center.x += translation.x
        recognizerView.center.y += translation.y
        recognizer.setTranslation(.zero, in: view)
        startX = startX + translation.x
        startY = startY + translation.y

        if recognizer.state == .ended {
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.checkDirection()
            } completion: { [weak self] _ in
            }
        }
    }

    @objc func handleTap() {
        let indexPath = IndexPath(item: 2, section: 1)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        print("handle tap called ")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startFrame = view!.frame
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        interactiveSubView.map {
            $0.gestureRecognizers!.first { $0 is UIPanGestureRecognizer }!
        }
        .forEach { panRecognizer in
            panRecognizer.view!.gestureRecognizers!
                .first { $0 is UITapGestureRecognizer }!
                .require(toFail: panRecognizer)
        }
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using [segue destinationViewController].
         // Pass the selected object to the new view controller.
     }
     */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in _: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        let height = 300
        let y = height // *indexPath.count
        cell.frame = CGRect(x: 0, y: y, width: 300, height: height)
        cell.backgroundColor = UIColor.gray
        // Configure the cell

        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
         return true
     }
     */

    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         return true
     }
     */

    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
         return false
     }

     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
         return false
     }

     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

     }
     */
}

private extension UserPhotosCollectionViewController {
    func checkDirection() {
        print("startX", startX)
        print("startY", startY)
        if startX > 0 {
            // right
            print("startX =", startX)
            print(" right swipe ")
            delegate?.didSwipeOutView()
        } else if startX < 0 {
            // left
            print("startX =", startX)
            print(" left ")
            if abs(startX) > 0 {
                delegate?.didSwipeOutView()
            }
        }
        startY = 0
        startX = 0
    }
}
