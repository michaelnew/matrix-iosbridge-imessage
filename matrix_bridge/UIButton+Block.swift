import UIKit
import os.log

// From here: https://stackoverflow.com/questions/24962151/hooking-up-uibutton-to-closure-swift-target-action
// See here for possible improvement: https://gist.github.com/PEZ/e4a790870855a0bb3a45da2da8f71aa3

class ClosureSleeve {
    var closure: (() -> ())? = nil
    var closureWithTouch: ((UITouch) -> ())? = nil

    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }

    init(attachTo: AnyObject, closure: @escaping (UITouch) -> ()) {
        self.closureWithTouch = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }

    @objc func invoke(sender: UIButton, forEvent event: UIEvent) {
        if event.type ==  UIEventType.touches {
            if let t = event.touches(for: sender)?.first {
                closureWithTouch?(t)
            }
        }
        closure?()
    }
}

extension UIControl {
    // use function overloading to allow the caller handle the UITouch, if they want it
    func addAction(for controlEvents: UIControlEvents = UIControlEvents.touchUpInside, action: @escaping (UITouch) -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }

    func addAction(for controlEvents: UIControlEvents = UIControlEvents.touchUpInside, action: @escaping () -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }

    func removeActions() {
        self.removeTarget(nil, action: nil, for: .primaryActionTriggered)
    }
}
