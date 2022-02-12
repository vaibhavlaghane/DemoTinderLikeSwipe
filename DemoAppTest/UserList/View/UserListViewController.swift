//
//  UserListViewController.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import UIKit

class UserListViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    var presenter: UserListViewToPresenterProtocol? = nil
    var  userList: [UserData] = []
    var curreIndex : IndexPath? = nil
    var rightIndex: IndexPath? = nil
    var leftIndx: IndexPath? = nil
    private var startX: CGFloat = 0.0
    private var startY: CGFloat = 0.0
    private var didTap = true
    
    var delegate: UserPhotosDelegate? = nil
    
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
            UIView.animate(withDuration: 0.4) {[weak self ] in
                self?.checkDirection()
            } completion: { [weak self] t in
                
            }
        }
    }
    @IBOutlet var interactiveSubView: [UICollectionView]!{
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
    override func viewDidLoad() {
        super.viewDidLoad()

        UserListRouter.createModule(self )
        //register cell
        let nib = UINib.init(nibName: "CollectionViewRoundedCell", bundle: nil )
        collectionView.register(nib , forCellWithReuseIdentifier: "CollectionViewRoundedCell")
        // Do any additional setup after loading the view.
        navigationController?.isToolbarHidden = true
        //collection view
        self.collectionView.isScrollEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
        
        let layout = collectionView.collectionViewLayout as! MosaicViewLayout
        let width = self.view.frame.width
        let height = self.view.frame.height
        layout.delegate = self
        layout.numberOfColumns = 1
        layout.heightConstant = height //- 40
        layout.widthConstant = width// - 40
        layout.calculatedWidth = width
        layout.cellPadding = 25
        
        presenter?.getData()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserListViewController: UserListPresenterToViewProtocol{
    func showUserList(_ userData: [UserData]) {
        print("user list from presenter to VIew ")
        userList = userData
        DispatchQueue.main.async {[weak self ] in
            self?.collectionView.reloadData()
        }
        
    }
    
    func showUserList() {
        print("user list from presenter to VIew ")
    }
    
    
}

extension UserListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        curreIndex = indexPath
        if( indexPath.item == 0 ){
         
            leftIndx = indexPath
            rightIndex = indexPath
        }
        if(didTap ){
            
            if(indexPath.item + 1 == leftIndx?.item ){
                leftIndx = indexPath
                didTap = false
            }
            if(indexPath.item - 1 == rightIndex?.item  ){
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

extension UserListViewController: MosaicLayoutDelegate{
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexpath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        return 50
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForDescriptionAtIndexPath indexPath: IndexPath, withWidth width: CGFloat) -> CGFloat {
        return 50
    }
}

extension UserListViewController{
    //gesture recognizer taps
    
    @objc func handleTap(){
        guard let indexPath = rightIndex else{
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
