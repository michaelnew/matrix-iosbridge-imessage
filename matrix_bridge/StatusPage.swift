import UIKit
import Foundation

class StatusPage: UIViewController {

    lazy var tableView = UITableView()
    lazy var logo = UILabel()
    lazy var subTitle = UILabel()
    lazy var subText = UILabel()
    lazy var button = UIButton()
    var userIdCell: DynamicTextEntryCell?
    var continueAction: (() -> Void)?

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = Helpers.background

        self.view.addSubview(self.logo)
        self.view.addSubview(self.subTitle)
        self.view.addSubview(self.subText)
        self.view.addSubview(self.button)

        self.logo.text = "[m]"
        self.logo.textColor = Helpers.green
        self.logo.textAlignment = .center
        self.logo.font = Helpers.mainFont(48)
        self.logo.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(Helpers.padding)
            make.left.right.equalToSuperview()
        }

        self.subTitle.text = "Matrix"
        self.subTitle.textColor = .white
        self.subTitle.textAlignment = .center
        self.subTitle.font = Helpers.mainFont(24)
        self.subTitle.snp.makeConstraints { (make) in
            make.top.equalTo(self.logo.snp.bottom).offset(Helpers.padding*0.66)
            make.left.right.equalToSuperview()
        }

        self.subText.text = "✓ connected"
        self.subText.textColor = .gray
        self.subText.numberOfLines = 0
        self.subText.font = Helpers.mainFont(12)
        self.subText.snp.makeConstraints { (make) in
            make.top.equalTo(self.subTitle.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(Helpers.padding)
            make.right.equalToSuperview().offset(-Helpers.padding)
        }

        self.button.backgroundColor = Helpers.red
        self.button.setTitle("log out", for: .normal)
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
                s.continueAction?()
            }
        }
    }
}
