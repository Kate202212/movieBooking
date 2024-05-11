import Foundation

struct Movie: Decodable, Identifiable {
    let id: Int
    let title: String
    let releaseDate: String
    let genre: [String]
    let duration: String
    let overview: String
    let director: String
    let cast: [String]
    let posterPath: String
}

class APIManager {
    static let shared = APIManager()
    private let apiKey = "ecfcd92abcf0735492247a8eae3c742a"
    private let baseURL = "https://api.themoviedb.org/3/"

    func fetchMovies(completion: @escaping ([Movie]) -> Void) {
        let url = "\(baseURL)movie/popular?api_key=\(apiKey)"
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            let movies = (try? JSONDecoder().decode([Movie].self, from: data)) ?? []
            DispatchQueue.main.async {
                completion(movies)
            }
        }.resume()
    }
}
