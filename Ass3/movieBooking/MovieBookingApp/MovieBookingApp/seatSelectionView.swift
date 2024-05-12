import SwiftUI

struct SeatSelectionView: View {
    @ObservedObject var viewModel = SeatSelectionViewModel()
    @State private var selectedSeats: Set<UUID> = []
    @State private var totalPrice: Double = 0.0
    @State private var navigateToTicketView = false
    @State private var selectedSeatsDescriptions: String = ""  // Formatted seat descriptions

    var movie: Movie
    var selectedDate: Date?
    var selectedTime: String?

    var body: some View {
        VStack {
            Image("screen")
                .resizable()
                .scaledToFit()
                .padding(.horizontal)
            
            Spacer(minLength: 20)
            
            ForEach(Array(viewModel.seats.enumerated()), id: \.offset) { index, row in
                HStack {
                    Text(String(Character(UnicodeScalar("A".unicodeScalars.first!.value + UInt32(index))!)))
                        .font(.subheadline)
                        .frame(width: 20, alignment: .leading)
                        .bold()
                    
                    ForEach(row) { seat in
                        Image(seat.status.rawValue)
                            .resizable()
                            .frame(width: 20, height: 15)
                            .onTapGesture {
                                toggleSeat(seat: seat)
                            }
                    }
                }
            }
            Spacer(minLength: 50)
            
            HStack {
                Spacer()
                SeatLegendView(image: "selectSeat", text: "Selected")
                Spacer()
                SeatLegendView(image: "soldSeat", text: "Reserved")
                Spacer()
                SeatLegendView(image: "availableSeat", text: "Available")
                Spacer()
            }
            .padding(.bottom)
            
            Spacer()
            
            SummaryBoxView(movie: movie, selectedDate: selectedDate, selectedTime: selectedTime, selectedSeats: selectedSeats, seats: viewModel.seats)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Price: $\(totalPrice, specifier: "%.2f")")
                        .bold()
                        .foregroundColor(.pink)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button("Pay & Get Ticket!") {
                    if let date = selectedDate, let time = selectedTime {
                        selectedSeatsDescriptions = generateSeatDescriptions()
                        markSeatsAsReserved()
                        TicketService.shared.bookTicket(for: movie, date: date, time: time, seats: selectedSeatsDescriptions)
                        navigateToTicketView = true
                    }
                }
                .padding()
                .background(Color.pink)
                .foregroundColor(.white)
                .cornerRadius(10)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            
            NavigationLink(
                destination: ticketView(
                    movie: movie,
                    selectedDate: selectedDate ?? Date(),
                    selectedTime: selectedTime ?? "Time Not Set",
                    selectedSeats: selectedSeatsDescriptions,
                    gradient: [Color.red, Color.blue]
                ),
                isActive: $navigateToTicketView
            ) {
                EmptyView()
            }
            .hidden()
            .onAppear {
                if let date = selectedDate, let time = selectedTime {
                                viewModel.updateReservedSeats(for: movie, date: date, time: time)
                            }
                    }
        }
    }

    private func toggleSeat(seat: Seat) {
        guard seat.status != .sold else { return }
        if seat.status == .selecting {
            seat.status = .available
            selectedSeats.remove(seat.id)
            totalPrice -= 10
        } else {
            seat.status = .selecting
            selectedSeats.insert(seat.id)
            totalPrice += 10
        }
    }

    private func markSeatsAsReserved() {
        viewModel.seats.flatMap { $0 }.forEach { seat in
            if selectedSeats.contains(seat.id) {
                seat.status = .sold
                seat.reserved = true
            }
        }
    }

    private func generateSeatDescriptions() -> String {
        return selectedSeats.compactMap { seatID -> String? in
            guard let seat = viewModel.seats.flatMap({ $0 }).first(where: { $0.id == seatID }) else { return nil }
            let rowLetter = String(Character(UnicodeScalar("A".unicodeScalars.first!.value + UInt32(seat.row - 1))!))
            return "\(rowLetter)\(seat.number)"
        }
        .sorted()
        .joined(separator: ", ")
    }
}
