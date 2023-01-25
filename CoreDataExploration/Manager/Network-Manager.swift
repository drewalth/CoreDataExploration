//
//  Network-Manager.swift
//  CoreDataExploration
//
//  Created by Drew Althage on 1/23/23.
//

import Alamofire
import Foundation

typealias NetworkError = AFError

class NetworkManager {
    static let instance = NetworkManager()

    private let baseUrl = "http://localhost:3000"

    func get<Output: Decodable>(_ url: String,
                                output _: Output.Type,
                                completion: @escaping (Result<Output, NetworkError>) -> Void)
    {
        let decoder = CoreDataJSONDecorder().decoder

        AF.request(baseUrl + url).validate().responseDecodable(of: Output.self, decoder: decoder) { response in

            completion(response.result)
        }
    }
}
