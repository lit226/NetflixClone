import Foundation

struct TrendingResponse: Codable {
    let results: [Title]
}

struct Title: Codable {
    let id: Int
    let media_type: String?
    let release_date: String?
    let title: String?
    let original_language: String?
    let original_title: String?
    let overview: String?
    let popularity: Double
    let poster_path: String?
    let vote_average: Double
    let vote_count: Int
}
