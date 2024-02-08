import UIKit

class UpcomingViewController: UIViewController {
    
    private var titles:[Title] = [Title]()
    
    private let upcomingTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(upcomingTableView)
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        fetchUpcomingData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
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
                self.upcomingTableView.reloadData()
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingTableViewCell.identifier) as? UpcomingTableViewCell else {
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
