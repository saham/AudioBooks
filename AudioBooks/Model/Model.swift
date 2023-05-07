import Foundation
struct listing {
    var podcasts:[podcast]?
}
struct podcast {
    var title_original: String?
    var thumbnail: String?
    var publisher: String?
    var description_highlighted: String?
    var id: String? // Assumed it's unique per podcast
    var isFavorite: Bool {
        set {
            UserDefaults.standard.setValue(newValue, forKey: id ?? "default")
            UserDefaults.standard.synchronize()
        }
        get {
            let res = UserDefaults.standard.object(forKey: id ?? "default") as? Bool ?? false
            UserDefaults.standard.synchronize()
            return res
        }
    }
}
