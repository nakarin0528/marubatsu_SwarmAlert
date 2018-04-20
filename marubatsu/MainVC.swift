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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 85/255, green: 186/255, blue: 172/255, alpha: 1.0)

        reStart()
        setUpViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func reStart() {
        for i in 0...2 {
            for j in 0...2 {
                buttonArray[i].append(CustomButton())
                buttonArray[i][j].tag = i*3 + j
                buttonArray[i][j].addTarget(self, action: #selector(buttonDidTap(btn:)), for: .touchUpInside)
            }
        }
    }

    @objc private func buttonDidTap(btn: CustomButton) {

        btn.isEnabled = false
        if currentTurn == Turn.circle.rawValue {
            btn.setTitle("○", for: .normal)
            btn.currentState = Turn.circle.rawValue
            currentTurn = Turn.cross.rawValue
        } else {
            btn.setTitle("×", for: .normal)
            btn.currentState = Turn.cross.rawValue
            currentTurn = Turn.circle.rawValue
        }
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
    }
}
