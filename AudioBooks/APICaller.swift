import Foundation
import PodcastAPI
class  APICaller {
    var isPaging:Bool = false
    func fetchData(paginating:Bool,completion: @escaping(Result<listing, Error>) -> Void) {
        if paginating {
            isPaging = true
        }
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
                    if paginating {
                        self.isPaging = false
                    }
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
