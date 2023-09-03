import UIKit

struct AlertButton:Codable {
    let title: String;
    let iconName: String?
}

@objc(ReactNativeActionSheet)
class ReactNativeActionSheet: NSObject {
    
    var alertControllers: [UIAlertController] = []
    
    func presentViewController(_ alertController: UIViewController,
                               onParentViewController parentViewController: UIViewController) {
        alertController.modalPresentationStyle = .popover
        let sourceView = parentViewController.view
        
        
        alertController.popoverPresentationController?.permittedArrowDirections = []
        alertController.popoverPresentationController?.sourceView = sourceView
        if let bounds = sourceView?.bounds {
            alertController.popoverPresentationController?.sourceRect = bounds
        }
        parentViewController.present(alertController, animated: true, completion: nil)
    }

    @objc(showActionSheetWithOptions:callback:)
    func showActionSheetWithOptions(_ options: [String: Any],
                                    callback: @escaping RCTResponseSenderBlock) {
        DispatchQueue.main.async {
            NSLog("called")
            let title = options["title"] as? String
            let message = options["message"] as? String
            var buttons:[AlertButton] = []
            
            if let incomingButtons = options["options"] as? [Any]{
                for item in incomingButtons {
                    if let itemDict = item as? [String: Any],
                       let title = itemDict["title"] as? String {
                        let iconName = itemDict["iconName"] as? String
                        let alertButton = AlertButton(title: title, iconName: iconName)
                        buttons.append(alertButton)
                    }
                }
            }
           
            var disabledButtonIndices: [Int] = []
            let cancelButtonIndex = options["cancelButtonIndex"] as? Int ?? -1
            var destructiveButtonIndices: [Int] = []
            
            if let disabledIndices = options["disabledButtonIndices"] as? [Double] {
                disabledButtonIndices = disabledIndices.map { Int($0) }
            }
            
            if let destructiveButtonIndexes = options["destructiveButtonIndex"] as? [Double] {
                destructiveButtonIndices = destructiveButtonIndexes.map { Int($0) }
            } else if let destructiveButtonIndex = options["destructiveButtonIndex"] as? Double {
                destructiveButtonIndices = [Int(destructiveButtonIndex)]
            } else {
                destructiveButtonIndices = [-1]
            }
            
            guard let controller = RCTPresentedViewController() else {
                NSLog("Tried to display action sheet but there is no application window. options: \(options)")
                return
            }
            
            let tintColorHex = options["tintColor"] as? String
            let cancelButtonTintColorHex = options["cancelButtonTintColor"] as? String
            let userInterfaceStyle = options["userInterfaceStyle"] as? String
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            alertController.modalPresentationStyle = .popover;
            
            var isCancelButtonIndex = false
            var callbackInvoked = false
            
            for (index, option) in buttons.enumerated() {
                var style: UIAlertAction.Style = .default
                
                if destructiveButtonIndices.contains(index) {
                    style = .destructive
                } else if index == cancelButtonIndex {
                    style = .cancel
                    isCancelButtonIndex = true
                }
                                
                let actionButton = UIAlertAction(title: option.title, style: style) { _ in
                    if !callbackInvoked {
                        callbackInvoked = true
                        callback([index])
                    }
                }
                
                if #available(iOS 13.0, *) {
                    if let iconName = option.iconName,
                       let image = UIImage(systemName: iconName) {
                        actionButton.setValue(image, forKey: "image")
                    }
                } else {
                    // Fallback on earlier versions
                }
                
                if isCancelButtonIndex {
                    if let cancelButtonTintColorHex = cancelButtonTintColorHex,
                       let cancelButtonTintColor = UIColor(hex: cancelButtonTintColorHex) {
                        actionButton.setValue(cancelButtonTintColor, forKey: "titleTextColor")
                    }
                }
                
                alertController.addAction(actionButton)
            }
            
            for disabledIndex in disabledButtonIndices {
                if disabledIndex < buttons.count {
                    alertController.actions[disabledIndex].isEnabled = false
                } else {
                    NSLog("Index \(disabledIndex) from `disabledButtonIndices` is out of bounds. Maximum index value is \(buttons.count - 1).")
                    return
                }
            }
            
            if let tintColorHex = tintColorHex,
               let tintColor = UIColor(hex: tintColorHex) {
                alertController.view.tintColor = tintColor
            }
            
            if #available(iOS 13.0, *) {
                if let userInterfaceStyle = userInterfaceStyle {
                    switch userInterfaceStyle {
                    case "dark":
                        alertController.overrideUserInterfaceStyle = .dark
                    case "light":
                        alertController.overrideUserInterfaceStyle = .light
                    default:
                        alertController.overrideUserInterfaceStyle = .unspecified
                    }
                }
            } else {
                // Fallback on earlier versions
            }
            
            
            self.presentViewController(alertController, onParentViewController: controller)
        }
    }
    
    @objc
    func dismissActionSheet() {
        if alertControllers.isEmpty {
            print("Unable to dismiss action sheet")
        }

        if let alertController = alertControllers.last {
            alertController.dismiss(animated: true, completion: nil)
            alertControllers.removeLast()
        }
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
