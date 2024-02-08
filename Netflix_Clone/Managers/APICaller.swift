import Foundation

struct Constant {
    static let apiPrefix = "https://api.themoviedb.org/3/"
    static let youtubeApi_Key = "AIzaSyDR89uW4p6E8_62ft9u85b0qK9ooSRD2-g"
    static let authorization = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkYWRhZTZiNDg4YThlMzY0NjYyZmMzMzhjZDRhYjI3MyIsInN1YiI6IjYxMmExYTNiNDJmMTlmMDA5NTc4MDk3NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.f7Li3XBaRRUyACOH220EAraTNC5Aj0aasKfs5icTyEU"
    static let youtubeUrl = "https://youtube.googleapis.com/youtube/v3/search?"
}

//enum APIError: Error {
//    case fetchingDataFailure
//}

class APICaller {
    static let shared = APICaller()
    
    func fetchTrendingData(completion: @escaping (Result<[Title], Error>) ->Void) {

        let headers = [
          "accept": "application/json",
          "Authorization": Constant.authorization
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "\(Constant.apiPrefix)trending/movie/day?language=en-US")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TrendingResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        })

        dataTask.resume()
    }
    
    func fetchTrendingTVData(completion: @escaping (Result<[Title], Error>) ->Void) {

        let headers = [
          "accept": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkYWRhZTZiNDg4YThlMzY0NjYyZmMzMzhjZDRhYjI3MyIsInN1YiI6IjYxMmExYTNiNDJmMTlmMDA5NTc4MDk3NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.f7Li3XBaRRUyACOH220EAraTNC5Aj0aasKfs5icTyEU"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/trending/tv/day?language=en-US")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TrendingResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        })

        dataTask.resume()
    }
    
    func fetchPopularMovieData(completion: @escaping (Result<[Title], Error>) ->Void) {

        let headers = [
          "accept": "application/json",
          "Authorization": Constant.authorization
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "\(Constant.apiPrefix)movie/popular?language=en-US&page=1")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TrendingResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        })

        dataTask.resume()
    }
    
    func fetchUpcomingMovieData(completion: @escaping (Result<[Title], Error>) ->Void) {

        let headers = [
          "accept": "application/json",
          "Authorization": Constant.authorization
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "\(Constant.apiPrefix)movie/upcoming?language=en-US&page=1")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TrendingResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        })

        dataTask.resume()
    }

    func fetchTopRatedMovieData(completion: @escaping (Result<[Title], Error>) ->Void) {

        let headers = [
          "accept": "application/json",
          "Authorization": Constant.authorization
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "\(Constant.apiPrefix)movie/top_rated?language=en-US&page=1")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }

            do {
                let result = try JSONDecoder().decode(TrendingResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        })

        dataTask.resume()
    }

    func fetchSearchResult(prefix: String, completion: @escaping (Result<[Title], Error>) ->Void) {
        guard let prefix = prefix.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }

        let headers = [
          "accept": "application/json",
          "Authorization": Constant.authorization
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "\(Constant.apiPrefix)search/movie?query=\(prefix)&include_adult=false&language=en-US&page=1")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }

            do {
                let result = try JSONDecoder().decode(TrendingResponse.self, from: data)
                completion(.success(result.results))
            } catch {
                completion(.failure(error))
            }
        })

        dataTask.resume()
    }

    func getMovies(query: String, completion: @escaping (Result<VideoElement, Error>) ->Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }

        guard let url = URL(string: "\(Constant.youtubeUrl)q=\(query)&key=\(Constant.youtubeApi_Key)") else {
            return
        }

        let session = URLSession.shared
        let dataTask = session.dataTask(with: URLRequest(url: url), completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                return
            }

            do {
                let result =  try JSONDecoder().decode(youtubeRequestResult.self, from: data)
                completion(.success(result.items[0]))
            } catch {
                completion(.failure(error))
                print(error.localizedDescription)
            }
        })

        dataTask.resume()
    }
}
