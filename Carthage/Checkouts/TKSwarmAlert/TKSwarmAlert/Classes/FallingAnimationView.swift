//
//  FallingAnimationView.swift
//  dinamicTest
//
//  Created by Takuya Okamoto on 2015/08/14.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

//http://stackoverflow.com/questions/21325057/implement-uikitdynamics-for-dragging-view-off-screen



/*

TODO:
* ✔ 落ちながら登場する感じ
* ✔ Viewを渡したら落ちてくるような感じにしたいな
* ✔ UIViewのクラスにする？
* ✔ 連続登場
* ✔ 落としたあとに戻ってくる

SHOULD FIX:
* なんか登場時ギザギザしてる

WANNA FIX:
* ドラッグ時に震えるの何とかしたい
* 凄く早く連続で落とすと残る

WANNA DO:
* ジャイロパララックス
* タップすると震える

*/


import UIKit


/* Usage

*/

class FallingAnimationView: UIView {
    
    var willDissmissAllViews: Closure?
    var didDissmissAllViews: Closure?

    
    let gravityMagnitude:CGFloat = 3
    let snapBackDistance:CGFloat = 30
    let fieldMargin:CGFloat = 300

    var animator: UIDynamicAnimator
    var animationView: UIView
    var attachmentBehavior: UIAttachmentBehavior?
    var startPoints: [CGPoint] = []
    var currentAnimationViewTags: [Int] = []
    var nextViewsList: [[UIView]] = []
    
    var enableToTapSuperView: Bool = true
    
    var allViews: [UIView] {
        get {
            return animationView.subviews.filter({ (view: AnyObject) -> Bool in
                return view is UIView
            }) 
        }
    }
    var animatedViews:[UIView] {
        get {
            return allViews.filter({ (view:UIView) -> Bool in view.tag >= 0 })
        }
    }
    var staticViews:[UIView] {
        get {
            return allViews.filter({ (view:UIView) -> Bool in view.tag < 0 })
        }
    }

    var currentAnimationViews: [UIView] {
        get {
            return animatedViews.filter(isCurrentView)
        }
    }
    var unCurrentAnimationViews: [UIView] {
        get {
            return animatedViews.filter(isUnCurrentView)
        }
    }
    
    func isCurrentView(view:UIView) -> Bool {
        for currentTag in self.currentAnimationViewTags {
            if currentTag == view.tag {
                return true
            }
        }
        return false
    }
    func isUnCurrentView(view:UIView) -> Bool {
        for currentTag in self.currentAnimationViewTags {
            if currentTag == view.tag {
                return false
            }
        }
        return true
    }

    
    func fadeOutStaticViews(duration:TimeInterval) {
        for v in self.staticViews {
            UIView.animate(withDuration: duration) {
                v.alpha = 0
            }
        }
    }
    
    override init(frame:CGRect) {
        self.animationView = UIView()
        self.animator = UIDynamicAnimator(referenceView: animationView)
        super.init(frame:frame)
        animationView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width + fieldMargin*2, height: self.frame.size.height + fieldMargin*2)
        animationView.center = self.center
        self.addSubview(animationView)
     
