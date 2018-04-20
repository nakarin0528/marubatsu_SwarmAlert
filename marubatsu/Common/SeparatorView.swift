//
//  SeparatorView.swift
//  marubatsu
//
//  Created by Iko Nakari on 2018/04/20.
//  Copyright © 2018年 nakarin0528. All rights reserved.
//

import UIKit

final class SeparatorView: UIView {
    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 71/255, green: 158/255, blue: 146/255, alpha: 1.0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
