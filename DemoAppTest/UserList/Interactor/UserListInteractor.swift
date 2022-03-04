//
//  UserListInteractor.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import Foundation

class UserListInteractor:  UserListPresenterToInteractorProtocol{

    var presenter: UserListInteractorToPresenterProcotol?
    func fetchData() {
        let page = 1
        print("fetch data call - by presenter")
        Network.fetchUserDatasByPage(page) { [weak self ] (result) in
            switch result
            {
            case .success(let breeds):
                let breedsC = breeds
                self?.presenter?.receivedData(breeds)
                
            case .failure(let error):
                //complettion("fail")
                print(error)
            }
        }
    }
    
    func fetchDetails(_ id: String) {
         
        print("fetch details call - by presenter")
        Network.fetchuserDetails(breedId: id) { [weak self ] (result ) in
            switch result{
            case .success(let image ):
                self?.presenter?.receivedDetails(id , image )
            case .failure(let error ):
                print(error,"error occured while getgin image ")
                
            }
        }
    }
    
    func fetchImage() {
        print("fetch image  call - by presenter")
    }
    
    
}
