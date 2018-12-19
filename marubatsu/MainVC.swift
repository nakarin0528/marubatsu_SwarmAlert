//
//  ViewController.swift
//  marubatsu
//
//  Created by Iko Nakari on 2018/04/20.
//  Copyright © 2018年 nakarin0528. All rights reserved.
//

import UIKit
import SnapKit
import Material
import TKSwarmAlert

class MainVC: UIViewController {

    private var currentTurn = 1
    enum Turn: Int {
        case circle = 1
        case cross = 2
    }

    private let separatorView1 = SeparatorView()
    private let separatorView2 = SeparatorView()
    private let separatorView3 = SeparatorView()
    private let separatorView4 = SeparatorView()
    private let margin = 50

    var buttonArray: [[CustomButton]] = [[],[],[]]

    private lazy var reStartButton: FlatButton = {
        let btn = FlatButton()
        btn.title = "restart"
        btn.titleLabel?.font = .boldSystemFont(ofSize: 18)
        btn.titleColor = .white
        btn.layer.cornerRadius = 20
        btn.backgroundColor = UIColor(red: 255/255, green: 99/255, blue: 71/255, alpha: 1.0)
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 2
        btn.layer.shadowOpacity = 0.5
        btn.addTarget(self, action: #selector(reStart), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 85/255, green: 186/255, blue: 172/255, alpha: 1.0)

        start()
        setUpViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func start() {
        for i in 0...2 {
            for j in 0...2 {
                buttonArray[i].append(CustomButton())
                buttonArray[i][j].tag = i*3 + j
                buttonArray[i][j].addTarget(self, action: #selector(buttonDidTap(btn:)), for: .touchUpInside)
            }
        }
    }

    @objc private func reStart() {
        for i in 0...2 {
            for j in 0...2 {
                buttonArray[i][j].title = ""
                buttonArray[i][j].isEnabled = true
                buttonArray[i][j].currentState = 0
            }
        }
    }

    private func check() {
        // 横方向探査
        for i in 0...2 {
            var beforeValue = 0
            for j in 0...2 {
//                print("BeforeValue: \(beforeValue), state: \(buttonArray[i][j].currentState)")
                if beforeValue != buttonArray[i][j].currentState && j != 0 || buttonArray[i][j].currentState == 0 {
                    break
                }
                beforeValue = buttonArray[i][j].currentState
                if j == 2 {
                    print("おめでとう！")
                }
             }
        }

        // 縦方向探査
        for i in 0...2 {
            var beforeValue = 0
            for j in 0...2 {
//                print("BeforeValue: \(beforeValue), state: \(buttonArray[i][j].currentState)")
                if beforeValue != buttonArray[j][i].currentState && j != 0 || buttonArray[j][i].currentState == 0 {
                    break
                }
                beforeValue = buttonArray[j][i].currentState
                if j == 2 {
                    print("おめでとう！")
                }
            }
        }

        // 斜め方向探査
        var beforeValue = 0
        for i in 0...2 {
            if beforeValue != buttonArray[i][i].currentState && i != 0 || buttonArray[i][i].currentState == 0 {
                break
            }
            beforeValue = buttonArray[i][i].currentState
            if i == 2 {
                print("おめでとう！")
            }
        }
        beforeValue = 0
        for i in 0...2 {
            if beforeValue != buttonArray[i][2-i].currentState && i != 0 || buttonArray[i][2-i].currentState == 0 {
                break
            }
            beforeValue = buttonArray[i][2-i].currentState
            if i == 2 {
                print("おめでとう！")
            }
        }
    }

    @objc private func buttonDidTap(btn: CustomButton) {

        btn.isEnabled = false
        if currentTurn == Turn.circle.rawValue {
            btn.title = "○"
            btn.currentState = Turn.circle.rawValue
            currentTurn = Turn.cross.rawValue
        } else {
            btn.title = "×"
            btn.currentState = Turn.cross.rawValue
            currentTurn = Turn.circle.rawValue
        }
        check()
    }

    private func setUpViews() {
        let buttonSize = 100

        view.addSubview(separatorView1)
        view.addSubview(separatorView2)
        view.addSubview(separatorView3)
        view.addSubview(separatorView4)

        for i in 0...2 {
            for j in 0...2 {
                view.addSubview(buttonArray[i][j])
            }
        }

        view.addSubview(reStartButton)

        separatorView1.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-1*margin)
            $0.left.right.equalToSuperview().inset(40)
            $0.height.equalTo(10)
        }
        separatorView2.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(margin)
            $0.width.equalTo(separatorView1)
            $0.height.equalTo(10)
        }
        separatorView3.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(-1*margin)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(separatorView1.snp.width)
            $0.width.equalTo(10)
        }
        separatorView4.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(margin)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(separatorView1.snp.width)
            $0.width.equalTo(10)
        }

        buttonArray[0][0].snp.makeConstraints {
            $0.bottom.equalTo(separatorView1.snp.top)
            $0.right.equalTo(separatorView3.snp.left)
            $0.size.equalTo(buttonSize)
        }
        buttonArray[0][1].snp.makeConstraints {
            $0.bottom.equalTo(separatorView1.snp.top)
            $0.right.equalTo(separatorView4.snp.left)
            $0.size.equalTo(buttonSize)
        }
        buttonArray[0][2].snp.makeConstraints {
            $0.bottom.equalTo(separatorView1.snp.top)
            $0.left.equalTo(separatorView4.snp.right)
            $0.size.equalTo(buttonSize)
        }
        buttonArray[1][0].snp.makeConstraints {
            $0.bottom.equalTo(separatorView2.snp.top)
            $0.right.equalTo(separatorView3.snp.left)
            $0.size.equalTo(buttonSize)
        }
        buttonArray[1][1].snp.makeConstraints {
            $0.bottom.equalTo(separatorView2.snp.top)
            $0.right.equalTo(separatorView4.snp.left)
            $0.size.equalTo(buttonSize)
        }
        buttonArray[1][2].snp.makeConstraints {
            $0.bottom.equalTo(separatorView2.snp.top)
            $0.left.equalTo(separatorView4.snp.left)
            $0.size.equalTo(buttonSize)
        }
        buttonArray[2][0].snp.makeConstraints {
            $0.top.equalTo(separatorView2.snp.bottom)
            $0.right.equalTo(separatorView3.snp.left)
            $0.size.equalTo(buttonSize)
        }
        buttonArray[2][1].snp.makeConstraints {
            $0.top.equalTo(separatorView2.snp.bottom)
            $0.right.equalTo(separatorView4.snp.left)
            $0.size.equalTo(buttonSize)
        }
        buttonArray[2][2].snp.makeConstraints {
            $0.top.equalTo(separatorView2.snp.bottom)
            $0.left.equalTo(separatorView4.snp.right)
            $0.size.equalTo(buttonSize)
        }

        reStartButton.snp.makeConstraints {
            $0.bottom.equalTo(bottomMargin()).inset(30)
            $0.height.equalTo(40)
            $0.width.equalTo(140)
            $0.centerX.equalToSuperview()
        }
    }
}
