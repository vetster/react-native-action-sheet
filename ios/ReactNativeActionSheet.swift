import UIKit

struct AlertButton {
    let title: String;
    let leftIcon: UIImage?
    let rightIcon: UIImage?
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
            let title = options["title"] as? String
            let message = options["message"] as? String
            var buttons:[AlertButton] = []
            
            var useCustom = false
            
            if let incomingButtons = options["options"] as? [Any]{
                for item in incomingButtons {
                    if let itemDict = item as? [String: Any],
                       let title = itemDict["title"] as? String {
                        
                        var leftIconImage: UIImage?
                        if let leftIcon = itemDict["leftIcon"] as? String {
                            if #available(iOS 13.0, *), let image = UIImage(systemName: leftIcon) {
                                leftIconImage = image
                            } else if let image = UIImage(named: leftIcon){
                                leftIconImage = image.imageWithSize(scaledToSize: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
                            }
                        }
                        
                        var rightIconImage: UIImage?
                        if let rightIcon = itemDict["rightIcon"] as? String {
                            if #available(iOS 13.0, *), let image = UIImage(systemName: rightIcon) {
                                rightIconImage = image
                            } else if let image = UIImage(named: rightIcon){
                                rightIconImage = image.imageWithSize(scaledToSize: CGSize(width: 20, height: 20)).withRenderingMode(.alwaysTemplate)
                            }
                        }
                        
                        let alertButton = AlertButton(
                            title: title,
                            leftIcon: leftIconImage,
                            rightIcon: rightIconImage)
                        
                        buttons.append(alertButton)
                        
                        if rightIconImage != nil {
                            useCustom = true
                        }
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
            
            let alertController: UIAlertController
            
            if useCustom {
                alertController = ActionSheetController(
                    title: title,
                    message: message,
                    configuration: ActionSheetConfiguration(
                        buttons: buttons,
                        callback: callback,
                        cancelButtonIndex: cancelButtonIndex,
                        destructiveButtonIndices: destructiveButtonIndices,
                        disabledButtonIndices: disabledButtonIndices,
                        tintColor: tintColorHex,
                        cancelButtonTintColorHex: cancelButtonTintColorHex,
                        hideExtraSeparator: title == nil && message == nil
                    )
                )
            } else {
                alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            }
            
            alertController.modalPresentationStyle = .popover;
            
            if !useCustom {
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
                        if let image = option.leftIcon {
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

extension UIImage {

    func imageWithSize(scaledToSize newSize: CGSize) -> UIImage {
        
        let scale = size.width / size.height
        
        let size = CGSize(width: newSize.width * scale, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

}
