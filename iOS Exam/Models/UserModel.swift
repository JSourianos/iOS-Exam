//This is the User Struct which we will use to model the JSON data.
//We should move the structs expect for Result into a seperate file called UserProperties
struct UserModel: Codable {
    var results: [Result]
    var info: Info?
}

struct Result: Codable {
    var gender: String
    var name: Name
    var location: Location
    var email: String
    var login: Login
    var dob: Dob
    var registered: Registered
    var phone: String
    var cell: String
    var id: Id?
    var picture: Picture
    var nat: String
    
    enum Keys: String, CodingKey {
        case gender
        case name
        case location
        case email
        case login
        case dob
        case registered
        case phone
        case cell
        case id
        case picture
        case nat
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.name = try container.decode(Name.self, forKey: .name)
        self.location = try container.decode(Location.self, forKey: .location)
        self.email = try container.decode(String.self, forKey: .email)
        self.login = try container.decode(Login.self, forKey: .login)
        self.dob = try container.decode(Dob.self, forKey: .dob)
        self.registered = try container.decode(Registered.self, forKey: .registered)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.cell = try container.decode(String.self, forKey: .cell)
        self.id = try container.decode(Id.self, forKey: .id)
        self.picture = try container.decode(Picture.self, forKey: .picture)
        self.nat = try container.decode(String.self, forKey: .nat)
    }
}

/* MOVE THESE TO A SEPARATE FILE! */
//This represents the name structure in the JSON file.
public class Name: Codable {
    var title: String
    var first: String
    var last: String
}

//This represents the location structure in the JSON file.
struct Location: Codable {
    var street: Street
    var city: String
    var state: String
    var coordinates: Coordinates
    var timezone: Timezone
}

struct Street: Codable {
    var number: Int
    var name: String
}

//This represents the coordinates inside the Location struct.
struct Coordinates: Codable {
    var latitude: String
    var longitude: String
}

struct Timezone: Codable {
    var offset: String
    var description: String
}

struct Login: Codable {
    var uuid: String
    var username: String
    var password: String
    var salt: String
    var md5: String
    var sha1: String
    var sha256: String
}

struct Dob: Codable {
    var date: String
    var age: Int
}

struct Registered: Codable {
    var date: String
    var age: Int
}

struct Id: Codable {
    var name: String
    var value: String?
}

struct Picture: Codable {
    var large: String
    var medium: String
    var thumbnail: String
}

struct Info: Codable{
    var seed: String
    var results: Int
    var page: Int
    var version: String
}
