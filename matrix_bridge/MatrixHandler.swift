import SwiftMatrixSDK
import Foundation

class MatrixHandler {

    private var matrixClient: MXRestClient?
    private var session: MXSession?

    /*
    init(_ serverURL: String) {
        let url = URL(string: serverURL)!
        self.matrixClient = MXRestClient(homeServer: url, unrecognizedCertificateHandler: nil)
    }
    */

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
        return (userId.first == "@") && userId.contains(":")
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

    func getToken(userId: String, password: String, serverUrl: String, completion: @escaping (Bool, String?) -> ()) {
        if let url = URL(string: serverUrl) {
            self.matrixClient = MXRestClient(homeServer: url, unrecognizedCertificateHandler: nil)
            self.matrixClient?.login(username: userId, password: password, completion: { (response) in
                switch response {
                case .success(let credentials):
                    if let t = credentials.accessToken {
                        completion(true, t)
                    } else {
                        completion(false, nil)
                    }
                    break
                case .failure(let error):
                    log("error logging in: " + error.localizedDescription)
                    completion(false, nil)
                    break
                }
            })
        } else {
            log("bad url")
        }
    }

    func loginToMatrix(userId: String, token: String, homeServerUrl: String, completion: @escaping (Bool) -> ()) {
        let credentials = MXCredentials(homeServer: homeServerUrl,
                                userId: userId,
                                accessToken:token)

        self.matrixClient = MXRestClient(credentials: credentials, unrecognizedCertificateHandler: nil)

        self.session = MXSession(matrixRestClient: self.matrixClient)
        if let s = self.session {
            s.start { response in
                completion(response.isSuccess)
            }
        } else {
            completion(false)
        }
    }

    func listRooms() {
        log("\(self.session?.rooms)")
    }

    func createStatusRoomIfNeeded() {
        let r = self.session?.room(withRoomId: "!test_room:mikenew.io")
        _ = r?.liveTimeline.listenToEvents { (event, direction, roomState) in
            switch direction {
            case .forwards:
                // Live/New events come here
                log("event happened in room!")
                break

            case .backwards:
                // Events that occurred in the past will come here when requesting pagination.
                // roomState contains the state of the room just before this event occurred.
                break
            }
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
