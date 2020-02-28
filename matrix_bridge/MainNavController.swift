import UIKit

class MainNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(true, animated: false)

        let goToStatusPage: () -> Void = { [weak self] in
            self?.setViewControllers([StatusPage()], animated: true)
        }

        let goToUserSignIn: () -> Void = { [weak self] in
            let userSignIn = UserSignIn()
            userSignIn.continueAction = { [weak self] in
                goToStatusPage()
            }
            self?.setViewControllers([userSignIn], animated: true)
        }

        if self.hasBotCredentials() && self.hasUserCredentials() {
            goToStatusPage()
        } else if self.hasBotCredentials() {
            goToUserSignIn()
        } else {
            let botSignIn = BotSignIn()
            botSignIn.continueAction = goToUserSignIn
            self.setViewControllers([botSignIn], animated: false)
        }
    }

    func hasBotCredentials() -> Bool {
        return
            (UserDefaults.standard.string(forKey: Helpers.matrixBotAccessToken) ?? "").count > 0 &&
            (UserDefaults.standard.string(forKey: Helpers.matrixBotUserId) ?? "").count > 0 &&
            (UserDefaults.standard.string(forKey: Helpers.matrixBotServerUrl) ?? "").count > 0
    }

    func hasUserCredentials() -> Bool {
        return (UserDefaults.standard.string(forKey: Helpers.matrixUserId) ?? "").count > 0
    }
}
