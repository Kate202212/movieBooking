import SwiftUI

struct MovieListView: View {
    @State private var movies: [Movie] = []
    @State private var showTicket: Bool = false // New state to control ticket visibility
    var apiService = APIService()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(movies, id: \.id) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            VStack {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")!) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 150, height: 225)
                                .cornerRadius(8)
                                
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .font(.headline)
                                    .foregroundColor(.black)

                                Text(movie.releaseDate)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color("Colorpnk"), Color("lightBlue"), Color("Colorpurp")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .cornerRadius(8)
                    }
                }
            }
        }
        .navigationTitle("Movies")
        .background(LinearGradient(gradient: Gradient(colors: [Color("Colorpurp"), Color("lightBlue"), Color("Colorpnk")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            if movies.isEmpty {
                apiService.fetchMovies { fetchedMovies in
                    movies = fetchedMovies
                }
            }
        }
        .overlay(
            VStack {
                Spacer()
                Button(action: {
                    // Toggle the ticket visibility
                    showTicket.toggle()
                }) {
                    Image(systemName: "ticket")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(.pink)
                        .clipShape(Circle())
                }
            }
        )
    }
    .sheet(isPresented: $showTicket) {
        // Present the ticket view here
        MyTicketView()
        }
    }
}

struct MyTicketView: View {
    @ObservedObject var ticketService = TicketService.shared
    @State private var showingAlert = false
    @State private var ticketToCancel: UUID?

    var body: some View {
        NavigationView {
            List(ticketService.tickets) { ticket in
                HStack(alignment: .top, spacing: 16) {
                    // Load the movie poster image
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(ticket.movie.posterPath)")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 120)  // Adjust dimensions as required
                            .cornerRadius(8)
                    } placeholder: {
                        Color.gray
                            .frame(width: 80, height: 120)  // Placeholder size matching the image
                            .cornerRadius(8)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(ticket.movie.title)
                            .font(.headline)

                        Text("Date: \(ticket.date, formatter: DateFormatter.ticketDateFormatter)")
                        Text("Time: \(ticket.time)")
                        Text("Seats: \(ticket.seats)")
                    }

                    Spacer()

                    // Cancel Booking Button, with alert confirmation
                    Button(action: {
                        self.ticketToCancel = ticket.id
                        self.showingAlert = true
                    }) {
                        Image(systemName: "trash")
                            .font(.system(size: 24))
                            .foregroundColor(.red)
                            .padding(8)
                    }
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("My Tickets")
        }
        .alert("Confirm Cancellation", isPresented: $showingAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Confirm", role: .destructive) {
                if let ticketID = ticketToCancel {
                    ticketService.cancelTicket(ticketID: ticketID)
                }
            }
        } message: {
            Text("Are you sure you want to cancel this ticket?")
        }
    }
}
struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
