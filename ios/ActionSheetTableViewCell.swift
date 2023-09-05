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
        title.font = .systemFont(ofSize: 19)
        title.lineBreakMode = .byTruncatingMiddle
        title.baselineAdjustment = .alignCenters
        
        title.backgroundColor = .clear
        
        return title
    }()

    let leftImage: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        return image
    }()
    
    let rightImage: UIImageView = {
        let image = UIImageView()
        
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        
        image.heightAnchor.constraint(equalToConstant: 20).isActive = true
        image.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        return image
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .opaqueSeparator
        } else {
            view.backgroundColor = .gray
        }
        
        view.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        
        return view
    }()
    
    var bottomSeparator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .opaqueSeparator
        } else {
            view.backgroundColor = .gray
        }
        
        view.heightAnchor.constraint(equalToConstant: 0.7).isActive = true
        
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        
        contentView.addSubview(separator)
        
        separator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
     
        contentView.addSubview(bottomSeparator)
        
        bottomSeparator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        bottomSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0).isActive = true
        bottomSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0).isActive = true
        
        bottomSeparator.isHidden = true
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
        stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
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
