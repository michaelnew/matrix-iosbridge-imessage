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
            self.objects.insert(message, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        }

        self.testMatrix()
    }

    func testMatrix() {
        // Load settings from user defaults
        guard let token = UserDefaults.standard.string(forKey: "matrixAccessToken") else { return }
        guard let userId = UserDefaults.standard.string(forKey: "matrixBotUserId") else { return }
        guard let homeServerUrl = UserDefaults.standard.string(forKey: "matrixHomeServerUrl") else { return }

        let credentials = MXCredentials(homeServer: homeServerUrl,
                                userId: userId,
                                accessToken:token )

        let mxRestClient = MXRestClient(credentials: credentials, unrecognizedCertificateHandler: nil)

        guard let mxSession = MXSession(matrixRestClient: mxRestClient) else {
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        objects.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
