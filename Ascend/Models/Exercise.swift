import Foundation;

struct Exercise: Identifiable {
    let id = UUID();
    let name: String;
    let sets: Int;
    let repRange: String;
}
