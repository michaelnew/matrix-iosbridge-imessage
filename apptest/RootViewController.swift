import UIKit
import Foundation
import SwiftMatrixSDK

class RootViewController: UITableViewController {

    var objects: [String] = []

    override func loadView() {
        super.loadView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        title = "Messages"

        NSLog("msghk: Connecting to notification center")
        let center = NSDistributedNotificationCenter.default!
        let mainQueue = OperationQueue.main
        center.addObserver(forName: NSNotification.Name("messagehook"), object: nil, queue: mainQueue) { (note) in
            NSLog("msghk: got notification")
            let message = note.userInfo?["message"] as? String ?? "no message"
            let guid = note.userInfo?["guid"] as? String ?? "guid not found"
            let name = note.userInfo?["recipientName"] as? String ?? "recipient unkown"
            self.objects.insert(message, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.send(message: "\(name): " + message + " (guid: \(guid))")
        }

        self.testMatrix()
    }

    var matrixClient: MXRestClient?

    func testMatrix() {
        // Load settings from user defaults
        guard let token = UserDefaults.standard.string(forKey: "matrixAccessToken") else { return }
        guard let userId = UserDefaults.standard.string(forKey: "matrixBotUserId") else { return }
        guard let homeServerUrl = UserDefaults.standard.string(forKey: "matrixHomeServerUrl") else { return }

        let credentials = MXCredentials(homeServer: homeServerUrl,
                                userId: userId,
                                accessToken:token )

        self.matrixClient = MXRestClient(credentials: credentials, unrecognizedCertificateHandler: nil)

        guard let mxSession = MXSession(matrixRestClient: self.matrixClient) else {
            NSLog("couldn't create matrix session")
            return
        }

        mxSession.start { response in
            guard response.isSuccess else { return }

            // mxSession is ready to be used
            // now wer can get all rooms with:
            NSLog("\(mxSession.rooms)")
        }
    }

    func send(message: String) {
        self.matrixClient?.sendTextMessage(toRoom: "!lzoKElzYKTdgaONpcI:mikenew.io", text: message, completion: { (response) in
            NSLog("sent message hopefully")
        })
    }

    // MARK: - Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel!.text = objects[indexPath.row]
        return cell
    }
}
