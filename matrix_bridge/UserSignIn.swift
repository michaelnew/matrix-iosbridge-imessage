import UIKit
import Foundation

class UserSignIn: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var matrixHandler: MatrixHandler?

    lazy var tableView = UITableView()
    lazy var logo = UILabel()
    lazy var subTitle = UILabel()
    lazy var subText = UILabel()
    lazy var button = UIButton()
    lazy var pageNumber = UILabel()
    var userIdCell: DynamicTextEntryCell?
    var continueAction: (() -> Void)?

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

        self.subTitle.text = "enter your user ID"
        self.subTitle.textColor = .white
        self.subTitle.textAlignment = .center
        self.subTitle.font = Helpers.mainFont(24)
        self.subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.logo.snp.bottom).offset(Helpers.padding*0.66)
            make.left.right.equalToSuperview()
        }

        self.subText.text = "This is the account the bot will relay messages to (so... you). It will look something like @myCleverUsername:matrix.org"
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

                var credentialsLookGood = false

                if let u = s.userIdCell?.textField.text {
                    credentialsLookGood = MatrixHandler.checkUserIdLooksValid(u)
                    if credentialsLookGood {
                        UserDefaults.standard.set(u, forKey: "matrixUserId")
                        s.continueAction?()
                    }
                }
                if !credentialsLookGood {
                    log("matrix ID was invalid")
                }
            }
        }

        self.pageNumber.text = "2/2"
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
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DynamicTextEntryCell.height() + 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let t = self.cellTypeFor(indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: t))

        if let c = cell as? DynamicTextEntryCell {
            c.set(values: valuesFor(cell: indexPath.row))

            if indexPath.row == 0 {
                self.userIdCell = c
            }
        }
        return cell!
    }

    func cellTypeFor(_ row: Int) -> UITableViewCell.Type {
        return DynamicTextEntryCell.self
    }

    func handleUsernameEntry(_ userId: String?) {
        if let uid = userId {
            if MatrixHandler.checkUserIdLooksValid(uid) {
                log("user ID looks good")
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
            values.label = "your user ID"
            values.editingEnded = { [weak self] text in
                self?.handleUsernameEntry(text)
            }
        case 1:
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
