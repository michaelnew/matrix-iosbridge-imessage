import SwiftMatrixSDK
import Foundation

class MatrixHandler {

    static func getHomeserverURL(from username: String, completion: @escaping (String?) -> ()) {


        // use this maybe?
        //- (MXHTTPOperation*)wellKnow:(void (^)(MXWellKnown *wellKnown))success
        //             failure:(void (^)(NSError *error))failure;


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

    // TODO: move all of this into the MatrixHandler class and clean it up
    private var matrixClient: MXRestClient?

    func checkMatrixIdIsInUse(userId: String) {
    //- (MXHTTPOperation*)isUserNameInUse:(NSString*)username
    //                           callback:(void (^)(BOOL isUserNameInUse))callback NS_REFINED_FOR_SWIFT;
    }

    func getToken(userId: String, password: String, homeServerUrl: String){
        let url = URL(string: homeServerUrl)!
        self.matrixClient = MXRestClient(homeServer: url, unrecognizedCertificateHandler: nil)
        self.matrixClient!.login(username: userId, password: password, completion: { (response) in
            switch response {
            case .success(let credentials):
                log("token:  " + (credentials.accessToken ?? ""))
                break
            case .failure(let error):
                // Handle the error in some way
                log("error logging in: " + error.localizedDescription)
                break
            }
        })
    }

    func loginToMatrix(userId: String, token: String, homeServerUrl: String) {
        let credentials = MXCredentials(homeServer: homeServerUrl,
                                userId: userId,
                                accessToken:token)

        // start client earlier
        self.matrixClient = MXRestClient(credentials: credentials, unrecognizedCertificateHandler: nil)

        guard let mxSession = MXSession(matrixRestClient: self.matrixClient) else {
            log("couldn't create matrix session")
            return
        }

        mxSession.start { response in
            guard response.isSuccess else { return }

            // mxSession is ready to be used
            // now wer can get all rooms with:
            log("\(mxSession.rooms)")
        }
    }

    func send(message: String) {
        if let m = self.matrixClient {
            m.sendTextMessage(toRoom: "!lzoKElzYKTdgaONpcI:mikenew.io", text: message, completion: { (response) in
                log("sent message to matrix")
            })
        } else {
            log("No active matrix client. Can't send message")
        }
    }
}
