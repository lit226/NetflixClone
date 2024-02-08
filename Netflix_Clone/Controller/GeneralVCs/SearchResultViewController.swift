import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func SearchResultViewControllerDidTapItem(_ model: TitlePrevievViewModel)
}

class SearchResultViewController: UIViewController {
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    public var titles: [Title] = [Title]()

    public let searchCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 15, height: 200)
        layout.minimumInteritemSpacing = 0
        let collectionCell = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionCell.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionCell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(searchCollectionView)
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchCollectionView.frame = view.bounds
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }

        let path = titles[indexPath.row].poster_path ?? ""
        cell.configure("https://image.tmdb.org/t/p/w500/\(path)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let newtitle = titles[indexPath.row]
        
        guard let movieTitle = newtitle.original_title else {
            return
        }
        
        APICaller.shared.getMovies(query: movieTitle) { [weak self] result in
            switch result {
            case .success(let videoElement):
                self?.delegate?.SearchResultViewControllerDidTapItem(TitlePrevievViewModel(title: movieTitle, videoId: videoElement, previewTitle: newtitle.overview ?? ""))
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
