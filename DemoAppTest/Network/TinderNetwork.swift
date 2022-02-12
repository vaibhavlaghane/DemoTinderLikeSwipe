//
//  TinderNetwork.swift
//  DemoAppTest
//
//  Created by Vaibhav Laghane on 2/1/22.
//

import Foundation
import UIKit

/// Network interface
class Network {
    
    /// Errors from network responses
    ///
    /// - badUrl: URL could not be created
    /// - responseError: The request was unsuccessful due to an error
    /// - responseNoData: The request returned no usable data
    enum NetworkError: Int {
        case badUrl
        case responseError
        case responseNoData
        case decodeError
    }
    
    /// FetchUserDatas - retrieve a list of
    ///
    /// - Parameter completion: Closure that returns UserData on success, an Error on failure
    class func fetchUserDatasByPage(_ page: Int  ,completion: @escaping (Swift.Result<[UserData], Error>) -> Void) {
        let baseURL = "https://api.thecatapi.com/v1/breeds?limit=10"
        /// Create the URL for the request
        guard let url = URL(string: baseURL+"&page=\(page)") else {
            let error = NSError(domain: "Network.fetchUserDataList", code: NetworkError.badUrl.rawValue, userInfo: nil)
            return completion(Result.failure(error))
        }
        
        /// Start a data task for the URL
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            /// Check against errors
            guard error == nil else {
                let error = NSError(domain: "Network.fetchUserDataList", code: NetworkError.responseError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            /// Check for non-nil response data
            guard let data = data else {
                let error = NSError(domain: "Network.fetchUserDataList", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            do {
                let breeds: [UserData]
                
                /// Decode the JSON response into a UserData object array
                breeds = try JSONDecoder().decode([UserData].self, from: data)
                
                /// Return the data
                completion(.success(breeds))

            } catch {

                /// Unable to decode the response
                let error = NSError(domain: "Network.decode", code: NetworkError.decodeError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
        }.resume()
    }
    
    
    /// FetchUserDatas - retrieve a list of
    ///
    /// - Parameter completion: Closure that returns UserData on success, an Error on failure
    class func fetchUserDatas(completion: @escaping (Swift.Result<[UserData], Error>) -> Void) {
        
        /// Create the URL for the request
        guard let url = URL(string: "https://api.thecatapi.com/v1/breeds?limit=10&page=0") else {
            let error = NSError(domain: "Network.fetchUserDataList", code: NetworkError.badUrl.rawValue, userInfo: nil)
            return completion(Result.failure(error))
        }
        
        /// Start a data task for the URL
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            /// Check against errors
            guard error == nil else {
                let error = NSError(domain: "Network.fetchUserDataList", code: NetworkError.responseError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            /// Check for non-nil response data
            guard let data = data else {
                let error = NSError(domain: "Network.fetchUserDataList", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            do {
                let breeds: [UserData]
                /// Decode the JSON response into a UserData object array
                breeds = try JSONDecoder().decode([UserData].self, from: data)
                /// Return the data
                completion(.success(breeds))
            } catch {
                /// Unable to decode the response
                let error = NSError(domain: "Network.decode", code: NetworkError.decodeError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
        }.resume()
    }
    
 
    /// FetchUserDatas - retrieve a list of c
    ///
    /// - Parameter completion: Closure that returns UserData on success, an Error on failure
    class func fetchUserDatasSearch(_ breedName: String ,completion: @escaping (Swift.Result<[UserData], Error>) -> Void) {
        //let basehttps://api.thecatapi.com/v1/images/search?breed_ids=beng&include_breeds=true
        let baseURL = "https://api.thecatapi.com/v1/images/"
        let query  =  "search?breed_ids="+"\(breedName)"+"&include_breeds=true"
        
        /// Create the URL for the request
        guard let url = URL(string: baseURL + query) else {
            let error = NSError(domain: "Network.fetchUserDatas", code: NetworkError.badUrl.rawValue, userInfo: nil)
            return completion(Result.failure(error))
        }
        
        /// Start a data task for the URL
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            /// Check against errors
            guard error == nil else {
                let error = NSError(domain: "Network.fetchUserDatas", code: NetworkError.responseError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            /// Check for non-nil response data
            guard let data = data else {
                let error = NSError(domain: "Network.fetchUserDatas", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            do {
                let breeds: [UserData]
                
                /// Decode the JSON response into a UserData object array
                breeds = try JSONDecoder().decode([UserData].self, from: data)
                
                /// Return the data
                completion(.success(breeds))

            } catch {

                /// Unable to decode the response
                let error = NSError(domain: "Network.decode", code: NetworkError.decodeError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
        }.resume()
    }
    
    class func fetchuserDetails(breedId: String, completion: @escaping (Swift.Result<UIImage, Error>) -> Void) {

        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?breed_ids=\(breedId)&include_breeds=true") else {
            let error = NSError(domain: "Network.fetchuserDetails", code: NetworkError.badUrl.rawValue, userInfo: nil)
            return completion(Result.failure(error))
        }
        
 
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard error == nil else {
                let error = NSError(domain: "Network.fetchuserDetails", code: NetworkError.responseError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            guard let data = data else {
                let error = NSError(domain: "Network.fetchuserDetails", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }
            
            do {
                let userDetails: [UserDetails]
                
                userDetails = try JSONDecoder().decode([UserDetails].self, from: data)
                
                guard let userDetailImageUrl = userDetails.first?.url else {
                    let error = NSError(domain: "Network.fetchuserDetails", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                    return completion(Result.failure(error))
                }
                
                guard let catImageUrl = URL(string: userDetailImageUrl) else {
                    let error = NSError(domain: "Network.fetchuserDetails", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                    return completion(Result.failure(error))
                }
                
                let imageData = try Data(contentsOf: catImageUrl)
                
                guard let image = UIImage(data: imageData) else {
                    let error = NSError(domain: "Network.fetchuserDetails", code: NetworkError.responseNoData.rawValue, userInfo: nil)
                    return completion(Result.failure(error))
                }
                
                completion(.success(image))

            } catch {

                let error = NSError(domain: "Network.decode", code: NetworkError.decodeError.rawValue, userInfo: nil)
                return completion(Result.failure(error))
            }

        }.resume()
    }
}

