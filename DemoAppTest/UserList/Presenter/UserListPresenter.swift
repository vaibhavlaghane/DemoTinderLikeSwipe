//
//  UserListPresenter.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import Foundation

class UserListPresenter: InteractiveUserListPresenter {
    var interactor: UserListPresenterToInteractorProtocol? // TODO: Maybe consider using dependency injection
    var view: PresentableUserListView? // TODO: Maybe consider using dependency injection
    var router: UserListRouterProtocol? // TODO: Maybe consider using dependency injection
    
    
    // MARK: - InteractiveUserListPresenter
    
    func present<ListItem>(listItems: [ListItem]) {
        print("received data from interactor ")
        view?.show(listItems: listItems)
    }
    
    func receivedDetails() {
        print("received details from Interactor")
    }
    
    func receivedImage() {
        print("received Imge from Interactor")
    }
    
    
}

extension UserListPresenter: UserListViewToPresenterProtocol{
    func getData() {
        print("get data call made by view ")
        interactor?.fetchData()
    }
}
