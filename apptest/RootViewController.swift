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
        let homeServerUrl = URL(string: "https://mikenew.io/matrix")!
        let mxRestClient = MXRestClient(homeServer: homeServerUrl, unrecognizedCertificateHandler: nil)
        mxRestClient.publicRooms(onServer:homeServerUrl.absoluteString, limit: 100, completion: { response in
            switch response {
            case .success(let rooms):
        
                // rooms is an array of MXPublicRoom objects containing information like room id
                print("The public rooms are: \(rooms)")
        
            case .failure: break
            }
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        objects.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
