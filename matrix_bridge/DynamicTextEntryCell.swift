import UIKit
import SnapKit


class DynamicTextEntryCell: UITableViewCell, UITextFieldDelegate {

    public struct Values {
        var label: String?
        var labelEditingAlpha = CGFloat(0.5)
        var text: String?
        var secureText = false
        var autoCorrect = false
        var selectOnTap = false
        var capitalization: UITextAutocapitalizationType = .none
        var dontSelectTextField = false
        var keyboardType = UIKeyboardType.default
        var tapped: (() -> Void)?
        var textColor = UIColor.black
        var secondaryColor = UIColor.black
    }

    var labelYConstraint: Constraint!
    private let labelYOffset: CGFloat = 8.0
    lazy var textField = UITextField()
    lazy var label = UILabel()
    lazy var hitbox = UIButton()
    lazy var line = UIView()

    let labelDownscale: CGFloat = 0.7
    var values: Values?

    var subviewHaveBeenLayedOut = false

    enum SelectionState {
        case Default
        case Editing
    }

    var state: SelectionState = .Default

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    func setup() {
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(0.5)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview()
        }

        self.contentView.addSubview(label)
        label.font = Helpers.mainFont(16)
        label.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(21)
            make.left.equalToSuperview().offset(24)
            self.labelYConstraint = make.bottom.equalTo(line).offset(-self.labelYOffset).constraint
        }

        self.contentView.addSubview(textField)
        textField.font = Helpers.mainFont(16)
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        textField.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(21)
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(line).offset(-self.labelYOffset)
        }

        self.contentView.addSubview(hitbox)
        hitbox.snp.makeConstraints { (make) -> Void in
            make.top.bottom.left.right.equalToSuperview().priority(.medium)
        }

        hitbox.addAction { [weak self] in
            if let s = self {
                if !(s.values?.dontSelectTextField ?? true) {
                    s.textField.becomeFirstResponder()
                }
                s.values?.tapped?()
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        updateState(selected: true, animate: true)
        hitbox.isHidden = true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        updateState(selected: false, animate: true)
        hitbox.isHidden = false
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func updateState(selected: Bool, animate: Bool) {
        if !selected && textField.text?.isEmpty ?? true && state != .Default {
            changeToDefault(animate)
        }
        else if (selected || !(textField.text?.isEmpty ?? true)) && state != .Editing {
            changeToEditing(animate)
        }
    }

    func set(values: Values) {
        self.values = values
        label.text = values.label
        label.textColor = values.textColor
        line.backgroundColor = values.secondaryColor
        textField.text = values.text
        textField.textColor = values.textColor
        textField.isSecureTextEntry = values.secureText
        textField.autocorrectionType = values.autoCorrect ? .yes : .no
        textField.autocapitalizationType = values.capitalization
        textField.isUserInteractionEnabled = !values.dontSelectTextField
        textField.returnKeyType = .done
        textField.keyboardType = values.keyboardType
        updateState(selected: false, animate: false)
    }

    func changeToDefault(_ animate: Bool) {
        state = .Default
        self.labelYConstraint.update(offset: -self.labelYOffset)

        if animate {
            UIView.animate(withDuration: 0.3) {
                self.label.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 0)
                self.label.alpha = 1.0
                self.layoutIfNeeded()
            }
        } else {
            self.label.transform = CGAffineTransform(scaleX: 1, y: 1).translatedBy(x: 0, y: 0)
            self.layoutIfNeeded()
        }
    }

    func changeToEditing(_ animate: Bool) {
        self.state = .Editing
        self.textField.layoutSubviews()
        self.layoutIfNeeded()

        self.labelYConstraint.update(offset: -(self.textField.bounds.size.height + self.labelYOffset + 2))

        let s = self.labelDownscale
        let translation = self.label.bounds.size.width * -(1 - s) * 0.5 * (1.0/s)

        if animate {
            UIView.animate(withDuration: 0.3) {
                self.label.transform = CGAffineTransform(scaleX: s, y: s).translatedBy(x: translation, y: 0)
                if let v = self.values { self.label.alpha = v.labelEditingAlpha }
                self.layoutIfNeeded()
            }
        } else {
            self.label.transform = CGAffineTransform(scaleX: s, y: s).translatedBy(x: translation, y: 0)
            self.layoutIfNeeded()
        }
    }
}
