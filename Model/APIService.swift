import Foundation

// Provides functionalities to fetch movies and their details from the TMDB API.
class APIService {
    // Fetches a list of popular movies.
    func fetchMovies(completion: @escaping ([Movie]) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=ecfcd92abcf0735492247a8eae3c742a")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching movies: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }
            do {
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(movieResponse.results)
                }
            } catch {
                print("Error decoding movie list: \(error)")
                completion([])
            }
        }.resume()
    }

    // Fetches detailed information about a specific movie.
    func fetchMovieDetails(movieId: Int, completion: @escaping (Movie?) -> Void) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieId)?api_key=ecfcd92abcf0735492247a8eae3c742a&append_to_response=credits")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching movie details: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            do {
                let decodedResponse = try JSONDecoder().decode(Movie.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedResponse)
                }
            } catch {
                print("Error decoding movie details: \(error)")
                completion(nil)
            }
        }.resume()
    }
}

// Helper structure to decode the list of movies from the API response.
struct MovieResponse: Decodable {
    let results: [Movie]
}
