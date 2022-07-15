//
//  GalleryViewController.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 13.07.2022.
//

import UIKit
import CoreData

class GalleryViewController: UIViewController {
    private enum PresentationStyle: String, CaseIterable {
        case table
        case defaultGrid
        case customGrid

        var buttonImage: UIImage {
            switch self {
            case .table: return  #imageLiteral(resourceName: "table")
            case .defaultGrid: return  #imageLiteral(resourceName: "default_grid")
            case .customGrid: return  #imageLiteral(resourceName: "custom_grid")
            }
        }
    }

    private var styleDelegates: [PresentationStyle: DefaultCollectionViewDelegate] = {
        let result: [PresentationStyle: DefaultCollectionViewDelegate] = [
            .table: TabledContentCollectionViewDelegate(),
            .defaultGrid: DefaultGriddedContentCollectionViewDelegate(),
            .customGrid: CustomGriddedContentCollectionViewDelegate(),
        ]
        return result
    }()

    var notes: [Note] = []

    private var selectedStyle: PresentationStyle = .table {
        didSet { updatePresentationStyle() }
    }

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: selectedStyle.buttonImage, style: .plain, target: self, action: #selector(changeContentLayout))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
    }

    private func fetchNotes() {
        do {
            let noteEntity = try StorageService.fetch()
            let notesList = noteEntity.map({ entity in
                Note.fromNoteEntity(entity)
            })
            notes = notesList.compactMap({$0})
            collectionView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    private func setupCollectionView() {
        styleDelegates.values.forEach {
                $0.didSelectItem = { [unowned self] indexPath in
                    let vc = NoteViewController(note: self.notes[indexPath.row], nibName: NoteViewController.nibName)
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        collectionView.delegate = styleDelegates[selectedStyle]
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.register(CollectionViewCell.nib, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
    }

    private func updatePresentationStyle() {
        navigationItem.rightBarButtonItem?.image = selectedStyle.buttonImage
        collectionView.delegate = styleDelegates[selectedStyle]
        collectionView.performBatchUpdates {
            collectionView.reloadData()
        }
        navigationItem.rightBarButtonItem?.image = selectedStyle.buttonImage
    }

    @objc private func changeContentLayout() {
        let allCases = PresentationStyle.allCases
        guard let index = allCases.firstIndex(of: selectedStyle) else { return }
        let nextIndex = (index + 1) % allCases.count
        selectedStyle = allCases[nextIndex]
    }
}

// MARK: Implements UICollectionViewDataSource
extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        let note = notes[indexPath.row]
        cell.update(date: note.date, image: note.image)
        return cell
    }
}
