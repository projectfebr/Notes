//
//  GalleryViewController.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 13.07.2022.
//

import UIKit

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

    private var styleDelegates: [PresentationStyle: CollectionViewSelectableItemDelegate] = {
        let result: [PresentationStyle: CollectionViewSelectableItemDelegate] = [
            .table: TabledContentCollectionViewDelegate(),
            .defaultGrid: DefaultGriddedContentCollectionViewDelegate(),
            .customGrid: CustomGriddedContentCollectionViewDelegate(),
        ]
        result.values.forEach {
            $0.didSelectItem = { _ in
                print("Item selected")
            }
        }
        return result
    }()

    private var datasource: [Dog] = DogsProvider.get()

    private var selectedStyle: PresentationStyle = .table {
        didSet { updatePresentationStyle() }
    }

    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: selectedStyle.buttonImage, style: .plain, target: self, action: #selector(changeContentLayout))
    }

    private func setupCollectionView() {
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

extension GalleryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
        let dog = datasource[indexPath.item]
        cell.update(date: dog.date, image: dog.image)
        return cell
    }
}
