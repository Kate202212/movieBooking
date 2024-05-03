import SwiftUI

// View for displaying detailed information about a selected movie.
struct MovieDetailView: View {
    var movie: Movie
    var apiService = APIService()

    @State private var fullMovieDetails: Movie?
    @State private var showBookingView = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")!) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray
                    }
                    .frame(height: 300)

                    if let fullDetails = fullMovieDetails {
                        Text(fullDetails.title).font(.title).padding()
                        Text("Release Date: \(fullDetails.releaseDate)").padding()
                        Text("Duration: \(fullDetails.runtime ?? 0) minutes").padding()
                        Text("Director: \(fullDetails.credits?.crew.first { $0.job == "Director" }?.name ?? "Unknown")").padding()
                        Text(fullDetails.overview).padding()
                        Text("Cast: \(fullDetails.credits?.cast.map { $0.name }.joined(separator: ", ") ?? "No cast info")").padding()
                    }

                    Button("Book Tickets") {
                        showBookingView = true
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
            }
            .navigationDestination(isPresented: $showBookingView) {
                BookingView(movie: movie)
            }
            .onAppear {
                apiService.fetchMovieDetails(movieId: movie.id) { fetchedDetails in
                    fullMovieDetails = fetchedDetails
                }
            }
        }
    }
}
