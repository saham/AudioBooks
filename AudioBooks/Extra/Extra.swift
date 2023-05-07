import Foundation
import UIKit
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}




struct stringConstant {
    enum jsonKeys: String {
        case results
        case titleOriginal = "title_original"
        case descriptionHighlighted = "description_highlighted"
        case thumbnail
        case id
        case podcast
        case publisher = "publisher_original"
        case LISTEN_API_KEY
        case startup
        case sort_by_date
    }
    enum word: String {
        case Favourited
        case Favourite
    }
}
func imageDownload(from urlString: String?,completion:  @escaping (UIImage?)->Void) {
    if let imageUrlString = urlString,
       let imageURL = URL(string: imageUrlString){
        URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard let imageData = data else { return }
            guard error == nil else {return}
            completion(UIImage(data: imageData))
        }.resume()
    }
    
}
