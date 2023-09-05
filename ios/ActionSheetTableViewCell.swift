//
//  ActionSheetTableViewCell.swift
//  VetsterRNActionSheet
//
//  Created by Darshan Jain on 2023-09-04.
//

import UIKit

class ActionSheetTableViewCell: UITableViewCell {
    
    static let identifier = "ActionSheetTableViewCell"
    
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        stack.spacing = 12
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        
        stack.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        stack.isLayoutMarginsRelativeArrangement = true
        
        return stack
    }()

    let title: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 18)
        title.lineBreakMode = .byTruncatingMiddle
        title.adjustsFontSizeToFitWidth = true
        title.baselineAdjustment = .alignCenters
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        title.backgroundColor = .clear
        
        return title
    }()

    let leftImage: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.widthAnchor.constraint(equalToConstant: 28).isActive = true
        
        return image
    }()
    
    let rightImage: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.widthAnchor.constraint(equalToConstant: 28).isActive = true

        return image
    }()
    
    let seperator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .opaqueSeparator
        } else {
            view.backgroundColor = .gray
        }
        
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()
    
    var bottomSeperator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .opaqueSeparator
        } else {
            view.backgroundColor = .gray
        }
        
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        
        contentView.addSubview(seperator)
        
        seperator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1).isActive = true
        seperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1).isActive = true
        seperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 1).isActive = true
     
        contentView.addSubview(bottomSeperator)
        
        bottomSeperator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
        bottomSeperator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1).isActive = true
        bottomSeperator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 1).isActive = true
        
        bottomSeperator.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        contentMode = .center
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(stack)
        
        stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        stack.addArrangedSubview(leftImage)
        stack.addArrangedSubview(title)
        stack.addArrangedSubview(rightImage)
        
        setTintColor(color: .systemBlue)
        
        let selectionView = UIView()
        
        selectionView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        
        selectedBackgroundView = selectionView
    }
    
    func setDisabled(disabled: Bool){
        if disabled {
            selectionStyle = .none
            setTintColor(color: .lightGray)
        } else {
            selectionStyle = .default
            setTintColor(color: .systemBlue)
        }
    }
    
    func setTintColor(color: UIColor) {
        title.textColor = color
        leftImage.tintColor = color
        rightImage.tintColor = color
    }
}
