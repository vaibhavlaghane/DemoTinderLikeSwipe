//
//  UserListRouter.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import Foundation

class UserListRouter: UserListRouterProtocol{
    
    class func createModule(_ userListView: UserListViewController) {
        var presenter: UserListViewToPresenterProtocol & InteractiveUserListPresenter = UserListPresenter()
        presenter.router = UserListRouter()
        presenter.view = userListView
        let interactor = UserListInteractor()
        interactor.presenter = presenter
        presenter.interactor = interactor
        userListView.presenter = presenter
    }
    
}
