//
//  CoreDataJSONDecoder.swift
//  CoreDataExploration
//
//  Created by Drew Althage on 1/23/23.
//

import Foundation

struct CoreDataJSONDecoder {
    let decoder: JSONDecoder

    init() {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = PersistenceController.shared.container.viewContext
        self.decoder = decoder
    }

    enum DecoderConfigurationError: Error {
        case missingManagedObjectContext
    }
}
