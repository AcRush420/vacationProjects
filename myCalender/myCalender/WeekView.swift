//
//  WeekView.swift
//  myCalender
//
//  Created by AustinXu on 2020/7/19.
//  Copyright © 2020 acrush. All rights reserved.
//

import UIKit
class WeekView: UIView {
    
    let myStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints=false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        setupView()
    }
    
    func setupView() {
        addSubview(myStackView)
        myStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        myStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        myStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        myStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        let weekArray = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

        for item in 0..<weekArray.count {
            let weekLabel = UILabel()
            weekLabel.text = weekArray[item]
            weekLabel.textAlignment = .center
            weekLabel.textColor = UIColor.black
            myStackView.addArrangedSubview(weekLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
