import Foundation
import PodcastAPI
class  APICaller {
   public var isPaging: Bool = false
    /**
     Fetches data from a public API. It returns data if succeed or error otherwise
     */
    func fetchData(completion: @escaping(Result<listing, Error>) -> Void) {
        isPaging = true
        var JSONResult = [result]()
        var JSONListings = listing()
        let apiKey = ProcessInfo.processInfo.environment[stringConstant.jsonKeys.LISTEN_API_KEY.rawValue, default: ""]
        let client = PodcastAPI.Client(apiKey: apiKey, synchronousRequest: true)
        var parameters: [String: String] = [:]
        parameters["q"] = stringConstant.jsonKeys.startup.rawValue
        parameters[stringConstant.jsonKeys.sort_by_date.rawValue] = "1"
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
                    self.isPaging = false
                }
            }
        }
    }
    /**
     This functions takes JSON and returns an array of `result`.
     */
    func JsonToListing(from json: JSON) -> [result] {
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
