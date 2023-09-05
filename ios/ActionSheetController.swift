//
//  ActionSheetController.swift
//  VetsterRNActionSheet
//
//  Created by Darshan Jain on 2023-09-04.
//

import Foundation

struct ActionSheetConfiguration {
    var buttons:[AlertButton] = []
    var callback: RCTResponseSenderBlock?
    var cancelButtonIndex: Int?
    var destructiveButtonIndices: [Int] = []
    var disabledButtonIndices: [Int] = []
    var tintColor: String?
    var cancelButtonTintColorHex: String?
    var hideExtraSeparator = true
}

class ActionSheetController: UIAlertController, UITableViewDelegate, UITableViewDataSource {
    
    private var controller : UITableViewController
    
    var configuration: ActionSheetConfiguration = ActionSheetConfiguration()
    var callbackInvoked = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        controller = UITableViewController(style: .plain)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        controller.tableView.register(ActionSheetTableViewCell.self, forCellReuseIdentifier: ActionSheetTableViewCell.identifier)
        
        controller.tableView.allowsSelection = true
        controller.tableView.allowsMultipleSelection = false
        controller.tableView.delegate = self
        controller.tableView.dataSource = self
        
        controller.tableView.bounces = false
        
        controller.tableView.addObserver(self, forKeyPath: "contentSize", options: [.initial, .new], context: nil)
        
        self.setValue(controller, forKey: "contentViewController")
        
        controller.tableView.backgroundColor = .clear
        
        controller.tableView.separatorInset = .zero
        controller.tableView.separatorStyle = .none
        controller.viewRespectsSystemMinimumLayoutMargins = false
    }
    
    public convenience init(title: String?, message: String?, configuration: ActionSheetConfiguration) {
        self.init(title: title, message: message, preferredStyle: .actionSheet)
        self.configuration = configuration
        
        if let cancelButtonIndex = configuration.cancelButtonIndex,
           cancelButtonIndex > -1 && cancelButtonIndex < configuration.buttons.endIndex,
           let callback = configuration.callback {
            let option = configuration.buttons[cancelButtonIndex]
            let actionButton = UIAlertAction(title: option.title, style: .cancel) { _ in
                if !self.callbackInvoked {
                    self.callbackInvoked = true
                    callback([cancelButtonIndex])
                }
            }
            
            if let cancelButtonTintColorHex = configuration.cancelButtonTintColorHex,
               let cancelButtonTintColor = UIColor(hex: cancelButtonTintColorHex) {
                actionButton.setValue(cancelButtonTintColor, forKey: "titleTextColor")
            }
            
            addAction(actionButton)
            
            self.configuration.buttons.remove(at: cancelButtonIndex)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentSize" else {
            return
        }
        
        controller.preferredContentSize = controller.tableView.contentSize
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        controller.tableView.removeObserver(self, forKeyPath: "contentSize")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configuration.buttons.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 57
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ActionSheetTableViewCell.identifier, for: indexPath) as? ActionSheetTableViewCell else {
            return UITableViewCell()
        }
        
        let index = indexPath.row
        let option = configuration.buttons[index]
        
        
        cell.title.text = option.title
        
        cell.setDisabled(disabled: configuration.disabledButtonIndices.contains(index))
        
        if configuration.destructiveButtonIndices.contains(index) {
            var color: UIColor = .systemRed
            if UIColor.responds(to: Selector(("_systemDestructiveTintColor"))) {
                if let red = UIColor.perform(Selector(("_systemDestructiveTintColor")))?.takeUnretainedValue() as? UIColor {
                    color = red
                }
            }
            cell.setTintColor(color: color)
        }
                                
        
        if #available(iOS 13.0, *) {
            if let image = option.leftIcon {
                cell.leftImage.isHidden = false
                cell.leftImage.image = image
            }
            
            if let image = option.rightIcon {
                cell.rightImage.isHidden = false
                cell.rightImage.image = image
            }
        }
        
        if index == 0 {
            cell.separator.isHidden = configuration.hideExtraSeparator
        }
        
        if index >= configuration.buttons.endIndex - 1 {
            cell.bottomSeparator.isHidden = configuration.hideExtraSeparator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.dismiss(animated: true)

        let index = indexPath.row
        if !self.callbackInvoked,
            let callback = self.configuration.callback {
            self.callbackInvoked = true
            callback([index])
        }
    }
    
}

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0)
    }

    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
