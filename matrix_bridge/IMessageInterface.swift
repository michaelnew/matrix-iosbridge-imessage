import Foundation
import SwiftMatrixSDK

struct IMessage {
    let message: String
    let guid: String
    let recipientName: String
}

class IMessageInterface {

    var messageRecieved: ((IMessage) -> Void)?

    init() {
        let center = NSDistributedNotificationCenter.default!
        let mainQueue = OperationQueue.main
        center.addObserver(forName: NSNotification.Name("messagehook"), object: nil, queue: mainQueue) { (note) in
            log("got notification")
            let message = note.userInfo?["message"] as? String ?? "no message"
            let guid = note.userInfo?["guid"] as? String ?? "guid not found"
            let name = note.userInfo?["recipientName"] as? String ?? "recipient unkown"
            let i = IMessage(message: message, guid: guid, recipientName: name)
            self.messageRecieved?(i)
        }
    }
}
