//
//  UserListPresenter.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import Foundation

class UserListPresenter:UserListInteractorToPresenterProcotol{
    var interactor: UserListPresenterToInteractorProtocol?
    var view: UserListPresenterToViewProtocol?
    var router: UserListRouterProtocol?
}

extension UserListPresenter {
    func receivedData(_ userList: [UserData]) {
        print("received data from interactor ")
        view?.showUserList(userList)
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
