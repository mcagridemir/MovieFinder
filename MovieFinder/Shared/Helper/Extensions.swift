//
//  Extensions.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import UIKit

extension UIColor {
    convenience init(hexString: String) {
            let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int = UInt64()
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (255, 0, 0, 0)
            }
            self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
        }
    
    static let mainBlackColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0)
    static let mainWhiteColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    static let orangeColor = UIColor(red: 249/255, green: 157/255, blue: 28/255, alpha: 1.0)
    static let gray230 = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
    static let gray179 = UIColor(red: 179/255, green: 179/255, blue: 179/255, alpha: 1.0)
    static let gray51 = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    static let redColor = UIColor(red: 253/255, green: 11/255, blue: 11/255, alpha: 1.0)
    static let pdpRedColor = UIColor(red: 237/255, green: 94/255, blue: 94/255, alpha: 1.0)
    static let borderColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 0.16)
    static let blueColor = UIColor(red: 234/255, green: 240/255, blue: 254/255, alpha: 1.0)
    static let pdpGreen = UIColor(red: 91/255, green: 188/255, blue: 82/255, alpha: 1.0)
    
    static var placeholder: UIColor {
      if #available(iOS 13.0, *) {
        return .placeholderText
      }
        return UIColor(red: 60, green: 60, blue: 67, alpha: 0.3)
    }
}

extension CGColor {
    static let whiteColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
    static let orangeColor = UIColor(red: 249/255, green: 157/255, blue: 28/255, alpha: 1.0).cgColor
    static let gray230 = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0).cgColor
    static let borderColor = UIColor(red: 223/255, green: 225/255, blue: 227/255, alpha: 1.0).cgColor
}

extension UICollectionView {
    func registerNib(_ nibName: AnyClass) {
        register(UINib(nibName: String(describing: nibName), bundle: nil), forCellWithReuseIdentifier: String(describing: nibName))
    }
    
    func dequeueReusableCell<T: AnyObject> (indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }
    
    func register (cell: AnyClass) {
        register(cell.self, forCellWithReuseIdentifier: String(describing: cell.self))
    }
}

extension UICollectionViewCell {
    func configureNibForCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(getNib() ?? UIView())
    }
}

extension UITableView {
    func registerNib(_ nibName: AnyClass) {
        register(UINib(nibName: String(describing: nibName), bundle: nil), forCellReuseIdentifier: String(describing: nibName))
    }
    
    func dequeueReusableCell<T: AnyObject> (indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T
    }
    
    func register (cell: AnyClass) {
        register(cell.self, forCellReuseIdentifier: String(describing: cell.self))
    }
}

extension UITableViewCell {
    func configureNibForCell() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.addSubview(getNib() ?? UIView())
    }
}

extension UIView {
    
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        if let nibName = type(of: self).description().components(separatedBy: ".").last {
            let nib = UINib(nibName: nibName, bundle: bundle)
            return nib.instantiate(withOwner: self, options: nil).first as! UIView
        }
        return UIView()
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    func setCorners(_ corners: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = corners
    }
    
    func addTapGesture(tapNumber: Int, target: Any, action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = tapNumber
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true
    }
    
    func getNib() -> UIView? {
        guard let nibName = type(of: self).description().components(separatedBy: ".").last, !nibName.isEmpty else {
            return nil
        }
        let nib = UINib(nibName: nibName, bundle: Bundle(for: type(of: self)))
        let view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view?.backgroundColor = .clear
        view?.frame = bounds
        return view
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let bottomBorder = UIView()
        bottomBorder.tag = 1903
        bottomBorder.backgroundColor = UIColor.mainBlackColor
        bottomBorder.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.addSubview(bottomBorder)
     }
    
    func removeBottomBorder() {
        if let bottomBorder = self.viewWithTag(1903) {
            bottomBorder.removeFromSuperview()
        }
    }
}

extension UIButton {

    func tap(_ closure: @escaping ()->()) {
        self.touchUpInside(closure)
    }
    
    func centerButtonAndImage(withSpacing: CGFloat) {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: withSpacing)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: withSpacing, bottom: 0, right: 0)
    }
    
}
extension UIControl {
    
