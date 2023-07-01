//
//  Network-Manager.swift
//  CoreDataExploration
//
//  Created by Drew Althage on 1/23/23.
//

import Alamofire
import Foundation

typealias NetworkError = AFError

enum RequestStatus {
    case loading, success, failure
}

struct NetworkManager {
    private let baseUrl = "http://localhost:3000"
    private let decoder = CoreDataJSONDecoder().decoder

    struct ResponseMessage: Decodable {
        let message: String
    }

    func get<Output: Decodable>(_ url: String,
                                output _: Output.Type,
                                completion: @escaping (Result<Output, NetworkError>) -> Void)
    {
        AF.request(baseUrl + url).validate().responseDecodable(of: Output.self, decoder: decoder) { response in

            completion(response.result)
        }
    }

    func post<Input: Encodable, Output: Decodable>(_ url: String,
                                                   input: Input,
                                                   output _: Output.Type,
                                                   completion: @escaping (Result<Output, NetworkError>) -> Void)
    {
        AF.request(baseUrl + url,
                   method: .post,
                   parameters: input,
                   encoder: .json,
                   headers: [
                       .init(name: "Content-Type", value: "application/json"),
                   ])
                   .validate()
                   .responseDecodable(of: Output.self, decoder: decoder) { response in
                       completion(response.result)
                   }
    }
}
