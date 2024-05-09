import SwiftUI

struct MovieListView: View {
    @State private var movies: [Movie] = []
    @State var currentTab: Tab = .home
    var apiService = APIService()

    // State for ticket data
    @State private var movie: Movie?
    @State private var selectedDate: Date?
    @State private var selectedTime: String?
    @State private var selectedSeats: String?
    @State private var hasTicket: Bool = false

    var body: some View {
        VStack(spacing: 0.0) {
            TabView(selection: $currentTab) {
                Text("Location")
                    .tag(Tab.location)

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
                
                .tag(Tab.home)

                if hasTicket {
                    ticketView(movie: movie!, selectedDate: selectedDate!, selectedTime: selectedTime!, selectedSeats: selectedSeats!, gradient: [Color.blue, Color.purple])
                        .tag(Tab.ticket)
                } else {
                    Text("No ticket, please purchase a ticket first.")
                        .tag(Tab.ticket)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(currentTab: $currentTab)
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            if movies.isEmpty {
                apiService.fetchMovies { fetchedMovies in
                    movies = fetchedMovies
                }
            }
        }
    }
}



#Preview {
    MovieListView()
}


#Preview {
    MovieListView()
}
