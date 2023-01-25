//
//  ItemEntity-Model.swift
//  CoreDataExploration
//
//  Created by Drew Althage on 1/23/23.
//

import CoreData
import Foundation

class ItemEntity: NSManagedObject, Codable {
    required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw CoreDataJSONDecorder.DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(context: context)

        // get all the fields
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let uuidString = try container.decode(String.self, forKey: .id)
        id = UUID(uuidString: uuidString)
        title = try container.decode(String.self, forKey: .title)
        subtitle = try container.decode(String.self, forKey: .subtitle)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(subtitle, forKey: .subtitle)
        try container.encode(id, forKey: .id)
    }

    enum CodingKeys: CodingKey {
        case title, subtitle, id
    }
}
