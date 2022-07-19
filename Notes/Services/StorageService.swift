//
//  StorageService.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 14.07.2022.
//

import Foundation
import CoreData

class StorageService {
    static func save(note: Note) throws {
        let context = CoreDataService.shared.persistentContainer.viewContext
        let noteEntity = NoteEntity(context: context)
        noteEntity.date = note.date
        if let imageData = note.image?.jpegData(compressionQuality: 1) {
            noteEntity.image = imageData
        }
        noteEntity.text = note.text

        do {
            try context.save()
        } catch let error as NSError {
            throw error
        }
    }

    static func fetch() throws -> [NoteEntity] {
        let context = CoreDataService.shared.persistentContainer.viewContext
        let fetchRequest =
        NSFetchRequest<NoteEntity>(entityName: "NoteEntity")

        do {
            let notes = try context.fetch(fetchRequest)
            return notes
        } catch let error as NSError {
            throw error
        }
    }
}
