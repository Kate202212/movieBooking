//
//  CinemaDateModel.swift
//  MovieBookingApp
//
//  Created by Prakai Prajit on 4/5/2024.
//

import Foundation

struct CinemaSession: Identifiable {
    let id = UUID()
    let times: [String]
    let date: Date
}

class CinemaDateModel: ObservableObject {
    @Published var sessions: [CinemaSession] = []
    
    init() {
        // Set up for two weeks of movie sessions
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        for day in 0..<14 {
            let date = Calendar.current.date(byAdding: .day, value: day, to: Date())!
            let times = ["9:10", "14:20", "16:40", "18:10", "20:30"]
            sessions.append(CinemaSession(times: times, date: date))
        }
    }
}

