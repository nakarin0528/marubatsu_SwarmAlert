//
//  Button.swift
//  marubatsu
//
//  Created by Iko Nakari on 2018/04/20.
//  Copyright © 2018年 nakarin0528. All rights reserved.
//

import SnapKit
import Material

final class CustomButton: FlatButton {

    enum State: Int {
        case nothing = 0
        case circle = 1
        case cross = 2
    }

    var currentState = 0

    init() {
        super.init(frame: .zero)
        pulseAnimation = .none
        titleColor = .white
        titleLabel?.font = .boldSystemFont(ofSize: 18)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
