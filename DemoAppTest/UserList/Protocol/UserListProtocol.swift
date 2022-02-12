//
//  UserListProtocol.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import Foundation

protocol UserListViewToPresenterProtocol{
    func getData()
}

protocol UserListPresenterToViewProtocol{
    func showUserList(_ userData: [UserData])
}

protocol UserListInteractorToPresenterProcotol {
    var interactor: UserListPresenterToInteractorProtocol? {get set }
    var view: UserListPresenterToViewProtocol?{get set }
    var router: UserListRouterProtocol? {get set }
    
    func receivedData(_ userData: [UserData ])
    func receivedDetails()
    func receivedImage()
    
}

protocol UserListPresenterToInteractorProtocol {
    var presenter: UserListInteractorToPresenterProcotol? {get set }
    
    func fetchData()
    func fetchDetails()
    func fetchImage()
    
}

protocol UserListPresenterToRouterProtocol {
    func showDetailView()
}

protocol UserListRouterProtocol {
    static func createModule(_ userListView: UserListViewController) 
}

