import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {

    static let identifier = "TitleCollectionViewCell"

    let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellImage)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cellImage.frame = contentView.bounds
    }

    public func configure(_ movie: String) {
        guard let url = URL(string: movie) else {return}
        cellImage.sd_setImage(with: url, completed: nil)
    }
}
