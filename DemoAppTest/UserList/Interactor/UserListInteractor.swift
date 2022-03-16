//
//  UserListInteractor.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import Foundation

class UserListInteractor: UserListPresenterToInteractorProtocol {
    var presenter: UserListInteractorToPresenterProcotol?
    func fetchData() {
        let page = 1
        print("fetch data call - by presenter")
        Network.fetchUserDatasByPage(page) { [weak self] result in
            switch result {
            case let .success(breeds):
                let breedsC = breeds
                self?.presenter?.receivedData(breeds)

            case let .failure(error):
                // complettion("fail")
                print(error)
            }
        }
    }

    func fetchDetails(_ id: String) {
        print("fetch details call - by presenter")
        Network.fetchuserDetails(breedId: id) { [weak self] result in
            switch result {
            case let .success(image):
                self?.presenter?.receivedDetails(id, image)
            case let .failure(error):
                print(error, "error occured while getgin image ")
            }
        }
    }

    func fetchImage() {
        print("fetch image  call - by presenter")
    }
}
