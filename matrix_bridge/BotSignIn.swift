import UIKit
import Foundation

class BotSignIn: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var matrixHandler = MatrixHandler()

    lazy var tableView = UITableView()
    lazy var button = UIButton()
    var userIdCell: DynamicTextEntryCell?
    var passwordCell: DynamicTextEntryCell?
    var serverUrlCell: DynamicTextEntryCell?
    var continueAction: (() -> Void)?

    let padding = 32.0

    override func loadView() {
        super.loadView()

        self.view.backgroundColor = UIColor(red: 16.0/255.0, green: 8.0/255.0, blue: 25.0/255.0, alpha: 1.0)
        self.view.addSubview(self.tableView)

        self.tableView.register(DynamicTextEntryCell.classForCoder(), forCellReuseIdentifier: "DynamicTextEntryCell")
        self.tableView.backgroundColor = .clear
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        self.tableView.allowsSelection = false
        self.tableView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view.snp.centerYWithinMargins)
            make.height.equalTo(116)
            make.left.equalToSuperview().offset(padding)
            make.right.equalToSuperview().offset(-padding)
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
            values.keyboardType = .emailAddress
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
