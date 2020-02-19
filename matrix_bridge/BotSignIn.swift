import UIKit
import Foundation

class BotSignIn: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var matrixHandler: MatrixHandler?

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

    let padding = 44.0

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
            make.top.equalToSuperview().offset(padding)
            make.left.right.equalToSuperview()
        }

        self.subTitle.text = "sign in to Matrix"
        self.subTitle.textColor = .white
        self.subTitle.textAlignment = .center
        self.subTitle.font = Helpers.mainFont(24)
        self.subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.logo.snp.bottom).offset(padding*0.66)
            make.left.right.equalToSuperview()
        }

        self.subText.text = "If you haven't already, you'll need to create an account for the iMessage bot to use. It will use this account to relay message to you.\n\nYou can create an account at https://riot.im/app"
        self.subText.textColor = .gray
        self.subText.numberOfLines = 0
        self.subText.font = Helpers.mainFont(12)
        self.subText.snp.makeConstraints { (make) in
            make.top.equalTo(self.subTitle.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
        }

        self.tableView.register(DynamicTextEntryCell.classForCoder(), forCellReuseIdentifier: "DynamicTextEntryCell")
        self.tableView.register(DescriptiveTextCell.classForCoder(), forCellReuseIdentifier: "DescriptiveTextCell")

        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        self.tableView.snp.makeConstraints { (make) in
            //make.centerY.equalTo(self.view.snp.centerYWithinMargins).offset(12)
            //make.height.equalTo(140)
            make.top.equalTo(self.subText.snp.bottom).offset(80)
            make.left.equalToSuperview().offset(padding-24)
            make.right.equalToSuperview().offset(-(padding-24))
            make.bottom.equalTo(self.button.snp.top)
        }

        self.button.backgroundColor = Helpers.green
        self.button.setTitle("continue", for: .normal)
        self.button.titleLabel?.font = Helpers.mainFont(24)
        self.button.layer.cornerRadius = 16;
        self.button.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(70)
            make.bottom.equalToSuperview().offset(-padding)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
        }

        self.button.addAction { [weak self] in
            if self != nil {
                log("continue to second sign in page")
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
        switch indexPath.row {
        case 1:
            return self.failedFindingServerUrl ? 58 : 24
        case 2:
            return self.failedFindingServerUrl ? 24 : 58
        default:
            return 58
        }
    }

    func descriptiveCellWith(_ text: String) -> DescriptiveTextCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptiveTextCell") as! DescriptiveTextCell
        cell.backgroundColor = UIColor.clear
        let v = DescriptiveTextCell.Values(text: text, textColor: .gray)
        cell.set(values: v)
        return cell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 && !self.failedFindingServerUrl {
            let cell = self.descriptiveCellWith("@myImessageBot:matrix.org (for example)")
            self.statusCell = cell
            return cell
        } else if indexPath.row == 2 && self.failedFindingServerUrl {
            let cell = self.descriptiveCellWith("Server URL wasn't found, but you can enter it here")
            self.statusCell = cell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicTextEntryCell") as! DynamicTextEntryCell
            cell.backgroundColor = UIColor.clear
            let v = valuesFor(cell: indexPath.row)
            cell.set(values: v)

            if indexPath.row == 0 {
                self.userIdCell = cell
            } else if indexPath.row == 1 {
                self.serverUrlCell = cell
            } else if indexPath.row == 2 {
                self.passwordCell = cell
            }

            return cell
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
        DispatchQueue.main.async { () in 
            self.tableView.insertRows(at:[IndexPath(row: 1, section: 0)], with:.none)
            self.tableView.reloadRows(at:[IndexPath(row: 2, section: 0)], with:.fade)
        }
        log("could't get matrix server client URL")
    }

    func handleBotUsernameEntry(_ userId: String?) {
        if let uid = userId {
            if MatrixHandler.checkUserIdLooksValid(uid) {
                MatrixHandler.getHomeserverURL(from: uid, completion: { url in
                    if let url = url {
                        self.matrixHandler = MatrixHandler(url)
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
                log("user entered server URL: \(text)")
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
