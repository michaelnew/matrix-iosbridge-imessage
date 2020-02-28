import UIKit

class MainNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)

        let botSignIn = BotSignIn()
        botSignIn.continueAction = { [weak self] in
            let userSignIn = UserSignIn()
            userSignIn.continueAction = { [weak self] in
                self?.setViewControllers([StatusPage()], animated: true)
            }
            self?.setViewControllers([userSignIn], animated: true)
        }

        self.setViewControllers([botSignIn], animated: false)
    }

    func hasBotCredentials() -> Bool {
        return
            (UserDefaults.standard.string(forKey: Helpers.matrixBotAccessToken) ?? "").count > 0 &&
            (UserDefaults.standard.string(forKey: Helpers.matrixBotUserId) ?? "").count > 0 &&
            (UserDefaults.standard.string(forKey: Helpers.matrixBotServerUrl) ?? "").count > 0
    }
}
