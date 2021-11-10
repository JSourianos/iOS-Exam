//This is the User Struct which we will use to model the JSON data.
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
