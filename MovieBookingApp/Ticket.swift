import Foundation

struct Ticket: Identifiable {
    let id = UUID()
    let movie: Movie
    let date: Date
    let time: String
    let seats: String
}

class TicketService: ObservableObject {
    static let shared = TicketService()
    @Published private(set) var tickets: [Ticket] = []

    private init() {}

    func bookTicket(for movie: Movie, date: Date, time: String, seats: String) {
        let newTicket = Ticket(movie: movie, date: date, time: time, seats: seats)
        tickets.append(newTicket)
    }

    func cancelTicket(ticketID: UUID) {
        tickets.removeAll { $0.id == ticketID }
    }
}
