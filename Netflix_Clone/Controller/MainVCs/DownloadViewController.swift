import UIKit

class DownloadViewController: UIViewController {

    private var titles:[TitleDataModel] = [TitleDataModel]()
    
    private let downloadsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UpcomingTableViewCell.self, forCellReuseIdentifier: UpcomingTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Download"
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(downloadsTableView)
        downloadsTableView.delegate = self
        downloadsTableView.dataSource = self
        fetchDataFromLocalStorage()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchDataFromLocalStorage()
        }
    }
    
    private func fetchDataFromLocalStorage() {
        DataPersistenceManager.shared.fetchData { [weak self] result in
            switch result {
            case .success(let titleDataModel):
                self?.titles = titleDataModel
                DispatchQueue.main.async {
                    self?.downloadsTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTableView.frame = view.bounds
    }
}

extension DownloadViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteData(model: titles[indexPath.row]) { result in
                switch result {
                case .success():
                    print("Data deleted")
                case .failure(let error):
                    print(error)
                }
            }
            self.titles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
        }
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
