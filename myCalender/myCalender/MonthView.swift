//
//  MonthView.swift
//  myCalender
//
//  Created by AustinXu on 2020/7/19.
//  Copyright © 2020 acrush. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(month: Int, year: Int)
}

class MonthView: UIView {
    
    let monthArray = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex = 0
    var currentYear = 0
    var delegate: MonthViewDelegate?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "month year"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let leftButton: UIButton = {
        let button = UIButton()
        button.setTitle("<", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(changeMonth(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    let rightButton: UIButton = {
        let button = UIButton()
        button.setTitle(">", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(changeMonth(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        setupView()
        
    }
    
    func setupView() {
        
        self.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        titleLabel.text = "\(monthArray[currentMonthIndex]) \(currentYear)"

        self.addSubview(leftButton)
        leftButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        leftButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
       
        self.addSubview(rightButton)
        rightButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        rightButton.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
                
        
    }
    
    @objc func changeMonth(sender: UIButton) {
        if sender == rightButton {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        }else{
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        titleLabel.text = "\(monthArray[currentMonthIndex]) \(currentYear)"
        delegate?.didChangeMonth(month: currentMonthIndex + 1, year: currentYear)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
