import UIKit
import Foundation

class BotSignIn: UIViewController, UITableViewDelegate, UITableViewDataSource {

    lazy var tableView = UITableView()
    lazy var logo = UILabel()
    lazy var subTitle = UILabel()
    lazy var subText = UILabel()
    lazy var button = UIButton()
    lazy var pageNumber = UILabel()
    var userIdCell: DynamicTextEntryCell?
    var passwordCell: DynamicTextEntryCell?
    var serverUrlCell: DynamicTextEntryCell?
    var statusCell: DescriptiveTextCell?
    var continueAction: (() -> Void)?
    var failedFindingServerUrl = false
    var discoveredServerUrl: String?
    let matrixHandler = MatrixHandler()

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = Helpers.background

        self.view.addSubview(self.logo)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.subTitle)
        self.view.addSubview(self.subText)
        self.view.addSubview(self.button)
        self.view.addSubview(self.pageNumber)

        self.logo.text = "[m]"
        self.logo.textColor = Helpers.green
        self.logo.textAlignment = .center
        self.logo.font = Helpers.mainFont(48)
        self.logo.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Helpers.padding)
            make.left.right.equalToSuperview()
        }

        self.subTitle.text = "sign in to Matrix"
        self.subTitle.textColor = .white
        self.subTitle.textAlignment = .center
        self.subTitle.font = Helpers.mainFont(24)
        self.subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.logo.snp.bottom).offset(Helpers.padding*0.66)
            make.left.right.equalToSuperview()
        }

        self.subText.text = "If you haven't already, you'll need to create an account for the iMessage bot to use. It will use this account to relay message to you.\n\nYou can create an account at https://riot.im/app"
        self.subText.textColor = .gray
        self.subText.numberOfLines = 0
        self.subText.font = Helpers.mainFont(12)
        self.subText.snp.makeConstraints { (make) in
            make.top.equalTo(self.subTitle.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(Helpers.padding)
            make.right.equalToSuperview().offset(-Helpers.padding)
        }

        self.tableView.register(DynamicTextEntryCell.classForCoder(), 
                                forCellReuseIdentifier: String(describing: DynamicTextEntryCell.self))
        self.tableView.register(DescriptiveTextCell.classForCoder(), 
                                forCellReuseIdentifier: String(describing: DescriptiveTextCell.self))

        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.subText.snp.bottom).offset(56)
            make.left.equalToSuperview().offset(Helpers.padding)
            make.right.equalToSuperview().offset(-Helpers.padding)
            make.bottom.equalTo(self.button.snp.top)
        }

        self.button.backgroundColor = Helpers.green
        self.button.setTitle("continue", for: .normal)
        self.button.titleLabel?.font = Helpers.mainFont(24)
        self.button.layer.cornerRadius = 16;
        self.button.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(70)
            make.bottom.equalToSuperview().offset(-Helpers.padding)
            make.left.equalToSuperview().offset(Helpers.padding)
            make.right.equalToSuperview().offset(-Helpers.padding)
        }

        self.button.addAction { [weak self] in
            if let s = self {
                var credentialsLookGood = true

                let u = s.userIdCell?.textField.text
                if u?.isEmpty ?? true { credentialsLookGood = false }

                let p = s.passwordCell?.textField.text
                if p?.isEmpty ?? true { credentialsLookGood = false }

                if credentialsLookGood {
                    let serverUrl = s.serverUrlCell?.textField.text
                    s.attemptLogin(userId: u!, password: p!, serverUrl: serverUrl)
                } else {
                    log("credentials didn't look good")
                }
            }
        }

        self.pageNumber.text = "1/2"
        self.pageNumber.textColor = .gray
        self.pageNumber.font = Helpers.mainFont(12)
        self.pageNumber.textAlignment = .center
        self.pageNumber.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4)
        }
    }

    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.failedFindingServerUrl ? 4 : 3
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.cellTypeFor(indexPath.row) == DescriptiveTextCell.self {
            let t = self.textForDescriptiveCell(indexPath.row)
            return DescriptiveTextCell.heightFor(self.tableView.frame.size.width, text: t!) + 6
        } else {
            return DynamicTextEntryCell.height() + 6
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let t = self.cellTypeFor(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: t))

        if let c = cell as? DescriptiveTextCell {
            c.set(values: DescriptiveTextCell.Values(text: self.textForDescriptiveCell(indexPath.row), textColor: .gray))
            self.statusCell = c

        } else if let c = cell as? DynamicTextEntryCell {
            c.set(values: valuesFor(cell: indexPath.row))

            if indexPath.row == 0 {
                self.userIdCell = c
            } else if indexPath.row == 1 {
                self.serverUrlCell = c
            } else if indexPath.row == 2 {
                self.passwordCell = c
            }
        }
        return cell!
    }

    func textForDescriptiveCell(_ row: Int) -> String? {
        var result: String?
        if row == 1 && !self.failedFindingServerUrl {
            result = "@myImessageBot:matrix.org (for example)"
        } else if row == 2 && self.failedFindingServerUrl {
            result = "Your server URL wasn't found, but you can enter it here. It will look like https://matrix.org, for example"
        }
        return result
    }

    func cellTypeFor(_ row: Int) -> UITableViewCell.Type {
        if row == 1 && !self.failedFindingServerUrl {
            return DescriptiveTextCell.self
        } else if row == 2 && self.failedFindingServerUrl {
            return DescriptiveTextCell.self
        } else {
            return DynamicTextEntryCell.self
        }
    }

    func showInStatusCell(_ text: String) {
        if var v = self.statusCell?.values {
            v.text = text
            DispatchQueue.main.async { () in 
                self.statusCell?.set(values: v) 
            }
        }
    }

    func promptForServerUrl() {
        self.failedFindingServerUrl = true
        self.discoveredServerUrl = nil
        DispatchQueue.main.async { () in 
            self.tableView.insertRows(at:[IndexPath(row: 1, section: 0)], with:.none)
            self.tableView.reloadRows(at:[IndexPath(row: 2, section: 0)], with:.fade)
        }
    }

    func attemptLogin(userId: String, password: String, serverUrl: String? = nil) {
        if let u = (self.discoveredServerUrl ?? serverUrl) {
            log(u)
            UserDefaults.standard.set(u, forKey: Helpers.matrixBotServerUrl)
            self.matrixHandler.getToken(userId: userId, password: password, serverUrl: u, completion: { (success, token) in
                if success {
                    log("success")
                    if let t = token {
                        // Could also maybe store the token in keychain rather than in user defaults
                        log("got a token")
                        UserDefaults.standard.set(t, forKey: Helpers.matrixBotAccessToken)
                        UserDefaults.standard.set(userId, forKey: Helpers.matrixBotUserId)
                        self.continueAction?()
                    } else {
                        log("no token")
                    }
                } else {
                    log("failed login")
                }
            })
        } else {
            log("no server URL. Should prompt the user here")
        }
    }

    func handleBotUsernameEntry(_ userId: String?) {
        if let uid = userId {
            if MatrixHandler.checkUserIdLooksValid(uid) {
                MatrixHandler.getHomeserverURL(from: uid, completion: { url in
                    if let url = url {
                        self.discoveredServerUrl = url
                        UserDefaults.standard.set(url, forKey: Helpers.matrixBotServerUrl)
                        self.showInStatusCell("Matrix server found ✓")
                    } else {
                        self.promptForServerUrl()
                    }
                })
            } else {
                log("that userId does not look valid")
            }
        }
    }

    func valuesFor(cell: Int) -> DynamicTextEntryCell.Values {
        var values = DynamicTextEntryCell.Values()
        values.text = ""

        switch cell {
        case 0:
            values.label = "bot user ID"
            values.editingEnded = { [weak self] text in
                self?.handleBotUsernameEntry(text)
            }
        case 1:
            values.label = "server URL"
            values.editingEnded = { [weak self] text in
                log("user entered server URL: \(text ?? "")")
            }
        case 2:
            values.label = "password"
            values.secureText = true
        default:
            break
        }

        values.textColor = .white
        values.labelEditingAlpha = 0.55
        values.secondaryColor = .gray
        return values
    }
}
