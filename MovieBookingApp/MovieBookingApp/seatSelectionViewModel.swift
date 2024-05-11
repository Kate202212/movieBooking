import SwiftUI

import SwiftUI

class Seat: Identifiable, ObservableObject, Hashable {
    let id: UUID
    @Published var status: SeatStatus
    let row: Int
    let number: Int
    @Published var reserved: Bool

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
    func updateReservedSeats() {
        let allTickets = TicketService.shared.tickets
        var updatedSeats = seats 

        for ticket in allTickets {
            let bookedSeats = ticket.seats.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            for bookedSeat in bookedSeats {
                if let rowLetter = bookedSeat.first, let seatNumber = Int(bookedSeat.dropFirst()) {
                    let rowNumber = Int(rowLetter.asciiValue! - Character("A").asciiValue! + 1)
                    let rowIndex = rowNumber - 1
                    if rowIndex >= 0 && rowIndex < seats.count {
                        if let seatIndex = seats[rowIndex].firstIndex(where: { $0.number == seatNumber }) {
                            updatedSeats[rowIndex][seatIndex].reserved = true
                            updatedSeats[rowIndex][seatIndex].status = .sold
                        }
                    }
                }
            }
        }

        DispatchQueue.main.async {
            self.seats = updatedSeats
        }
    }

}
