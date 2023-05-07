//
//  Extra.swift
//  AudioBooks
//
//  Created by Saham Ghazavi on 2023-05-07.
//

import Foundation
import PodcastAPI
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

class  APICaller {
    func fetchData(completion: @escaping(Result<listing, Error>) -> Void) {
        var JSONResult = [result]()
        var JSONListings = listing()
        let apiKey = ProcessInfo.processInfo.environment["LISTEN_API_KEY", default: ""]
        let client = PodcastAPI.Client(apiKey: apiKey, synchronousRequest: true)
        var parameters: [String: String] = [:]
        parameters["q"] = "startup"
        parameters["sort_by_date"] = "1"
        
        client.search(parameters: parameters) { response in
            if let error = response.error {
                switch (error) {
                case PodcastApiError.apiConnectionError:
                    print("Can't connect to Listen API server")
                case PodcastApiError.authenticationError:
                    print("wrong api key")
                default:
                    print("unknown error")
                }
            } else {
                if let json = response.toJson() {
                    JSONResult = self.JsonToListing(from: json)
                    JSONListings.results = JSONResult
                    completion(.success(JSONListings))
                }
            }
        }
    }
    func JsonToListing(from json: JSON)-> [result]{
        var returnValue = [result]()
        let results  = json[stringConstant.jsonKeys.results.rawValue].arrayValue
        for res in results {
            let title_original = res[stringConstant.jsonKeys.titleOriginal.rawValue].string
            let thumbnail = res[stringConstant.jsonKeys.thumbnail.rawValue].string
            let description_highlighted = res[stringConstant.jsonKeys.descriptionHighlighted.rawValue].string
            let id = res[stringConstant.jsonKeys.id.rawValue].string
            let podcast = res[stringConstant.jsonKeys.podcast.rawValue].object as? [String:Any]
            let publisher = podcast?[stringConstant.jsonKeys.publisher.rawValue] as? String
            let res = result(title_original: title_original, thumbnail: thumbnail, publisher: publisher, description_highlighted: description_highlighted, id: id)
            returnValue.append(res)
            
        }
        return returnValue
        
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
