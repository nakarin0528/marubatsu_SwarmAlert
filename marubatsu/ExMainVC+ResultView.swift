//
//  ResultView.swift
//  marubatsu
//
//  Created by yiheng on 2018/12/21.
//  Copyright © 2018 nakarin0528. All rights reserved.
//

import UIKit
import SnapKit

extension MainVC {

    func makeResultView(isWin: Bool) -> [UIView] {

        let resultView = UIView()
        resultView.backgroundColor = .white
        resultView.backgroundColor = .white
        resultView.layer.cornerRadius = 10

        let statusLabel = UILabel()
        statusLabel.font = .boldSystemFont(ofSize: 40)
        statusLabel.sizeToFit()

        let animojiLabel = UILabel()
        animojiLabel.fontSize = 40
        animojiLabel.sizeToFit()

        if isWin {
            statusLabel.text = "You WIN"
            animojiLabel.text = "🎉🥳🎉"
        } else {
            statusLabel.text = "You Lose"
            animojiLabel.text = "😈😱😈"
        }

        let height:CGFloat = 220
        let width:CGFloat = 200
        let x:CGFloat = self.view.frame.width / 2 - width/2
        let y:CGFloat = self.view.frame.height / 2.5
        let f1 = CGRect(x: x, y: y, width: width, height: height)

        resultView.frame = f1


        resultView.addSubview(statusLabel)
        statusLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-20)
        }
        resultView.addSubview(animojiLabel)
        animojiLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(20)
        }

        return [resultView]
    }
}
