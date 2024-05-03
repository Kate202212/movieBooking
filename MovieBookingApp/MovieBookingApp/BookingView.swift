import SwiftUI

// View for handling ticket bookings for a movie.
struct BookingView: View {
    var movie: Movie

    var body: some View {
        VStack {
            Text("Prepare to book tickets for \(movie.title)")
                .font(.title)
                .padding()

            Spacer()
        }
        .navigationTitle("Booking Tickets")
        .navigationBarTitleDisplayMode(.inline)
    }
}
