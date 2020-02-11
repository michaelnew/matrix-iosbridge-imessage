import SwiftMatrixSDK
import Foundation

class MatrixHandler {

    static func getHomeserverURL(from username: String, completion: @escaping (String?) -> ()) {

        // Split the username apart and grab the domain
        var domain: String?
        var parts = username.components(separatedBy: ":")
        if parts.count > 1 {
            domain = parts[1]
        } else {
            log("couldn't get a URL from username")
        }

        // See if the server will give us it's client URL:
        // https://matrix.org/docs/spec/client_server/r0.6.0#server-discovery
        if let domain = domain {
            let url = URL(string: "https://" + domain + "/.well-known/matrix/client")!
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { 
                    completion(nil)
                    return 
                }
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let serverURL = json?["m.homeserver"] as? [String: Any] {
                        if let b = serverURL["base_url"] as? String {
                            completion(b)
                            return
                        }
                    }
                }
                completion(nil)
                return
            }
            task.resume()
        }
    }
}
