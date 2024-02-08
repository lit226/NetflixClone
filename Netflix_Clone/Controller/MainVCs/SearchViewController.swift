import UIKit

class SearchViewController: UIViewController {

    private var titles:[Title] = [Title]()
    
    private let discoverTable: UITableView = {
        let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tableView
    }()
    
    private let searchViewController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.placeholder = "Search Movie or Tv shows"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(discoverTable)
        navigationItem.searchController = searchViewController
        navigationController?.navigationBar.tintColor = .white
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        fetchUpcomingData()
        
        searchViewController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoverTable.frame = view.bounds
    }
    
    private func fetchUpcomingData() {
        APICaller.shared.fetchUpcomingMovieData { result in
            switch result {
            case .success(let title):
                self.titles = title
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self.discoverTable.reloadData()
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier, for: indexPath) as? UpcomingTableViewCell else {
            return UITableViewCell()
        }

        guard let titleName = titles[indexPath.row].original_title, let imagePath = titles[indexPath.row].poster_path else {
            return UITableViewCell()
        }
        
        cell.configure(TitleViewModel(titleName: titleName, posterUrl: "https://image.tmdb.org/t/p/w500/\(imagePath)"))

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let newtitle = titles[indexPath.row]
        
        guard let movieTitle = newtitle.original_title else {
            return
        }
        
        APICaller.shared.getMovies(query: movieTitle) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(model: TitlePrevievViewModel(title: movieTitle, videoId: videoElement, previewTitle: newtitle.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultViewControllerDelegate {
    func SearchResultViewControllerDidTapItem(_ model: TitlePrevievViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(model: TitlePrevievViewModel(title: model.title, videoId: model.videoId, previewTitle: model.previewTitle))
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              query.trimmingCharacters(in: .whitespacesAndNewlines).count >= 3,
              let searchController = searchController.searchResultsController as? SearchResultViewController else {
            return
        }
        
        searchController.delegate = self
        APICaller.shared.fetchSearchResult(prefix: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let title):
                    searchController.titles = title
                    searchController.searchCollectionView.reloadData()
                case .failure(let error):
                    print("searchViewController: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
