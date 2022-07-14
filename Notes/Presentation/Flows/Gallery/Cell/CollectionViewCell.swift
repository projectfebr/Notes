//
// ,e CollectionViewCell.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 13.07.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseID = String(describing: CollectionViewCell.self)
    static let nib = UINib(nibName: String(describing: CollectionViewCell.self), bundle: nil)

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 4
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        imageView.contentMode = .scaleAspectFill
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateContentSyle()
    }

    func update(date: Date, image: UIImage?) {
        imageView.image = image
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        dateLabel.text = formatter.string(from: date)
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: date)
    }

    private func updateContentSyle() {
        let isHorizontalStyle = bounds.width > 2 * bounds.height
        let oldAxis = stackView.axis
        let newAxis: NSLayoutConstraint.Axis = isHorizontalStyle ? .horizontal : .vertical
        guard oldAxis != newAxis else { return }

        stackView.axis = newAxis
        stackView.spacing = isHorizontalStyle ? 16 : 0
        stackView.distribution = isHorizontalStyle ? UIStackView.Distribution.fill : UIStackView.Distribution.fillProportionally
        dateLabel.textAlignment = isHorizontalStyle ? .left : .center
        timeLabel.textAlignment = isHorizontalStyle ? .left : .center
        let fontTransform: CGAffineTransform = isHorizontalStyle ? .identity : CGAffineTransform(scaleX: 0.8, y: 0.8)

        UIView.animate(withDuration: 0.3) {
            self.dateLabel.transform = fontTransform
            self.timeLabel.transform = fontTransform
            self.layoutIfNeeded()
        }
    }

}
