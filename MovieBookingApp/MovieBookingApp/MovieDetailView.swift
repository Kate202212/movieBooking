import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    var apiService = APIService()
    
    @State var gradient = [Color("Colordark").opacity(0), Color("Colordark"), Color("Colordark"), Color("Colordark")]
    @State private var fullMovieDetails: Movie?
    @State private var selectedDate: Date?
    @State private var selectedTime: String?
    @StateObject private var cinemaModel = CinemaDateModel()  // Model holding dates and times
    
    var body: some View {
        // Removed the outer NavigationView that was causing nesting issues
        ZStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")!) { phase in
                if case .success(let image) = phase {
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .ignoresSafeArea()
                } else {
                    Color.black.opacity(20)
                }
            }
            
            VStack {
                LinearGradient(colors: gradient, startPoint: .top, endPoint: .bottom)
                    .frame(height: 400)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
            VStack {
                Spacer()
                Text(fullMovieDetails?.title ?? "Loading...")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(.top, 50)
                
                
                Text("Select date")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.bottom, 15)
                
                selectionScrollView()
                
                
                if let date = selectedDate {
                    timeSelectionView(for: date)
                }
                
                // Correct placement of NavigationLink to prevent multiple navigation bars
                NavigationLink(destination: SeatSelectionView(movie: movie, selectedDate: selectedDate, selectedTime: selectedTime)) {
                    Text("Select Seats")
                }
                .padding()
                .background(selectedDate == nil || selectedTime == nil ? Color.gray : Color.orange) // Conditional color change
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(selectedDate == nil || selectedTime == nil)
            }
        }
        .onAppear {
            apiService.fetchMovieDetails(movieId: movie.id) { fetchedDetails in
                fullMovieDetails = fetchedDetails
            }
        }
    }

    @ViewBuilder
    private func selectionScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(cinemaModel.sessions, id: \.id) { session in
                    Button(action: {
                        self.selectedDate = session.date
                    }) {
                        Text("\(session.date, formatter: DateFormatter.movieDateFormatter)")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(selectedDate == session.date ? Color.blue : Color.gray.opacity(0.7))
                            .cornerRadius(8)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }

    @ViewBuilder
    private func timeSelectionView(for date: Date) -> some View {
        Text("Select Time")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.top, 10)

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                if let times = cinemaModel.sessions.first(where: { $0.date == date })?.times {
                    ForEach(times, id: \.self) { time in
                        Button(action: {
                            self.selectedTime = time
                        }) {
                            Text(time)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(selectedTime == time ? Color.blue : Color.gray.opacity(0.7))
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

extension DateFormatter {
    static let movieDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"
        return formatter
    }()
}
