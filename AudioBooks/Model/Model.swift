import Foundation
struct listing {
    var results:[result]?
}
struct result {
    var title_original: String?
    var thumbnail: String?
    var publisher: String?
    var description_highlighted: String?
    var id: String?
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
