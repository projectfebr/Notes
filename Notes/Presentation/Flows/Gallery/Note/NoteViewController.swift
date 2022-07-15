//
//  NoteViewController.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 15.07.2022.
//

import UIKit

class NoteViewController: UIViewController {
    static let nibName = "NoteViewController"

    var note: Note

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.layer.cornerRadius = 8
            imageView.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet weak var dateLabel: UILabel!
        {
            didSet {
                dateLabel.text = ""
            }
        }
    @IBOutlet weak var timeLabel: UILabel!
    {
        didSet {
            timeLabel.text = ""
        }
    }
    @IBOutlet weak var textLabel: UILabel!
    {
        didSet {
            textLabel.text = ""
        }
    }

    init(note: Note, nibName: String) {
        self.note = note
        super.init(nibName: nibName, bundle: nil)
    }

    init?(note: Note, coder: NSCoder) {
        self.note = note
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews(){
        imageView.image = note.image ?? UIImage(systemName: "photo")
        textLabel.text = note.text
        dateLabel.text = note.date.formatted(timeStyle: .none, dateStyle: .medium)
        timeLabel.text = note.date.formatted(timeStyle: .short, dateStyle: .none)
    }

}
