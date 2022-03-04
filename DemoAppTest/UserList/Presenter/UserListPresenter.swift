//
//  UserListPresenter.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import Foundation
import UIKit

class UserListPresenter:UserListInteractorToPresenterProcotol{
    var interactor: UserListPresenterToInteractorProtocol?
    var view: UserListPresenterToViewProtocol?
    var router: UserListRouterProtocol?
    var images: [String: UIImage ] = [:]
}

extension UserListPresenter {
    func receivedData(_ userList: [UserData]) {
        print("received data from interactor ")
        view?.showUserList(userList)
    }
    
    func receivedDetails(_ id: String, _ image: UIImage) {
        print("received details from Interactor")
        images[id] = image
        view?.reloadList()
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
    func getImage(_ id: String ){
        print("get image call made by view - presenter passing it to Interactor")
        interactor?.fetchDetails(id )
    }
}
