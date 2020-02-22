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

    static let fontSize = CGFloat(12)

    static func heightFor(_ width: CGFloat, text: String) -> CGFloat {
        return DescriptiveTextCell.labelHeight(width,
                                    font: Helpers.mainFont(DescriptiveTextCell.fontSize),
                                    text: text)

    }

    static func labelHeight(_ width: CGFloat, font: UIFont, lineLimit: Int = 0, text: String) -> CGFloat {
        let u = UILabel()
        u.font = font
        u.text = text
        u.lineBreakMode = .byWordWrapping
        let r = u.textRect(forBounds: CGRect(x:0, y:0, width: width, height: CGFloat.greatestFiniteMagnitude),
                           limitedToNumberOfLines: lineLimit)
        return r.height
    }


    func setup() {
        self.addSubview(label)
        self.backgroundColor = .clear
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = Helpers.mainFont(DescriptiveTextCell.fontSize)
        label.snp.makeConstraints { (make) -> Void in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(21)
            make.left.right.equalToSuperview()
        }
    }

    func set(values: Values) {
        self.values = values
        label.text = values.text
        label.textColor = values.textColor
    }
}
