//
//  CollectionViewCell.swift
//  Design3
//
//  Created by LeeX on 4/16/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImg: UIImageView!

    var parentVC: ViewController!
    
    //var cellDelegate: CollectionViewCellDelegate?
    
    var newCoord:CGPoint = CGPoint(x: 0, y: 0)
    
    var cellFrame:[CGRect] = [CGRect(x: 0, y: 40.0, width: 117.0, height: 117.0),
                              CGRect(x: 129.0, y: 40.0, width: 117.0, height: 117.0),
                              CGRect(x: 258.0, y: 40.0, width: 117.0, height: 117.0),
                              CGRect(x: 0, y: 167.0, width: 117.0, height: 117.0),
                              CGRect(x: 129.0, y: 167.0, width: 117.0, height: 117.0),
                              CGRect(x: 258.0, y: 167.0, width: 117.0, height: 117.0),]
    
    var selectedIndexPathRow = 0
    var selectedIndexPath: IndexPath!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffSet: CGFloat!
    var trayUp: CGPoint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let pan = UILongPressGestureRecognizer(target: self, action: #selector(firstPan(rec:)))
        pan.minimumPressDuration = 0.0
        self.addGestureRecognizer(pan)
        self.isUserInteractionEnabled = true
    }
    
    @objc func firstPan(rec: UIPanGestureRecognizer) {
        if rec.view == nil {
            return
        }
        parentVC.view.addSubview(self)

        self.newCoord = rec.location(in: parentVC.view)
        
        let x = self.newCoord.x - (rec.view?.frame.width ?? 0) / 2
        let y = self.newCoord.y - (rec.view?.frame.height ?? 0) / 2
        self.frame = CGRect(x: x, y: y, width: self.frame.width, height: self.frame.height)
        print("New coordinator: x = \(x), y = \(y)")
        let extra = self.parentVC.view.frame.height - self.parentVC.collectionView.frame.height
        if rec.state == .began {
            let selectedIndexPath = parentVC.collectionView.indexPathForItem(at: rec.location(in: parentVC.collectionView))
            self.selectedIndexPath = selectedIndexPath
            self.selectedIndexPathRow = (selectedIndexPath?.row)!
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
        }
        else if rec.state == .ended {
            if y + self.frame.height > extra + 40 {
                UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                    self.transform = CGAffineTransform.identity
                    let cellFrame = self.cellFrame[self.selectedIndexPathRow]
                    self.frame = CGRect(x: cellFrame.minX, y: cellFrame.minY + extra, width: cellFrame.width, height: cellFrame.height)
                }, completion: nil)
                let viewHeight = parentVC.view.frame.height
                self.trayDownOffSet = viewHeight/2 - 88
                trayUp = self.center
                if parentVC.isTray == true {
                    trayOriginalCenter = self.center
                } else if parentVC.isChanging == true {
                    self.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + parentVC.collectionViewTrans.y)
                } else if parentVC.isTray == false {
                    UIView.animate(withDuration: 0.3, animations: {
                        self.center = self.trayUp
                    })
                }
            }
            else if y + self.frame.height < extra + 40 {
                print("New coordinator: x = \(x), y = \(y)")
                self.gestureRecognizers?.removeAll()
                let pan = UIPanGestureRecognizer(target: self, action: #selector(secondPan(rec:)))
                pan.maximumNumberOfTouches = 1
                pan.minimumNumberOfTouches = 1
                let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(rec:)))
                let rotate = UIRotationGestureRecognizer(target: self, action: #selector(didRotate(rec:)))
                let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(rec:)))
                self.addGestureRecognizer(pan)
                self.addGestureRecognizer(pinch)
                self.addGestureRecognizer(rotate)
                self.addGestureRecognizer(tap)
                self.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func secondPan(rec: UIPanGestureRecognizer) {
        let translation = rec.translation(in: parentVC.view)
        if let view = rec.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        rec.setTranslation(CGPoint.zero, in: parentVC.view)
    }
    
    @objc func didPinch(rec: UIPinchGestureRecognizer) {
        if let view = rec.view {
            view.transform = view.transform.scaledBy(x: rec.scale, y: rec.scale)
            rec.scale = 1
        }
    }
    
    @objc func didRotate(rec: UIRotationGestureRecognizer) {
        if let view = rec.view {
            view.transform = view.transform.rotated(by: rec.rotation)
            rec.rotation = 0
        }
    }
    
    @objc func didTap(rec: UITapGestureRecognizer) {
        if let view = rec.view {
            view.removeFromSuperview()
        }
    }
}


