import Foundation

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let release_date: String
    let poster_path: String?  // Optional relative path

    var posterURL: URL? {
        guard let poster_path = poster_path else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path)")
    }
}

struct MoviesResponse: Decodable {
    let results: [Movie]
}
