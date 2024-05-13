import SwiftUI

struct SummaryBoxView: View {
    var movie: Movie
    var selectedDate: Date?
    var selectedTime: String?
    var selectedSeats: Set<UUID>
    var seats: [[Seat]]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("\(movie.title)")
                .fontWeight(.semibold)

            if let date = selectedDate, let time = selectedTime {
                Text("\(date, formatter: DateFormatter.movieDateFormatter) - \(time)")
            }

            HStack {
                    Image("selectSeat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    Text("\(seatDescriptions())")
                }
        }
        .padding()
        .background(Color.gray)
        .foregroundColor(.black)
        .cornerRadius(6)
        .shadow(radius: 5)
    }

    private func seatDescriptions() -> String {
        let selected = seats.flatMap { $0.filter { selectedSeats.contains($0.id) } }
        let descriptions = selected.map { seat -> String in
            let rowLetter = String(Character(UnicodeScalar("A".unicodeScalars.first!.value + UInt32(seat.row - 1))!))
            return "\(rowLetter)\(seat.number)"
        }
        return descriptions.joined(separator: ", ")
    }
}

struct SummaryBoxView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleMovie = Movie(id: 1, title: "Example Movie", overview: "An exciting plot", releaseDate: "2024-01-01", posterPath: "/path.jpg", runtime: 120, credits: nil)
        let exampleSeats = [
            [Seat(id: UUID(), row: 1, number: 1, status: .selecting), Seat(id: UUID(), row: 1, number: 2, status: .available)],
            [Seat(id: UUID(), row: 2, number: 1, status: .selecting)]
        ]
        let selectedSeats = Set(exampleSeats.flatMap { $0 }.filter { $0.status == .selecting }.map { $0.id })

        return SummaryBoxView(movie: exampleMovie, selectedDate: Date(), selectedTime: "19:00", selectedSeats: selectedSeats, seats: exampleSeats)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
