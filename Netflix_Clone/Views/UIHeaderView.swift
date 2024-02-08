import UIKit
import SDWebImage

class UIHeaderView: UIView {

    let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = false
        return image
    }()
    
    let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        setGradient()
        
        addSubview(playButton)
        addPlayButtonConstraint()
        
        addSubview(downloadButton)
        addDownloadButtonConstraints()
    }
    
    private func addDownloadButtonConstraints() {
        let downloadButtonConstraints = [
            downloadButton.leadingAnchor.constraint(equalTo: trailingAnchor, constant: -200),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    private func addPlayButtonConstraint() {
        let playButtonConstraint = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(playButtonConstraint)
    }
    
    private func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    public func configure(_ movie: String) {
        guard let url = URL(string: movie) else {return}
        imageView.sd_setImage(with: url, completed: nil)
    }

}
