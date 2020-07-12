//
//  ViewController.swift
//  CalculatorV3.0
//
//  Created by AustinXu on 2020/7/11.
//  Copyright © 2020 acrush. All rights reserved.
//



//3.0 big change

import UIKit

class ViewController: UIViewController {
    
    let numbers = [
        ["AC", "(", ")", "←"],
        ["s", "c", "t", "!"],
        ["e", "^", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="],
    ]
    
    var operation = [String]()//存放从字符串转换成的表达式
    var numStack = [String]()//1.中缀转后缀时，存放数字。 2.存放后缀表达式
    var operaStack = [String]()//中缀转后缀时，存放操作符。
    var stack = [String]()//辅助计算后缀表达式
    
    var userIsTyping = false
    
    enum error :Error
    {
        case expressionError
    }

    enum Operation
    {
        case unaryoperation((Double) -> Double)
        case binaryoperation((Double, Double) -> Double)
    }
    
    var operations: Dictionary<String, Operation> =
        [
            "+" : .binaryoperation({$0 + $1}),
            "-" : .binaryoperation({$0 - $1}),
            "×" : .binaryoperation({$0 * $1}),
            "÷" : .binaryoperation({$0 / $1}),
            "^" : .binaryoperation({pow($0, $1)}),
            "%" : .binaryoperation({fmod($0, $1)}),
            "e" : .binaryoperation({$0 * pow(10, $1)}),
            "s" : .unaryoperation({sin($0 / 180 * Double.pi)}),
            "c" : .unaryoperation({cos($0 / 180 * Double.pi)}),
            "t" : .unaryoperation({tan($0 / 180 * Double.pi)}),
            "!" : .unaryoperation(
                {
                    var param = 1
                    for i in 1...Int($0)
                    {
                        param *= i
                        
                    }
                    return Double(param)
                }
            )]
    let cellId = "cellId"
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    @IBOutlet weak var calculatorHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {
        calculatorCollectionView.delegate = self
        calculatorCollectionView.dataSource = self
        calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: cellId)
        calculatorHeightConstraint.constant = view.frame.width * 1.6
        calculatorCollectionView.backgroundColor = .clear
        calculatorCollectionView.contentInset = .init(top: 0, left: 14, bottom: 0, right: 14)
        
        numberLabel.text = "0"
        
        view.backgroundColor = .black
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        width = ((collectionView.frame.width - 10) - 14 * 5) / 4
        let height = width
        if indexPath.section == 6 && indexPath.row == 0 {
            width = width * 2 + 14 + 9
        }
        return .init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CalculatorViewCell
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        let operation: String = "AC()scte^%"
        numbers[indexPath.section][indexPath.row].forEach { (numberString) in
            if numberString.isNumber || numberString.description == "." {
                cell.numberLabel.backgroundColor = .darkGray
            } else if operation.range(of: String(numberString)) != nil {
                cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let number = numbers[indexPath.section][indexPath.row]
        
        if (userIsTyping && number != "AC" && number != "←") || number == "." {
            numberLabel.text! += number
            if number == "." {
                userIsTyping = true
            }
        }
        else if number != "AC" && number != "←" && number != "0" && number != "="  {
            numberLabel.text = number
            userIsTyping = true
        }
        if number == "=" {
            if numberLabel.text == "=" {
                numberLabel.text = "0"
            }
            else {
                do {
                    try numberLabel.text = calculate(text: numberLabel.text!)
                } catch error.expressionError {
                    numberLabel.text = "Error In Input."
                }catch { }
                userIsTyping = false
                operation = [String]()
                numStack = [String]()
                operaStack = [String]()
                stack = [String]()
            }
        }
        if number == "AC" {
            userIsTyping = false
            numberLabel.text = "0"
            operation = [String]()
            numStack = [String]()
            operaStack = [String]()
            stack = [String]()
        }
        if number == "←" {
            numberLabel.text?.removeLast()
            if numberLabel.text == "" || numberLabel.text == "0" {
                numberLabel.text = "0"
                userIsTyping = false
            }
        }
    }
    
    func calculate (text: String) throws -> String
    {
        //将label的text转换为表达式（把多位数看成一个数字）
        let textArray = Array (text)
        var number = ""
        for char in textArray
        {
            let charStr = String (char)
            if "0"..."9" ~= char || char == "."
            {
                number.append(char)
            }
            else
            {
                operation.append(number)
                number = ""
                operation.append(charStr)
            }
        }

        //设置运算符的优先级
        let priority =
            [
                nil : 0,
                "(" : 0,
                "+" : 1,
                "-" : 1,
                "×" : 2,
                "÷" : 2,
                "%" : 2,
                "e" : 3,
                "^" : 3,
                "s" : 4,
                "c" : 4,
                "t" : 4,
                "!" : 4
        ]
        
        for opera in operation //中缀转后缀
        {
            if Double(opera) != nil
            {
                numStack.append(opera)
            }
            else
            {
                switch opera
                {
                case "(" :
                    operaStack.append(opera)
                case ")" :
                    while operaStack.last != "("
                    {
                        if let _ = operaStack.last
                        {
                            numStack.append(operaStack.popLast()!)
                        }
                        else
                        {
                            throw error.expressionError
                        }
                    }
                    operaStack.removeLast()
                case "+", "-" :
                    while priority[operaStack.last]! >= 1
                    {
                        numStack.append(operaStack.popLast()!)
                    }
                    operaStack.append(opera)
                case "×", "÷", "%" :
                    while priority[operaStack.last]! >= 2
                    {
                        numStack.append(operaStack.popLast()!)
                    }
                    operaStack.append(opera)
                case "e", "^" :
                    while priority[operaStack.last]! >= 3
                    {
                        numStack.append(operaStack.popLast()!)
                    }
                    operaStack.append(opera)
                case "s", "c", "t", "!" :
                    while priority[operaStack.last]! >= 4
                    {
                        numStack.append(operaStack.popLast()!)
                    }
                    operaStack.append(opera)
                default:
                    break
                }
            }
        }
        
        while operaStack.last != nil
        {
            numStack.append(operaStack.popLast()!)
        }
        
        //计算后缀表达式
        for item in numStack
        {
            if Double(item) != nil
            {
                stack.append(item)
            }
            else
            {
                var result = ""
                if operations[item] != nil
                {
                    switch operations[item]!
                    {
                    case .unaryoperation(let operate) :
                        if stack.last != nil
                        {
                            let number = Double(stack.popLast()!)!
                            result = String(operate(number))
                        }
                        else
                        {
                            throw error.expressionError
                        }
                    case .binaryoperation(let operate):
                        if stack.last != nil
                        {
                            let number1 = Double(stack.popLast()!)!
                            if stack.last != nil
                            {
                                let number2 = Double(stack.popLast()!)!
                                result = String(operate(number2, number1))
                            }
                            else
                            {
                                throw error.expressionError
                            }
                        }
                        else
                        {
                            throw error.expressionError
                        }
                    }
                }
                else
                {
                    throw error.expressionError
                }
                stack.append(result)
            }
        }
        //判断是否为整数，若为整数则去掉小数点。
        let output = Double (stack.last!)!
        if floor(output) == output
        {
            return String(Int(output))
        }
        return stack.last!
    }
    
}





