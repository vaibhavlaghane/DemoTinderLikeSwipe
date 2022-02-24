//
//  UserListViewController.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import UIKit

class UserListViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: UserListViewToPresenterProtocol? = nil // TODO: you don't need to specify `nil` for an optional property
    var userList = [UserData]()
    var curreIndex : IndexPath? = nil // TODO: you don't need to specify `nil` for an optional property
    var rightIndex: IndexPath? = nil // TODO: you don't need to specify `nil` for an optional property
    var leftIndx: IndexPath? = nil // TODO: you don't need to specify `nil` for an optional property
    
    private var startX: CGFloat = 0.0 // TODO: I'd replace these 2 variables with a single CGPoint
    private var startY: CGFloat = 0.0 // TODO: I'd replace these 2 variables with a single CGPoint
    private var didTap = true
    
    var delegate: UserPhotosDelegate? = nil // TODO: you don't need to specify `nil` for an optional property
    
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
        
        if(recognizer.state == .ended){
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.checkDirection()
            } completion: { [weak self] t in
                
            }
        }
    }
    
    // TODO: Move the outlet to the top of the class, near the other IBOutlet
    // TODO: Also, are you setting interactiveSubView more than once per view? If not, you should probably just set the recognizer and delegate in viewDidLoad
    @IBOutlet var interactiveSubView: [UICollectionView]! {
      didSet {
        for subview in interactiveSubView {
          let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
          tapRecognizer.delegate = self
          subview.addGestureRecognizer(tapRecognizer)
        }
      }
    }
    
    // TODO: implement Swift Lint
    override func viewDidLoad() {
        super.viewDidLoad()
        UserListRouter.createModule(self)
        //register cell
        let nib = UINib.init(nibName: UserList.Nib.roundedCollectionViewCell, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: UserList.ReuseIdentifier.roundedCollectionViewCell)
        // Do any additional setup after loading the view.
        navigationController?.isToolbarHidden = true
        //collection view
        self.collectionView.isScrollEnabled = true // Why refer to the self.collectionView (using the explicit `self`) on this line,
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5) // but refer to collectionView using the implicit `self` on this line?
        
        let layout = collectionView.collectionViewLayout as! MosaicViewLayout // Avoid force unwraps if possible.
        let frame = self.view.frame
        layout.delegate = self
        layout.numberOfColumns = 1
        layout.heightConstant = frame.height - 40
        layout.widthConstant = frame.width - 40
        layout.calculatedWidth = frame.width
        layout.cellPadding = 5
        
        presenter?.getData()
    }
}

// MARK: - PresentableUserListView

extension UserListViewController: PresentableUserListView {
    
    func show<ListItem>(listItems: [ListItem]) {
        guard let userList = listItems as? [UserData] else { return }
        self.userList = userList
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    // TODO: Delete this, it will cause a bug
//    func showUserList() {
//        print("user list from presenter to VIew ")
//    }
    
    
}

extension UserListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        curreIndex = indexPath
        if (indexPath.item == 0) {
         
            leftIndx = indexPath
            rightIndex = indexPath
        }
        if (didTap) {
            
            if (indexPath.item + 1 == leftIndx?.item) {
                leftIndx = indexPath
                didTap = false
            }
            if (indexPath.item - 1 == rightIndex?.item) {
                rightIndex = indexPath
                didTap = false
            }
            //rightIndex = IndexPath(item: indexPath.item + 1 , section: indexPath.section)
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  "CollectionViewRoundedCell", for: indexPath) as! CollectionViewRoundedCell
        cell.title.text = userList[indexPath.item].name
        cell.info.text = userList[indexPath.item].description
        return cell 
    }

}

extension UserListViewController: MosaicLayoutDelegate {
    
    // TODO: Unless youre planning on changing this depending on the index path, this delegate doesnt really do anything, you'd be better off just creating a static variable somewhere.
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexpath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        return 50
    }
    
    // TODO: Unless youre planning on changing this depending on the index path, this delegate doesnt really do anything, you'd be better off just creating a static variable somewhere.
    func collectionView(_ collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        return 50
    }
}

extension UserListViewController {
    
    @objc func handleTap() {
        guard let indexPath = rightIndex else {
            //collectionView.collec
            
            return
        }
        //collectionView.reloadItems(at: [indexPath])
       // curreIndex = rightIndex
        self.collectionView.isScrollEnabled = true
//        self.collectionView.scrolldir
        print("indexpath", indexPath)

    
        rightIndex = IndexPath(item: curreIndex!.item + 1 , section: curreIndex!.section)
        didTap = true
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true  )

        print("handle tap called ")
        
    }
}

extension UserListViewController{
    
    fileprivate func checkDirection(){
        print("startX",  startX )
        print("startY",  startY)
        if(startX > 0 ){
            //right
            print("startX =", startX)
            print(" right swipe " )
            delegate?.didSwipeOutView()
        }else if (startX < 0 ){
            //left
            print("startX =", startX)
            print(" left " )
            if(abs(startX) > 0 ){
                delegate?.didSwipeOutView()
            }
        }
        startY = 0
        startX = 0
    }
}
