import SwiftMatrixSDK
import Foundation

class MatrixHandler {

    static func getHomeserverURL(from username: String, completion: @escaping (String?) -> ()) {
        var token = username.components(separatedBy: ":")
        if token.count > 1 {
            NSLog("token: " + token[1])
        } else {
            NSLog("couldn't split username into parts")
        }

        let url = URL(string: "https://matrix.org/.well-known/matrix/client")!

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
