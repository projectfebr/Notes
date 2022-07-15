//
//  Note.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 14.07.2022.
//

import Foundation
import UIKit
import CoreData

struct Note {
    let image: UIImage?
    let date: Date
    let text: String

    static func toNoteEntity(_ note: Note) -> NoteEntity {
        let noteEntity = NoteEntity()
        noteEntity.text = note.text
        noteEntity.date = note.date
        if let image = note.image?.jpegData(compressionQuality: 1) {
            noteEntity.image = image
        }
        return noteEntity
    }

    static func fromNoteEntity(_ noteEnity: NoteEntity) -> Note? {
        if let imageData = noteEnity.image, let date = noteEnity.date, let text = noteEnity.text {
            return Note(image: UIImage(data: imageData), date: date, text: text)
        }
        return nil
    }
}
