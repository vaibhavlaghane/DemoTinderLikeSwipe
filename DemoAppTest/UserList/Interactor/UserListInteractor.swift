//
//  UserListInteractor.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import Foundation

class UserListInteractor:  UserListPresenterToInteractorProtocol{

    var presenter: InteractiveUserListPresenter?
    
    // TODO: this should really take a completion parameter
    func fetchData() {
        guard let presenter = self.presenter else { return } // If presenter is nil, you can exit early
        let page = 1
        print("fetch data call - by presenter")
        Network.fetchUserDatasByPage(page) { result in
            switch result {
            case .success(let breeds):
                presenter.present(listItems: breeds)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchDetails() {
        print("fetch details call - by presenter")
    }
    
    func fetchImage() {
        print("fetch image  call - by presenter")
    }
    
    
}
