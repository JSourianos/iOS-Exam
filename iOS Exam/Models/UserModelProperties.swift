import Foundation

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
