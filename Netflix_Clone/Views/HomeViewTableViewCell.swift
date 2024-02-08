import UIKit

protocol HomeViewTableViewCellDelegate: AnyObject {
    func HomeViewTableViewCellDidTapped(_ cell: HomeViewTableViewCell, model: TitlePrevievViewModel)
}

class HomeViewTableViewCell: UITableViewCell {

    weak var delegate: (HomeViewTableViewCellDelegate)?
    
    static var identifier = "HomeViewTableViewCell"
    
    private var title: [Title] = [Title]()
    
    private var collectionview: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 120, height: 180)
        let collectionCell = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionCell.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionCell
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionview)
        
        collectionview.delegate = self
        collectionview.dataSource = self
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        collectionview.frame = contentView.bounds
    }
    
    public func configure(title: [Title]) {
        self.title = title
        DispatchQueue.main.async { [weak self] in
            self?.collectionview.reloadData()
        }
    }
    
    private func downloadMovie(indexPath: IndexPath) {
        DataPersistenceManager.shared.downloadTitle(model: title[indexPath.row]) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension HomeViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return title.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard let path = title[indexPath.row].poster_path else {
            return UICollectionViewCell()
        }

        cell.configure("https://image.tmdb.org/t/p/w500/\(path)")
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = title[indexPath.row]
        guard let movieName = title.original_title ?? title.title else {
            return
        }
        
        APICaller.shared.getMovies(query: movieName + " trailer") { [weak self] result in
            switch result {
            case .success(let result):
                guard let movieOverview = self?.title[indexPath.row].overview, let superSelf = self else {
                    return
                }

                let model = TitlePrevievViewModel(title: movieName, videoId: result, previewTitle: movieOverview)
                self?.delegate?.HomeViewTableViewCellDidTapped(superSelf, model: model)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { [weak self] _ in
            let menuAction = UIAction(title: "Download",
                                      subtitle: nil,
                                      image: nil,
                                      selectedImage: nil,
                                      identifier: nil,
                                      discoverabilityTitle: nil,
                                      state: .off) { _ in
                self?.downloadMovie(indexPath: indexPaths[0])
            }

            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [menuAction])
        }

        return config
    }
}
