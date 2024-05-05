import SwiftUI

// View that lists all movies fetched from the API.
struct MovieListView: View {
    @State private var movies: [Movie] = []
    var apiService = APIService()

    var body: some View {
        NavigationView {
            List(movies, id: \.id) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    HStack {
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")!) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 100, height: 150)
                        .cornerRadius(8)

                        VStack(alignment: .leading) {
                            Text(movie.title).font(.headline)
                            Text("Release Date: \(movie.releaseDate)").font(.subheadline)
                        }
                    }
                }
            }
            .navigationTitle("Movies")
        }
        .onAppear {
            apiService.fetchMovies { fetchedMovies in
                movies = fetchedMovies
            }
        }
    }
}

#Preview {
    MovieListView()
}
