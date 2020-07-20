//
//  CalenderView.swift
//  myCalender
//
//  Created by AustinXu on 2020/7/19.
//  Copyright © 2020 acrush. All rights reserved.
//

import UIKit

class CalenderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MonthViewDelegate {

    var numOfDaysPerMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    var currentMonth = 0 //日历当前显示月份
    var currentYear = 0  //日历当前显示年份
    var todaysDate = 0   //现实生活当前日数
    var presentMonth = 0 //现实生活当前月份
    var presentYear = 0  //现实生活当前年份
    var firstWeekDayOfMonth = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    func initView() {
        currentMonth = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        firstWeekDayOfMonth = getFirstWeekDay()
        
        //如果闰年
        if (currentYear % 4 == 0 && currentYear % 100 != 0) || currentYear % 400 == 0 {
            numOfDaysPerMonth[1] = 29
        }
        
        presentYear = currentYear
        presentMonth = currentMonth
        
        setupView()
        
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numOfDaysPerMonth[currentMonth - 1] + firstWeekDayOfMonth - 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.clear
        if indexPath.item < firstWeekDayOfMonth - 1 {
            cell.isHidden = true
        }else {
            cell.isHidden = false
            let date = indexPath.row - firstWeekDayOfMonth + 2  //
            cell.dayLabel.text = "\(date)"
            if (date < todaysDate && currentYear == presentYear && currentMonth == presentMonth) || (currentYear == presentYear && currentMonth < presentMonth) || currentYear < presentYear {
                cell.dayLabel.textColor = UIColor.lightGray
            }else {
                cell.dayLabel.textColor = UIColor.black
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let date = indexPath.row - firstWeekDayOfMonth + 2
                if cell?.backgroundColor == UIColor.blue {
            cell?.backgroundColor=UIColor.clear
            let label = cell?.subviews[1] as! UILabel
            if (date < todaysDate && currentYear == presentYear && currentMonth == presentMonth) || (currentYear == presentYear && currentMonth < presentMonth) || currentYear < presentYear {
                label.textColor = UIColor.lightGray
            }else {
                label.textColor = UIColor.black
            }
        }else {
            cell?.backgroundColor = UIColor.blue
            let label = cell?.subviews[1] as! UILabel
            label.textColor = UIColor.white
        }
        animateView(cell!)
    }
    func animateView(_ viewToAnimate: UIView) {
        UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            viewToAnimate.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { (_) in
            UIView.animate(withDuration: 0.15, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
                
        }
    }
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell=collectionView.cellForItem(at: indexPath)
//        cell?.backgroundColor=UIColor.clear
//        let label = cell?.subviews[1] as! UILabel
//        label.textColor = UIColor.black
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 7 - 8
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8.0
    }
    
    func getFirstWeekDay() -> Int{
        let day = ("\(currentYear)-\(currentMonth)-01".date?.firstDayOfTheMonth.weekday)!
        return day
    }
        
    func didChangeMonth(month: Int, year: Int) {
        currentMonth = month
        currentYear = year
        
        if month == 2 {
            if (currentYear % 4 == 0 && currentYear % 100 != 0) || currentYear % 400 == 0 {
                numOfDaysPerMonth[month - 1] = 29
            } else {
                numOfDaysPerMonth[month - 1] = 28
            }
        }
        
        firstWeekDayOfMonth=getFirstWeekDay()
        
        myCollectionView.reloadData()
    }
    
    func setupView() {
        addSubview(monthView)
        monthView.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthView.heightAnchor.constraint(equalToConstant: 35).isActive=true
        monthView.delegate=self
        
        addSubview(weekView)
        weekView.topAnchor.constraint(equalTo: monthView.bottomAnchor).isActive=true
        weekView.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        weekView.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        weekView.heightAnchor.constraint(equalToConstant: 30).isActive=true
        
        addSubview(myCollectionView)
        myCollectionView.topAnchor.constraint(equalTo: weekView.bottomAnchor, constant: 0).isActive=true
        myCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive=true
        myCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive=true
        myCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    let monthView: MonthView = {
        let view = MonthView()
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    
    let weekView: WeekView = {
        let view = WeekView()
        view.translatesAutoresizingMaskIntoConstraints=false
        return view
    }()
    
    let myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let myCollectionView=UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        myCollectionView.showsHorizontalScrollIndicator = false
        myCollectionView.translatesAutoresizingMaskIntoConstraints=false
        myCollectionView.backgroundColor=UIColor.clear
        myCollectionView.allowsMultipleSelection=false
        return myCollectionView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CollectionViewCell:UICollectionViewCell {
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor=UIColor.darkGray
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
        
        setupViews()
    }
    
    func setupViews() {
        
        addSubview(dayLabel)
        dayLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dayLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        dayLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
