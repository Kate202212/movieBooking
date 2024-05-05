import Foundation

// Defines the structure for a movie, including details needed for the movie detail view.
struct Movie: Identifiable, Decodable {
    var id: Int
    var title: String
    var overview: String
    var releaseDate: String
    var genres: [Genre]?
    var posterPath: String
    var runtime: Int?
    var credits: Credits?

    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime
        case releaseDate = "release_date"
        case genres
        case posterPath = "poster_path"
        case credits
    }
}

// Genre information for a movie.
struct Genre: Identifiable, Decodable {
    var id: Int
    var name: String
}

// Credits containing cast and crew.
struct Credits: Decodable {
    var cast: [CastMember]
    var crew: [CrewMember]
}

// Cast member details.
struct CastMember: Identifiable, Decodable {
    var id: Int
    var name: String
    var character: String
}

// Crew member details, identifying if someone is a director, etc.
struct CrewMember: Identifiable, Decodable {
    var id: Int
    var name: String
    var job: String
}
