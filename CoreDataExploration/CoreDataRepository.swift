//
//  CoreDataRepository.swift
//  CoreDataExploration
//
//  Created by Andrew Althage on 2/4/23.
//

import CoreData
import Foundation

/// Helper for working with CoreData entities
struct CoreDataRepository<Entity: NSManagedObject> {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetch(sortDescriptors: [NSSortDescriptor] = [],
               predicate: NSPredicate? = nil) -> Result<[Entity], Error>
    {
        let request = Entity.fetchRequest()
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate

        do {
            let results = try context.fetch(request) as! [Entity]
            return .success(results)
        } catch {
            return .failure(error)
        }
    }

    func getById(_ id: NSManagedObjectID) -> Result<Entity, Error> {
        guard let entity = try? context.existingObject(with: id) as? Entity else {
            return .failure(Errors.objectNotFound)
        }

        return .success(entity)
    }

    func create(_ body: @escaping (inout Entity) -> Void) -> Result<Entity, Error> {
        var entity = Entity(context: context)
        body(&entity)
        do {
            try context.save()
            return .success(entity)
        } catch {
            return .failure(error)
        }
    }

    func update(_ entity: Entity) -> Result<Entity, Error> {
        do {
            try context.save()
            return .success(entity)
        } catch {
            return .failure(error)
        }
    }

    func delete(_ entity: Entity) -> Result<Void, Error> {
        do {
            context.delete(entity)
            try context.save()
            return .success(())
        } catch {
            return .failure(error)
        }
    }

    enum Errors: Error {
        case objectNotFound
    }
}
