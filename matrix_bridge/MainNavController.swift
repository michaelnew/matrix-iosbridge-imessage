import UIKit

class MainNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)

        let botSignIn = BotSignIn()
        botSignIn.continueAction = { [weak self] in
            let userSignIn = UserSignIn()
            self?.setViewControllers([userSignIn], animated: true)
        }

        self.setViewControllers([botSignIn], animated: false)
    }
}
