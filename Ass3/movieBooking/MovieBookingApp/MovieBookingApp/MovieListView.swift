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
    @State private var ticketToDelete: Ticket?
    @State private var selectedTicket: Ticket? // To store the selected ticket

    var body: some View {
        NavigationView {
            List(ticketService.tickets) { ticket in
                TicketRow(ticket: ticket)
                    .onTapGesture {
                        selectedTicket = ticket // Set the selected ticket when tapped
                    }
            }
            .navigationTitle("My Tickets")
            .sheet(item: $selectedTicket) { ticket in
                ticketView(movie: ticket.movie, selectedDate: ticket.date, selectedTime: ticket.time, selectedSeats: ticket.seats, gradient: [Color.blue, Color.purple]) // Show the TicketDetailView when a ticket is selected
            }
        }
    }

    @ViewBuilder
    func TicketRow(ticket: Ticket) -> some View {
        HStack(alignment: .top, spacing: 16) {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(ticket.movie.posterPath)")) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 120)
                    .cornerRadius(8)
            } placeholder: {
                Color.gray
                    .frame(width: 80, height: 120)
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

            Button(action: {
                // Toggle the showingAlert flag to display the alert
                showingAlert.toggle()
                ticketToDelete = ticket // Set the ticket to delete when the button is tapped
            }) {
                Image(systemName: "trash")
                    .font(.system(size: 24))
                    .foregroundColor(.red)
                    .padding(8)
            }
            .buttonStyle(PlainButtonStyle()) // Ensure the button is clickable
        }
        .padding(.vertical, 8)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Confirm Cancellation"), message: Text("Are you sure you want to cancel this ticket?"), primaryButton: .default(Text("Cancel")), secondaryButton: .destructive(Text("Confirm"), action: {
                // Perform cancellation action here
                if let ticket = ticketToDelete {
                    ticketService.cancelTicket(ticketID: ticket.id)
                    ticketToDelete = nil // Reset ticketToDelete after cancellation
                }
            }))
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
