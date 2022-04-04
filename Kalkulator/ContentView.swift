//
//  ContentView.swift
//  first app
//
//  Created by Elias Pettersen Chairi on 29/03/2022.
//

import SwiftUI

//let width = UIScreen.main.bounds.width
var calculations: [String] = []

let buttonHeight = 80.0
let buttonWidth = 80.0
let corner = 30.0


struct ContentView: View {
    @State var calcScreenText = ""
    @State var calcInstructionScreenText = ""
    
    var numberButtonBackground: some View {
        Color.primary.opacity(0.4)
            .frame(width: buttonWidth, height: buttonHeight)
            .cornerRadius(corner)
    }
    var OperationButtonBackground: some View {
        Color.orange
            .frame(width: buttonWidth, height: buttonHeight)
            .cornerRadius(corner)
    }
    var clearNegativPercentBackground: some View {
        Color.primary.opacity(0.6)
            .frame(width: buttonWidth, height: buttonHeight)
            .cornerRadius(corner)
    }
    
    func NumberButton(Number: String) -> some View {
        let button = Button(Number) {
            if (calculations.count == 3){
                calcScreenText = ""
                calcInstructionScreenText = ""
                calculations = []
            }
            if (isOperator(text: calcScreenText)) {
                calcScreenText = ""
                calcInstructionScreenText += " "
            }
            calcScreenText += Number
            calcInstructionScreenText += Number
        }
        .buttonStyle(ButtonStyling())
        return button
    }
    
    func OperationButton(Operator: String) -> some View {
        let button = Button(Operator) {
            if (calcScreenText == "" || calcScreenText == "(-)") {
                return
            }
            if (isOperator(text: calcScreenText)) {
                if (calcScreenText != Operator) {
                    calculations[calculations.count - 1] = Operator
                    calcScreenText = Operator
                    var tempArray = Array(calcInstructionScreenText)
                    tempArray[tempArray.count - 1] = Character(Operator)
                    calcInstructionScreenText = String(tempArray)
                }
                return
            }
            if (calculations.count == 3) { // trykket =
                calculations = []
                calcInstructionScreenText = calcScreenText
            }
            
            let tempArray = Array(calcScreenText)
            if (tempArray[0] == "(" && tempArray[1] == "-" && tempArray[2] == ")") {
                calculations.append("-" + calcScreenText.components(separatedBy: "(-)")[1])
            } else {
                calculations.append(calcScreenText)
            }
            
            if (calculations.count == 3) { // trykket operator etter tall uten =
                let answare = String(calculate(calculationList: calculations))
                calcScreenText = answare
                calcInstructionScreenText = answare
                calculations = [answare]
            }
            calculations.append(Operator) //operator
            calcScreenText = Operator
            calcInstructionScreenText += (" " + Operator)
        }
        .buttonStyle(ButtonStyling())
        return button
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 100.0)
            Text(calcScreenText)
                .frame(height: 10.0)
                .dynamicTypeSize(.xxxLarge)
            Spacer()
                .frame(height: 30.0)
            Text(calcInstructionScreenText)
                .frame(height: 10.0)
                .dynamicTypeSize(.large)
                .opacity(0.5)
            Spacer()
                .frame(height: 100.0)
        
