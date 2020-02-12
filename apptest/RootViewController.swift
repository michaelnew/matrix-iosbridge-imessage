import UIKit
import Foundation
import SwiftMatrixSDK

class RootViewController: UITableViewController {

    var objects: [String] = []
    var matrixHandler = MatrixHandler()

    override func loadView() {
        super.loadView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        self.title = "Messages"

        let center = NSDistributedNotificationCenter.default!
        let mainQueue = OperationQueue.main
        center.addObserver(forName: NSNotification.Name("messagehook"), object: nil, queue: mainQueue) { (note) in
            log("got notification")
            let message = note.userInfo?["message"] as? String ?? "no message"
            let guid = note.userInfo?["guid"] as? String ?? "guid not found"
            let name = note.userInfo?["recipientName"] as? String ?? "recipient unkown"
            self.objects.insert(message + " (" + name + ")", at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            self.matrixHandler.send(message: "\(name): " + message + " (guid: \(guid))")
        }

        // Does this need to be static?
        _ = MatrixHandler.getHomeserverURL(from: "@mike_new:mikenew.io", completion: { url in
            if let url = url {
                log("url: " + url)
            } else {
                log("could't get matrix server client URL")
            }
        })

        self.attemptMatrixLoginWithStoredCredentials()
    }

    func attemptMatrixLoginWithStoredCredentials() {
        guard let token = UserDefaults.standard.string(forKey: "matrixAccessToken") else { return }
        guard let userId = UserDefaults.standard.string(forKey: "matrixBotUserId") else { return }
        guard let homeServerUrl = UserDefaults.standard.string(forKey: "matrixHomeServerUrl") else { return }

        // probably shouldn't store the password. Just store the token after login.
        // Could also maybe store the token in keychain rather than in user defaults
        //guard let password = UserDefaults.standard.string(forKey: "matrixBotPassword") else { return }

        self.matrixHandler.loginToMatrix(userId: userId, token: token, homeServerUrl: homeServerUrl)
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
