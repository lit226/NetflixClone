import UIKit
import SDWebImage

class UpcomingTableViewCell: UITableViewCell {

    static let identifier = "UpcomingTableViewCell"

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let playButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(posterImageView)
        contentView.addSubview(movieNameLabel)
        contentView.addSubview(playButton)

        addConstraint()
    }

    private func addConstraint() {
        // Poster Image constraints
        let posterImageConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant:10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 140)
        ]
        NSLayoutConstraint.activate(posterImageConstraints)

        // Movie Name Label constraints
        let movieNameLabelConstraints = [
            movieNameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 20),
            movieNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(movieNameLabelConstraints)

        // Play button constraints
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: movieNameLabel.trailingAnchor, constant: 10),
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(_ title: TitleViewModel) {
        guard let url = URL(string: title.posterUrl) else {return}
        posterImageView.sd_setImage(with: url, completed: nil)
        movieNameLabel.text = title.titleName
    }
}
