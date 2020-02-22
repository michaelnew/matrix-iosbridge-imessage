import UIKit

func log(_ message: String) {
     NSLog("IMBR : " + message)
}

public class Helpers {
    public static let green = UIColor(red:33.0/255.0, green:152.0/255.0, blue:58.0/255.0, alpha: 1.0)
    //public static let background = UIColor(red: 16.0/255.0, green: 8.0/255.0, blue: 25.0/255.0, alpha: 1.0)
    public static let background = UIColor.black

    public static let padding = 40.0

    public static func mainFont(_ size: CGFloat) -> UIFont {
        return UIFont(name:"HackNerdFontComplete-Regular", size: size)!
    }
}

