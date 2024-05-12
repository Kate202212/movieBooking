
import SwiftUI


class Seat: Identifiable, ObservableObject, Hashable {
    let id: UUID
    @Published var status: SeatStatus
    let row: Int
    let number: Int
    @Published var reserved: Bool
    var reservations: [(date: String, time: String)] = []

    init(id: UUID = UUID(), row: Int, number: Int, status: SeatStatus, reserved: Bool = false) {
        self.id = id
        self.row = row
        self.number = number
        self.status = status
        self.reserved = reserved
    }

    static func == (lhs: Seat, rhs: Seat) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}



enum SeatStatus: String {
    case available = "availableSeat"
    case selecting = "selectSeat"
    case sold = "soldSeat"
}

class SeatSelectionViewModel: ObservableObject {
    @Published var seats: [[Seat]] = []

    init() {
        generateSeats()
    }

    private func generateSeats() {
        let rows = [5, 6, 8, 10, 9, 10, 9, 10]  // Seat distribution per row
        for (index, seatsInRow) in rows.enumerated() {
            var row: [Seat] = []
            for seatNumber in 1...seatsInRow {
                row.append(Seat(row: index + 1, number: seatNumber, status: .available))
            }
            seats.append(row)
        }
    }
}

struct SeatLegendView: View {
    var image: String
    var text: String

    var body: some View {
        VStack {
            Image(image)  // Name of seats to show availabibity
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20) // You can adjust the size as needed
            Text(text)
                .foregroundColor(.black)
                .font(.caption)
        }
    }
}
extension SeatSelectionViewModel {

    func updateReservedSeats(for movie: Movie, date: Date, time: String) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"  // The date format should match the format used when comparing dates.
            let dateStr = dateFormatter.string(from: date)

            // Filter tickets by converting Ticket.date to String for comparison
            let relevantTickets = TicketService.shared.tickets.filter {
                $0.movie.id == movie.id && dateFormatter.string(from: $0.date) == dateStr && $0.time == time
            }

            for ticket in relevantTickets {
                let bookedSeats = ticket.seats.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
                for bookedSeat in bookedSeats {
                    if let rowLetter = bookedSeat.first, let seatNumber = Int(bookedSeat.dropFirst()) {
                        let rowNumber = Int(rowLetter.asciiValue! - Character("A").asciiValue! + 1)
                        let rowIndex = rowNumber - 1
                        if rowIndex < seats.count {
                            if let seatIndex = seats[rowIndex].firstIndex(where: { $0.number == seatNumber }) {
                                seats[rowIndex][seatIndex].reservations.append((date: dateStr, time: time))
                                seats[rowIndex][seatIndex].reserved = true
                                seats[rowIndex][seatIndex].status = .sold
                            }
                        }
                    }
                }
            }

            // Use DispatchQueue to update the UI thread
            DispatchQueue.main.async { [weak self] in
                self?.seats = self?.seats ?? []  // Ensures the UI updates with the new state
            }
        }

}

