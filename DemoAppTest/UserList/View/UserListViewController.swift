//
//  UserListViewController.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import UIKit

class UserListViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var collectionView: UICollectionView!
    var presenter: UserListViewToPresenterProtocol?
    var userList: [UserData] = []
    var curreIndex: IndexPath?
    var rightIndex: IndexPath?
    var leftIndx: IndexPath?
    private var startX: CGFloat = 0.0
    private var startY: CGFloat = 0.0
    private var didTap = true
    private var widthCell:CGFloat = 0

    var delegate: UserPhotosDelegate?

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
            }  
        }
    }

    @IBOutlet var interactiveSubView: [UICollectionView]! {
        didSet {
            for subview in interactiveSubView {
                let tapRecognizer = UITapGestureRecognizer(
                    target: self, action: #selector(handleTap(gesture: ))
                )
                tapRecognizer.delegate = self
                subview.addGestureRecognizer(tapRecognizer)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UserListRouter.createModule(self)
        // register cell
        let nib = UINib(nibName: "CollectionViewRoundedCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CollectionViewRoundedCell")
        // Do any additional setup after loading the view.
        navigationController?.isToolbarHidden = true
        collectionView.isScrollEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)

        let layout = collectionView.collectionViewLayout as! MosaicViewLayout
        let width = view.frame.width
        let height = view.frame.height
        layout.delegate = self
        layout.numberOfColumns = 1
        layout.heightConstant = height - 40
        layout.widthConstant = width //- 40
        layout.calculatedWidth = width
        widthCell = layout.calculatedWidth
        layout.cellPadding = 0//5

        presenter?.getData()
    }
}

extension UserListViewController: UserListPresenterToViewProtocol {
    func showUserList(_ userData: [UserData]) {
        print("user list from presenter to VIew ")
        userList = userData
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

    func showUserList() {
        print("user list from presenter to VIew ")
    }

    func reloadList() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension UserListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return userList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        curreIndex = indexPath
        if indexPath.item == 0 {
            leftIndx = indexPath
            rightIndex = indexPath
        }
        if didTap {
            if indexPath.item + 1 == leftIndx?.item {
                leftIndx = indexPath
//                if(indexPath.row < userList.count - 1 ){
//                    rightIndex = IndexPath(row: indexPath.row - 2, section: indexPath.section)
//                }
                didTap = false
            }
            if indexPath.item - 1 == rightIndex?.item {
                rightIndex = indexPath
//                if(indexPath.row > 1){
//                    leftIndx = IndexPath(row: indexPath.row - 2, section: indexPath.section)
//                }
                didTap = false
            }
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewRoundedCell", for: indexPath) as! CollectionViewRoundedCell
        let user = userList[indexPath.item]
        cell.title.text = userList[indexPath.item].name
        cell.info.text = userList[indexPath.item].description
        widthCell = cell.bounds.width
        if let id = user.id {
            if let image = presenter?.images[id] {
                cell.userImage.image = image
            } else {
                presenter?.getImage(id)
            }
        }
        return cell
    }
}

extension UserListViewController: MosaicLayoutDelegate {
    func collectionView(_: UICollectionView, heightForImageAtIndexpath _: IndexPath, withWidth _: CGFloat) -> CGFloat {
        return 500
    }

    func collectionView(_: UICollectionView, heightForDescriptionAtIndexPath _: IndexPath, withWidth _: CGFloat) -> CGFloat {
        return 50
    }
}

extension UserListViewController {
    // gesture recognizer taps

    @objc func handleTap(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: gesture.view)
        let y = point.y
        let x = point.x - ( CGFloat( curreIndex?.row ?? 0 ) * widthCell) - widthCell/2
        print("y = \(y)")
        print("x = \(x)")
        if x < 0 {
            handleTapLeft()
            return
        }
        guard let indexPath = rightIndex else {
            return
        }
        collectionView.isScrollEnabled = true
        print("indexpath", indexPath)

        rightIndex = IndexPath(item: curreIndex!.item + 1, section: curreIndex!.section)
        didTap = true
        if let row = rightIndex?.row , row  < userList.count {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            curreIndex = indexPath
            if(indexPath.row > 1){
                leftIndx = IndexPath(row: rightIndex!.row - 1, section: rightIndex!.section)
            }
        }
        print("handle tap called ")
    }
    
    @objc func handleTapLeft() {
        guard let indexPath = leftIndx else {
            return
        }
        collectionView.isScrollEnabled = true
        print("indexpath left  = ", indexPath)

        leftIndx = IndexPath(item: curreIndex!.item - 1, section: curreIndex!.section)
        didTap = true
        if let row = leftIndx?.row , row  >= 0 {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            curreIndex = indexPath
            if(indexPath.row < userList.count - 1 ){
                rightIndex = IndexPath(row: leftIndx!.row + 1 , section: leftIndx!.section)
            }
        }
        print("handle left tap called ")
    }
}

private extension UserListViewController {
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
