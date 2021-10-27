//This is the User Struct which we will use to model the JSON data.
//We should move the structs expect for Result into a seperate file called UserProperties
struct UserModel: Codable {
    var results: [Result]
    var info: Info?
}

struct Result: Codable {
    var gender: String?
    var name: Name?
    var location: Location?
    var email: String?
    var login: Login?
    var dob: Dob?
    var registered: Registered?
    var phone: String?
    var cell: String?
    var id: Id?
    var picture: Picture?
    var nat: String?
}

/* MOVE THESE TO A SEPARATE FILE! */
//This represents the name structure in the JSON file.
public class Name: Codable {
    var title: String?
    var first: String?
    var last: String?
}

//This represents the location structure in the JSON file.
struct Location: Codable {
    var street: Street?
    var city: String?
    var state: String?
    var postcode: AnyCodableValue?
    var coordinates: Coordinates?
    var timezone: Timezone?
}

struct Street: Codable {
    var number: Int?
    var name: String?
}

//This represents the coordinates inside the Location struct.
struct Coordinates: Codable {
    //These should be converted to doubles
    var latitude: String?
    var longitude: String?
}

struct Timezone: Codable {
    var offset: String?
    var description: String?
}

struct Login: Codable {
    var uuid: String?
    var username: String?
    var password: String?
    var salt: String?
    var md5: String?
    var sha1: String?
    var sha256: String?
}

//NOTE - REMEMBER TO FIX THIS
struct Dob: Codable {
    var date: String? //this is the date -> 1993-07-20T09:44:18.674Z
    var age: Int?
}

struct Registered: Codable {
    var date: String?
    var age: Int?
}

struct Id: Codable {
    var name: String?
    var value: String?
}

struct Picture: Codable {
    var large: String?
    var medium: String?
    var thumbnail: String? //this should really be an URL, but we can deal with this later
}

struct Info: Codable{
    var seed: String?
    var results: Int?
    var page: Int?
    var version: String?
}
