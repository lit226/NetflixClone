import UIKit

enum Sections: Int {
    case trendingMovie = 0
    case trendingTV = 1
    case popular = 2
    case upcoming = 3
    case topRated = 4
}

class HomeViewController: UIViewController {

    private var getTitles: Title?
    private var headerView: UIHeaderView?
    let sectionHeader: [String] = ["Trending", "Trending TV", "Popular", "Upcoming Movies", "Top Rated"]

    private var homeFeedTable: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(HomeViewTableViewCell.self, forCellReuseIdentifier: HomeViewTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBackground

        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self

        setupNavBar()
        
        headerView = UIHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400))
        homeFeedTable.tableHeaderView = headerView
        
        configureHeaderView()
    }
    
    private func configureHeaderView() {
        APICaller.shared.fetchTrendingData { [weak self] result in
            switch result {
            case .success(let title):
                let randomTitle = title.randomElement()
                self?.getTitles = randomTitle
                self?.headerView?.configure( "https://image.tmdb.org/t/p/w500/\(randomTitle?.poster_path ?? "")")
            case .failure(let error):
                print(error)
            }
        }
    }

    private func setupNavBar() {
        var image = UIImage(named: "NetflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        homeFeedTable.frame = view.bounds
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewTableViewCell.identifier, for: indexPath) as? HomeViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        switch indexPath.section {
        case Sections.trendingMovie.rawValue:
            APICaller.shared.fetchTrendingData { result in
                switch result {
                case .success(let title):
                    cell.configure(title: title)
                case .failure(let error):
                    print(error)
                }
            }

        case Sections.trendingTV.rawValue:
            APICaller.shared.fetchTrendingTVData { result in
                switch result {
                case .success(let title):
                    cell.configure(title: title)
                case .failure(let error):
                    print(error)
                }
            }

        case Sections.popular.rawValue:
            APICaller.shared.fetchPopularMovieData { result in
                switch result {
                case .success(let title):
                    cell.configure(title: title)
                case .failure(let error):
                    print(error)
                }
            }

        case Sections.upcoming.rawValue:
            APICaller.shared.fetchUpcomingMovieData { result in
                switch result {
                case .success(let title):
                    cell.configure(title: title)
                case .failure(let error):
                    print(error)
                }
            }

        case Sections.topRated.rawValue:
            APICaller.shared.fetchTopRatedMovieData { result in
                switch result {
                case .success(let title):
                    cell.configure(title: title)
                case .failure(let error):
                    print(error)
                }
            }

        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionHeader[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else {
            return
        }
        
        headerView.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        headerView.textLabel?.frame = CGRect(x: headerView.bounds.origin.x + 20, y: headerView.bounds.origin.y, width: 100, height: headerView.bounds.height)
        headerView.textLabel?.textColor = .white
        headerView.textLabel?.text = headerView.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: HomeViewTableViewCellDelegate {

    func HomeViewTableViewCellDidTapped(_ cell: HomeViewTableViewCell, model: TitlePrevievViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(model: model)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