    func touchUpInside(_ closure: @escaping ()->()) {
        let sleeve = ClosureSleeve(closure)
        
        removeTarget(nil, action: nil, for: .allEvents)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: .touchUpInside)
        objc_setAssociatedObject(self, String(format: "[%d]", arc4random()), sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
    }
    
}

class ClosureSleeve {
    
    let closure: ()->()
    
    init (_ closure: @escaping ()->()) {
        self.closure = closure
    }
    
    @objc func invoke () {
        closure()
    }
    
}

extension String {
    var localized: String {
        return Localizator.sharedInstance.localize(string: self)
    }
    var spaceToUrl: String {
        return self.replace(target: " ", withString: "%20")
    }
    func replace(target: String, withString: String) -> String
    {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func capitalizeFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}

private class Localizator {
    static let sharedInstance = Localizator()
    
    func localize(string: String) -> String {
        let lang = Globals.shared.LanguageCode
        if let path = Bundle.main.path(forResource: lang, ofType: "lproj"), let bundle = Bundle.init(path: path) {
            return bundle.localizedString(forKey: string, value: nil, table: nil)
        }
        return ""
    }
}

extension UILabel {

    func retrieveTextHeight() -> CGFloat {
        let attributedText = NSAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font: self.font])

        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(rect.size.height)
    }
    
    func addCharacterSpacing(kernValue: Double = 1.15) {
      if let labelText = text, labelText.count > 0 {
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: attributedString.length - 1))
        attributedText = attributedString
      }
    }
    
    func makeStrikeThrough(_ text: String?) {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        self.attributedText = attributeString
    }
    
    /// This function configures line height for label.
    func setTextWithLineHeightMultiple(text: String, lineHeightMultiple: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attrString = NSMutableAttributedString(string: text)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))

        self.attributedText = attrString
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}


extension UIImage {

    public func maskWithColor(color: UIColor) -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!

        let rect = CGRect(origin: CGPoint.zero, size: size)

        color.setFill()
        self.draw(in: rect)

        context.setBlendMode(.darken)
        context.fill(rect)

        let resultImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return resultImage
    }

}

extension UIViewController {
    func openWebView(_ url: String, _ title: String) {
        /*let storyboard = StoryboardRedirect.Modals.instance
        let vc = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
        vc.initViews(title: title, url: url, shortHeight: Globals.shared.screenHeight * 0.016502463054187)
        presentPanModal(vc)*/
    }
    
    func openURL(string: String?) {
        guard let string = string else { return }
        openURL(url: URL(string: string))
    }
    
    func openURL(url: URL?) {
        guard let url = url else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    var length: Int {
        return count
    }
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    func getPossixDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: self) ?? Date()
        return date
    }
    
    func colorPartOfString(stringToColor: String, partColor: UIColor) -> NSMutableAttributedString {
        let range = (self as NSString).range(of: stringToColor)
        let mutableAttributedString = NSMutableAttributedString.init(string: self)
        mutableAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: partColor, range: range)
        return mutableAttributedString
    }
}


extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}

func translate( _ key: String, _ table: String) -> String {
    return key.description.localized
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func formatDate(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let formatedDate = dateFormatter.string(from: self)
        return formatedDate
    }
}

extension UIBarButtonItem {
    class func itemWith(colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.addTarget(target, action: action, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    class func itemWithRight(colorfulImage: UIImage?, target: AnyObject, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(colorfulImage, for: .normal)
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        button.addTarget(target, action: action, for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)

        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

extension Int {
    var toString: String {
        get {
            return String(self)
        }
    }
}

extension Encodable {
    func modelToDict() -> [String: Any]? {
        let encoder = JSONEncoder()
        let jsonData = try! encoder.encode(self)
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: [])
        return json as? [String: Any]
    }
}

extension String {
    var toDate: Date? {
        get {
            return DateFormatter().date(from: self)
        }
    }
    
    func formatDate() -> String? {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"

        if let date = dateFormatterGet.date(from: self) {
            return dateFormatterPrint.string(from: date)
        } else {
           print("There was an error decoding the string")
        }
        return nil
    }
}

extension Sequence {
    /// Returns an array containing, in order, the first instances of
    /// elements of the sequence that compare equally for the keyPath.
    func unique<T: Hashable>(for keyPath: KeyPath<Element, T>) -> [Element] {
        var unique = Set<T>()
        return filter { unique.insert($0[keyPath: keyPath]).inserted }
    }
}

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}

