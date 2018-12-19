import UIKit
import SnapKit

extension UIViewController {
    
    // iOS11以降ならSafeAreaの上限、iOS10以下ならステータスバーの直下
    func topMargin() -> ConstraintItem {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.snp.topMargin
        } else {
            return self.topLayoutGuide.snp.bottom //ステータスバーの下
        }
    }
    // iOS11以降ならSafeAreaの下限、iOS10以下なら下限
    func bottomMargin() -> ConstraintItem {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide.snp.bottomMargin
        } else {
            return self.view.snp.bottomMargin
        }
    }
}
