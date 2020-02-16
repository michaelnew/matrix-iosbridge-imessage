import UIKit
import Foundation

class BotSignIn: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var matrixHandler = MatrixHandler()

    lazy var tableView = UITableView()
    lazy var logo = UILabel()
    lazy var subTitle = UILabel()
    lazy var subText = UILabel()
    lazy var button = UIButton()
    var userIdCell: DynamicTextEntryCell?
    var passwordCell: DynamicTextEntryCell?
    var serverUrlCell: DynamicTextEntryCell?
    var continueAction: (() -> Void)?

    let padding = 44.0

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = Helpers.background

        self.view.addSubview(self.logo)
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.subTitle)
        self.view.addSubview(self.subText)
        self.view.addSubview(self.button)


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
            make.top.equalTo(self.logo.snp.bottom).offset(padding)
            make.left.right.equalToSuperview()
        }

        self.subText.text = "If you haven't already, you'll need to create an account for the iMessage bot to use. It will use this account to relay message to you.\n\nYou can create an account at https://riot.im/app"
        self.subText.textColor = .gray
        self.subText.numberOfLines = 0
        self.subText.font = UIFont(name: "HackNerdFontComplete-Regular", size: 12)
        self.subText.snp.makeConstraints { (make) in
            make.top.equalTo(self.subTitle.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
        }

        self.tableView.register(DynamicTextEntryCell.classForCoder(), forCellReuseIdentifier: "DynamicTextEntryCell")
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        self.tableView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerYWithinMargins).offset(12)
            make.height.equalTo(116)
            make.left.equalToSuperview().offset(padding-24)
            make.right.equalToSuperview().offset(-(padding-24))
        }

        button.backgroundColor = Helpers.green
        button.setTitle("continue", for: .normal)
        button.titleLabel?.font = Helpers.mainFont(24)
        button.layer.cornerRadius = 16;
        button.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(70)
            make.bottom.equalToSuperview().offset(-padding)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
        }

        button.addAction { [weak self] in
            if let s = self {
                log("continue to second sign in page")
            }
        }

    }

    // MARK: - Table View Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DynamicTextEntryCell") as! DynamicTextEntryCell
        cell.backgroundColor = UIColor.clear
        let v = valuesFor(cell: indexPath.row)
        cell.set(values: v)

        if indexPath.row == 0 {
            self.userIdCell = cell
        } else if indexPath.row == 1 {
            self.passwordCell = cell
        } else if indexPath.row == 2 {
            self.serverUrlCell = cell
        }

        return cell
    }

    func valuesFor(cell: Int) -> CellValues {
        var values = CellValues()
        values.text = ""

        switch cell {
        case 0:
            values.label = "bot user ID"
            //values.keyboardType = .emailAddress
        case 1:
            values.label = "password"
            values.secureText = true
        default:
            break
        }

        values.textColor = .white
        values.secondaryColor = .gray
        return values
    }


}
