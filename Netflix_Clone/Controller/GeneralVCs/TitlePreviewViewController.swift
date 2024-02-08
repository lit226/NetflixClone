import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 24, weight: .bold)
        title.text = "Harry Potter"
        title.tintColor = .black
        return title
    }()
    
    private let previewTitle: UILabel = {
        let previewTitle = UILabel()
        previewTitle.translatesAutoresizingMaskIntoConstraints = false
        previewTitle.font = .systemFont(ofSize: 18, weight: .regular)
        previewTitle.numberOfLines = 0
        previewTitle.tintColor = .black
        previewTitle.text = "Moview about witches and wizards"
        return previewTitle
    }()
    
    private let downloadButton: UIButton = {
        let downloadButton = UIButton()
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadButton.setTitle("Download", for: .normal)
        downloadButton.setTitleColor(.black, for: .normal)
        downloadButton.backgroundColor = .red
        downloadButton.layer.cornerRadius = 8
        downloadButton.layer.masksToBounds = true
        return downloadButton
    }()
    
    private let webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(previewTitle)
        view.addSubview(downloadButton)
        
        configureConstraints()
    }
    
    func configureConstraints() {
        let webviewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let previewTitleConstraints = [
            previewTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            previewTitle.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            previewTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.topAnchor.constraint(equalTo: previewTitle.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 40),
            downloadButton.widthAnchor.constraint(equalToConstant: 140)
        ]
        
        NSLayoutConstraint.activate(webviewConstraints)
        NSLayoutConstraint.activate(titleConstraints)
        NSLayoutConstraint.activate(previewTitleConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(model: TitlePrevievViewModel) {
        titleLabel.text = model.title
        previewTitle.text = model.previewTitle
        
        guard let videoId = model.videoId.id.videoId else {
            return
        }
        guard let url = URL(string: "https://www.youtube.com/embed/\(videoId)") else {
            return
        }

        webView.load(URLRequest(url: url))
    }

}
