//
//  UserListProtocol.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 1/31/22.
//

import Foundation
import UIKit
protocol UserListViewToPresenterProtocol {
    func getData()
    func getImage(_ id: String)
    var images: [String: UIImage] { get set }
}

protocol UserListPresenterToViewProtocol {
    func showUserList(_ userData: [UserData])
    func reloadList()
}

protocol UserListInteractorToPresenterProcotol {
    var interactor: UserListPresenterToInteractorProtocol? { get set }
    var view: UserListPresenterToViewProtocol? { get set }
    var router: UserListRouterProtocol? { get set }
    // var images: [String: UIImage ] {get set }

    func receivedData(_ userData: [UserData])
    func receivedDetails(_ id: String, _ image: UIImage)
    func receivedImage()
}

protocol UserListPresenterToInteractorProtocol {
    var presenter: UserListInteractorToPresenterProcotol? { get set }

    func fetchData()
    func fetchDetails(_ id: String)
    func fetchImage()
}

protocol UserListPresenterToRouterProtocol {
    func showDetailView()
}

protocol UserListRouterProtocol {
    static func createModule(_ userListView: UserListViewController)
}
