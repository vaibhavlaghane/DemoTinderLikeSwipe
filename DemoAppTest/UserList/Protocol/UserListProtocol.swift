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

protocol PresentableUserListView {
    func show<ListItem>(listItems: [ListItem])
}

protocol InteractiveUserListPresenter {
    var interactor: UserListPresenterToInteractorProtocol? { get set }
    var view: PresentableUserListView? { get set }
    var router: UserListRouterProtocol? { get set }
    
    func present<ListItem>(listItems: [ListItem])
    func receivedDetails() // TODO: rename present(details:)
    func receivedImage() // TODO: rename present(image:)
    
}

protocol UserListPresenterToInteractorProtocol {
    var presenter: InteractiveUserListPresenter? { get set }
    
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

