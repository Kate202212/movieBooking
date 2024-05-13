import SwiftUI

struct ticketView: View {
    var movie: Movie
    var selectedDate: Date
    var selectedTime: String
    var selectedSeats: String
    var gradient: [Color]

    @State private var isShowingMovieList = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Top part with movie image
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 300, height: 400)
            .cornerRadius(15, corners: [.topLeft, .topRight])
            
            // Bottom part with ticket details
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    HStack {
                    Image("calendar") // Icon for the date
                        .resizable()
                        .frame(width: 50, height: 30)
                    Text("\(selectedDate, formatter: DateFormatter.ticketDateFormatter)")
                }
                .font(.headline)
                
                HStack {
                    Image("clock") // Icon for the time
                        .resizable()
                        .frame(width: 50, height: 30)
                    Text(selectedTime)
                }
                .font(.headline)
            }
                .padding(.bottom, 20)
            
                HStack {
                    Image("soldSeat") // Icon for the seats
                        .resizable()
                        .frame(width: 50, height: 30)
                    Text(selectedSeats)
                }
                .font(.headline);
                
                Image("barcode") // Icon for the barcode
                    .resizable()
                    .scaledToFill()
                    .padding(.horizontal)
            }
            .padding()
            .frame(maxWidth: 300)
            .background(LinearGradient(gradient: Gradient(colors: gradient), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
            
            VStack {
                Spacer()
                Button(action: {
                    isShowingMovieList = true
                }) {
                    Image(systemName: "house.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(.pink)
                        .clipShape(Circle())
                }
                .fullScreenCover(isPresented: $isShowingMovieList) {
                    MovieListView()
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline) 
        .navigationBarHidden(true)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension DateFormatter {
    static let ticketDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, "
        return formatter
    }()
}

// Preview
struct ticketView_Previews: PreviewProvider {
    static var previews: some View {
        ticketView(
            movie: Movie(id: 1, title: "Example Movie", overview: "An exciting plot", releaseDate: "2024-01-01", posterPath: "/path.jpg", runtime: 120, credits: nil),
            selectedDate: Date(),
            selectedTime: "19:00",
            selectedSeats: "A3, B8, G1",
            gradient: [Color.blue, Color.purple]
        )
    }
}
