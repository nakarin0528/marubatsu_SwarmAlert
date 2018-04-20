////
////  Presenter.swift
////  marubatsu
////
////  Created by Iko Nakari on 2018/04/20.
////  Copyright © 2018年 nakarin0528. All rights reserved.
////
//
//import Foundation
//
//final class Presenter {
//    enum Turn: Int {
//        case circle = 1
//        case cross = 2
//    }
//
//    private let model = Model()
//    private var currentTurn = 1
//
//    init() {
//        for _ in 0...9 {
//            model.buttonArray.append(CustomButton())
//        }
//    }
//
//    var buttonArray: [CustomButton] {
//        return model.buttonArray
//    }
//
//    func togleButton(index: Int) {
//        let button = model.buttonArray[index]
//        button.isEnabled = false
//        if currentTurn == Turn.circle.rawValue {
//            button.setTitle("○", for: .normal)
//            button.tag = Turn.circle.rawValue
//            currentTurn = Turn.cross.rawValue
//        } else {
//            button.setTitle("×", for: .normal)
//            button.tag = Turn.cross.rawValue
//            currentTurn = Turn.circle.rawValue
//        }
//    }
//}
