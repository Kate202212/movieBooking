import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    var cancellables = Set<AnyCancellable>()

    func fetchMovies() {
        let apiKey = "ecfcd92abcf0735492247a8eae3c742a"  // API key
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MoviesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error: \(error)")
                    // Here you could update your model to reflect the error state
                }
            }, receiveValue: { [weak self] response in
                self?.movies = response.results
            })
            .store(in: &cancellables)
    }
}
