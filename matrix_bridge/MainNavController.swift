import UIKit

class MainNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)

        let controllers = [BotSignIn()]
        self.setViewControllers(controllers, animated: false)
    }
}