            ZStack() {
                HStack() {
                    VStack() {
                        clearNegativPercentBackground
                        numberButtonBackground
                        numberButtonBackground
                        numberButtonBackground
                        numberButtonBackground
                    }
                    VStack() {
                        clearNegativPercentBackground
                        numberButtonBackground
                        numberButtonBackground
                        numberButtonBackground
                        numberButtonBackground
                    }
                    VStack() {
                        clearNegativPercentBackground
                        numberButtonBackground
                        numberButtonBackground
                        numberButtonBackground
                        numberButtonBackground
                    }
                    VStack() {
                        OperationButtonBackground
                        OperationButtonBackground
                        OperationButtonBackground
                        OperationButtonBackground
                        OperationButtonBackground
                    }
                }
                HStack() {
                    VStack() {
                        Button("C") {
                            calcScreenText = ""
                            calcInstructionScreenText = ""
                            calculations = []
                        }
                        .buttonStyle(ButtonStyling())
                        NumberButton(Number: "7")
                        NumberButton(Number: "4")
                        NumberButton(Number: "1")
                        NumberButton(Number: "0")
                    }
                    
                    VStack() {
                        Button("+/-") {
                            if (isOperator(text: calcScreenText)) {
                                calcScreenText = ""
                                calcInstructionScreenText += " "
                            }
                            
                            if (calcScreenText == "") {
                                calcScreenText = "(-)"
                                calcInstructionScreenText += "(-)"
                                return
                            }
                            
                            let readScreenList = Array(calcScreenText)
                            if (readScreenList[0] == "(" && readScreenList[1] == "-" && readScreenList[2] == ")") {
                                calcScreenText = calcScreenText.components(separatedBy: "(-)")[1]
                                
                                var tempList = calcInstructionScreenText.components(separatedBy: " ")
                                tempList[tempList.count - 1] = calcScreenText
                                calcInstructionScreenText = tempList.joined(separator: " ")
                            }
                            else if (readScreenList[0] == "-") {
                                calcScreenText = calcScreenText.components(separatedBy: "-")[1]
                                
                                var tempList = calcInstructionScreenText.components(separatedBy: " ")
                                tempList[tempList.count - 1] = calcScreenText
                                calcInstructionScreenText = tempList.joined(separator: " ")
                                
                            }
                            else {
                                calcScreenText = "(-)" + calcScreenText
                                var tempList = calcInstructionScreenText.components(separatedBy: " ")
                                tempList[tempList.count - 1] = calcScreenText
                                calcInstructionScreenText = tempList.joined(separator: " ")
                            }
                        }
                        .buttonStyle(ButtonStyling())
                        NumberButton(Number: "8")
                        NumberButton(Number: "5")
                        NumberButton(Number: "2")
                        NumberButton(Number: "0")
                    }
                    
                    VStack() {
                        Button("%") {
                            if (isOperator(text: calcScreenText) || calcScreenText == "" || calcScreenText == "(-)") {
                                return
                            }
                            
                            var answare = ""
                            var currentNum = calcScreenText
                            if (calcScreenText.contains("(-)")) {
                                currentNum = calcScreenText.components(separatedBy: "(-)")[1]
                            }
                            
                            if (calculations.count > 1 && (calculations[1] == "+" || calculations[1] == "-")) {
                                answare = String(Float(currentNum)! / 100.0 * Float(calculations[0])!)
                            } else {
                                answare = String(Float(currentNum)! / 100.0)
                            }
                            
                            if (calcScreenText.contains("(-)")) {
                                answare = ("(-)" + answare)
                            }
                            
                            var currentCalcList = calcInstructionScreenText.components(separatedBy: calcScreenText)
                            currentCalcList[1] = answare
                            calcInstructionScreenText = currentCalcList.joined()
                            calcScreenText = answare
                        }
                        .buttonStyle(ButtonStyling())
                        NumberButton(Number: "9")
                        NumberButton(Number: "6")
                        NumberButton(Number: "3")
                        Button(",") {
                            if (calcScreenText != "" && !isOperator(text: calcScreenText) && !containsComma(text: calcScreenText)) {
                                calcScreenText += "."
                                calcInstructionScreenText += ","
                            }
                        }
                        .buttonStyle(ButtonStyling())
                    }
                    
                    VStack() {
                        OperationButton(Operator: "÷")
                        OperationButton(Operator: "x")
                        OperationButton(Operator: "-")
                        OperationButton(Operator: "+")
                        Button("=") {
                            if (calculations.count < 2 || isOperator(text: calcScreenText) || calcScreenText == "(-)") {
                                return
                            }
                            if (calculations.count == 3) {
                                print("jo..")
                                print(calculations)
                                calculations = [calcScreenText, calculations[1], calculations[2]]
                                print(calculations)
                            } else {
                                if (calcScreenText.contains("(-)")) {
                                    calculations.append("-" + calcScreenText.components(separatedBy: "(-)")[1])
                                } else {
                                    calculations.append(calcScreenText)
                                }
                            }
                            print(calculations)
                            calcScreenText = String(calculate(calculationList: calculations))
                            
                            calcInstructionScreenText = calculations.joined(separator:" ")
                            calcInstructionScreenText += " = "
                            calcInstructionScreenText += String(calculate(calculationList: calculations))
                            print(calcInstructionScreenText)
                        }
                        .buttonStyle(ButtonStyling())
                    }
                }
            }
        }
    }
}

func isOperator(text: String) -> Bool {
    if (text == "÷" || text == "x" || text == "-" || text == "+") {
        return true
    }
    else {
        return false
    }
}

func containsComma(text: String) -> Bool {
    let charArray = Array(text)
    for i in (0 ..< charArray.count) {
        if (charArray[i] == ".") {
            return true
        }
    }
    return false
}

func calculate(calculationList: [String]) -> Float {
    let num1 = Float(calculationList[0])
    let operator1 = calculationList[1]
    let num2 = Float(calculationList[2])

    switch operator1 {
    case "÷":
        return num1! / num2!
    case "x":
        return num1! * num2!
    case "-":
        return num1! - num2!
    case "+":
        return num1! + num2!
    default:
        print("something went wrong :(")
        return(404)
    }
}


struct ButtonStyling: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: buttonWidth, height: buttonHeight)
            .contentShape(Rectangle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone X")
    }
}