        enableTapGesture()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    func spawn(views:[UIView]) {
        //refresh
        currentAnimationViewTags = []
        animator.removeAllBehaviors()
        fallAndRemove(views: animatedViews)
        //fixMargin
        for v in views {
            v.frame.x = v.frame.x + fieldMargin
            v.frame.y = v.frame.y + fieldMargin
        }
        // make it draggable
        for v in views {
            // dev_makeLine(v: v)
            v.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(FallingAnimationView.didDrag)))
            v.tag = startPoints.count
            startPoints.append(v.center)
            currentAnimationViewTags.append(v.tag)
        }
        // lift up
        let upDist:CGFloat = calcHideUpDistance(views: views)
        for v in views {
            v.frame.y = v.frame.y - upDist
            animationView.addSubview(v)
        }
        //drop
        collisionAll()
        snap(views: views)
    }
    
    func spawnNextViews() {
        let views = nextViewsList.remove(at: 0)
        spawn(views: views)
    }
    

    @objc func didDrag(gesture: UIPanGestureRecognizer) {
        let gestureView = gesture.view!
        if gesture.state == UIGestureRecognizer.State.began {
            self.animator.removeAllBehaviors()
            collisionAll()
            snapAll()
            fallAndRemove(views: unCurrentAnimationViews)
            // drag start
            let gripPoint: CGPoint = gesture.location(in: gestureView)
            let offsetFromCenter: UIOffset = UIOffset.init(
                horizontal: gripPoint.x - gestureView.bounds.size.width  / 2.0,
                vertical: gripPoint.y - gestureView.bounds.size.height / 2.0
            )
            let anchorPoint: CGPoint = gesture.location(in: gestureView.superview)
            attachmentBehavior = UIAttachmentBehavior(item: gestureView, offsetFromCenter: offsetFromCenter, attachedToAnchor: anchorPoint)
            self.animator.addBehavior(attachmentBehavior!)
        }
        else if gesture.state == UIGestureRecognizer.State.changed {
            // drag move
            let touchPoint: CGPoint = gesture.location(in: gestureView.superview)
            attachmentBehavior?.anchorPoint = touchPoint
        }
        else if gesture.state == UIGestureRecognizer.State.ended {
            disableTapGesture()
            self.animator.removeAllBehaviors()
            collisionAll()
            // judge if fall
            let touchPoint: CGPoint = gesture.location(in: gestureView.superview)
            let movedDistance = distance(from: startPoints[gestureView.tag], to: touchPoint)
            if movedDistance < snapBackDistance {// not fall
                let snap = UISnapBehavior(item: gestureView, snapTo: startPoints[gestureView.tag])
                self.animator.addBehavior(snap)
            }
            else {
                if nextViewsList.count != 0 {//next
                    spawnNextViews()
                }
                else {// fall
                    // velocity
                    let pushBehavior = UIPushBehavior(items: [gestureView], mode: UIPushBehavior.Mode.instantaneous)
                    let velocity: CGPoint = gesture.velocity(in: gestureView.superview)
                    // not sure if I can really just convert it to CGVector though
                    pushBehavior.pushDirection = CGVector(dx: (velocity.x / 900), dy: (velocity.y / 900))
                    self.animator.addBehavior(pushBehavior)
                    
                    disableDragGesture()
                    fallAndRemoveAll()
                }
            }
        }
    }
    
    @objc func onTapSuperView() {
        if (enableToTapSuperView) {
            animator.removeAllBehaviors()
            disableTapGesture()
            if nextViewsList.count != 0 {//next
                spawnNextViews()
            }
            else {
                disableDragGesture()
                fallAndRemoveAll()
            }
        }
    }
    
    func fallAndRemoveAll() {
        fallAndRemove(views: animatedViews)
        if nextViewsList.count == 0 {
            //ここでフェードアウト
            disableTapGesture()
            self.willDissmissAllViews?()
        }
    }

    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    // MARK: behaviors
    func collisionAll() {
        let collisionBehavior = UICollisionBehavior(items: animatedViews)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true//❓
        self.animator.addBehavior(collisionBehavior)
    }
    
    func snapAll() {
        snap(views: currentAnimationViews)
    }
    func snap(views:[UIView]) {
        for v in views {
            let snap = UISnapBehavior(item: v, snapTo: startPoints[v.tag])
            self.animator.addBehavior(snap)
        }
    }
    
    func fallAndRemove(views:[UIView]) {
        let gravity = UIGravityBehavior(items: views)
        gravity.magnitude = gravityMagnitude
        gravity.action = { [weak self] in
            if self != nil {
                if self!.animatedViews.count == 0 {
                    self!.animator.removeAllBehaviors()
                    self!.didDissmissAllViews?()
                }
                else {
                    for v in views {
                        if v.superview != nil {
                            if v.frame.top >= (v.superview!.bounds.bottom - self!.fieldMargin) {
                                v.removeFromSuperview()
                            }
                            else if v.frame.right <= (v.superview!.bounds.left + self!.fieldMargin) {
                                v.removeFromSuperview()
                            }
                            else if v.frame.left >= (v.superview!.bounds.right - self!.fieldMargin) {
                                v.removeFromSuperview()
                            }
                        }
                    }
                }
            }
        }
        self.animator.addBehavior(gravity)
    }
    

    
    // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    // MARK: Util
    func disableDragGesture() {
        // remove event
        for v in allViews {
            if let recognizers = v.gestureRecognizers {
                for recognizer in recognizers {
                    v.removeGestureRecognizer(recognizer)
                }
            }
        }
    }
    
    func enableTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FallingAnimationView.onTapSuperView))
        self.addGestureRecognizer(tapGesture)
    }
    
    func disableTapGesture() {
        if let recognizers = self.gestureRecognizers {
            for recognizer in recognizers {
                self.removeGestureRecognizer(recognizer)
            }
        }

        Timer.schedule(delay: 0.5) { [weak self] (timer) in
            self?.enableTapGesture()
        }
    }

    func dev_makeLine(v: UIView) {
        let lineView = UIView(frame: v.frame)
        lineView.backgroundColor = UIColor.clear
        lineView.layer.borderColor = UIColor.blue.withAlphaComponent(0.2).cgColor
        lineView.layer.borderWidth = 1
        lineView.tag = -1
        animationView.addSubview(lineView)
    }
    
    func calcHideUpDistance(views:[UIView])->CGFloat {
        var minimumTop:CGFloat = CGFloat(HUGE)
        for view in views {
            if view.frame.y < minimumTop {
                minimumTop = view.frame.y
            }
        }
        return minimumTop
    }
    
    func distance(from:CGPoint, to:CGPoint) -> CGFloat {
        let xDist = (to.x - from.x)
        let yDist = (to.y - from.y)
        return sqrt((xDist * xDist) + (yDist * yDist))
    }
}
