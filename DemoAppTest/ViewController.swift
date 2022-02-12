//
//  ViewController.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/29/22.
//

import UIKit

class ViewController: UIViewController {

    private var photoCollections: [UserPhotosCollectionViewController]? = nil
    var  userPhotos1: UserPhotosCollectionViewController? = nil
    
    var  userPhotos2: UserPhotosCollectionViewController? = nil

    @IBOutlet weak var containerView: UIView!
    var userGrid: UserListViewController? = nil
    @IBAction func handlePan(_ recognizer: UIPanGestureRecognizer) {

  }
    
    var currentTopView: UserPhotosCollectionViewController? = nil
    var currentTopGrid: UserListViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
 
        adduserGrid()
        addContainedView()
    }
    func addContainedView(){
//        userPhotos1 = UserPhotosCollectionViewController(nibName: "UserPhotosCollectionViewController", bundle: nil )
//        userPhotos1?.delegate = self
//        self.addChild(userPhotos1!)
//        //self.present(userPhotos1!, animated: true , completion: nil )
//        self.view.addSubview(userPhotos1!.view)
//          userPhotos2 = UserPhotosCollectionViewController(nibName: "UserPhotosCollectionViewController", bundle: nil )
//        userPhotos2?.delegate = self
//        self.addChild(userPhotos2!)
//        //self.present(userPhotos1!, animated: true , completion: nil )
//        self.view.addSubview(userPhotos2!.view)
//        currentTopView  =  userPhotos2
//
        userGrid = UserListViewController(nibName: "UserListViewController", bundle: nil )
        userGrid?.delegate = self
        self.addChild(userGrid!)
       // userGrid?.view.bounds  = containerView.frame
        self.containerView.addSubview(userGrid!.view )
//        self.ch
        userGrid?.didMove(toParent: self )
        userGrid?.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: [], metrics: nil, views: ["childView":userGrid!.view]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", options: [], metrics: nil, views: ["childView":userGrid!.view]))
        currentTopGrid = userGrid
//        self.embed
    }
    func adduserGrid(){
        let userGrid1 = UserListViewController(nibName: "UserListViewController", bundle: nil )
        userGrid1.delegate = self
        self.addChild(userGrid1)
       // userGrid?.view.bounds  = containerView.frame
        self.containerView.addSubview(userGrid1.view )
//        self.ch
        userGrid1.didMove(toParent: self )
        userGrid1.view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|", options: [], metrics: nil, views: ["childView":userGrid1.view]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|", options: [], metrics: nil, views: ["childView":userGrid1.view]))
        currentTopGrid = userGrid1
        var composite = DetailViewController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.view.bringSubviewToFront(userPhotos1!.view)
    }


}

extension ViewController: UserPhotosDelegate{
    func didTapView() {
        print("did tap view ")
    }
    
    func didSwipeOutView() {
        //
        print("did swipe out view ")
        if currentTopView === userPhotos2{
            
            userPhotos2?.removeFromParent()
            userPhotos2?.view.removeFromSuperview()
            currentTopView = userPhotos1
            
        }else{
            userPhotos1?.removeFromParent()
            userPhotos1?.view.removeFromSuperview()
        }
        
        if( currentTopGrid == userGrid) {
            userGrid?.removeFromParent()
            userGrid?.view.removeFromSuperview()
        }else{
            
        }
    }
    
    
    
}

