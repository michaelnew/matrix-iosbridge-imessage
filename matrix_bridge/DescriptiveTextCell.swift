import UIKit
import SnapKit

class DescriptiveTextCell: UITableViewCell {

    public struct Values {
        var text: String?
        var textColor = UIColor.black
    }

    lazy var label = UILabel()
    var values: Values?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        self.contentView.addSubview(label)
        label.font = Helpers.mainFont(12)
        label.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(21)
            make.left.equalToSuperview().offset(24)
        }
    }
    func set(values: Values) {
        self.values = values
        label.text = values.text
        label.textColor = values.textColor
    }
}
