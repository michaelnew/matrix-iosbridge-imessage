import SwiftMatrixSDK
import Foundation

class MatrixHandler {

    private var matrixClient: MXRestClient?

    init(_ serverURL: String) {
        let url = URL(string: serverURL)!
        self.matrixClient = MXRestClient(homeServer: url, unrecognizedCertificateHandler: nil)
    }

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

    static func localpartFrom(_ userId: String) -> String? {
        // @localpart:domain
        var localpart: String?
        var parts = userId.components(separatedBy: ":")
        if parts.count > 1 {
            localpart = parts[0]
        } else {
            log("couldn't get localpart from username")
        }
        return localpart?.replacingOccurrences(of: "@", with: "", options: NSString.CompareOptions.literal, range:nil)
    }

    static func checkUserIdLooksValid(_ userId: String) -> Bool {
        // TODO: make this smarter
        return userId.contains("@") && userId.contains(":")
    }


    func isMatrixIdInUse(_ userId: String) {
        // this doesn't work if registration is off for the server the user ID is using,
        // which means it's fairly useless for our purposes: https://github.com/matrix-org/matrix-ios-sdk/issues/783

        let localpart = MatrixHandler.localpartFrom(userId)
        self.matrixClient?.testUserRegistration(localpart, callback: { (response) in 
            log("testRegistration: \(response.debugDescription)")
        })
        self.matrixClient?.isUserNameInUse(userId, completion: { (response) in
            log("isUserNameInUse: \(response)")
        })
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
