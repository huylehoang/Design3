//
//  CollectionViewCell.swift
//  Design3
//
//  Created by LeeX on 4/16/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit

//protocol CollectionViewCellDelegate: class {
//    func didReceiveView(dragView: UIView)
//}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImg: UIImageView!
    
    var parentView: UICollectionView!

    var parentVC: ViewController!
    
    //var cellDelegate: CollectionViewCellDelegate?
    
    var newCoord:CGPoint = CGPoint(x: 0, y: 0)
    
    var cellFrame:[CGRect] = [CGRect(x: 0, y: 40.0, width: 117.0, height: 117.0),
                              CGRect(x: 129.0, y: 40.0, width: 117.0, height: 117.0),
                              CGRect(x: 258.0, y: 40.0, width: 117.0, height: 117.0),
                              CGRect(x: 0, y: 167.0, width: 117.0, height: 117.0),
                              CGRect(x: 129.0, y: 167.0, width: 117.0, height: 117.0),
                              CGRect(x: 258.0, y: 167.0, width: 117.0, height: 117.0),]
    
    var selectedIndexPath = 0
    
    var copiedView: UICollectionViewCell!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let pan = UILongPressGestureRecognizer(target: self, action: #selector(pan(rec:)))
        pan.minimumPressDuration = 0.0
        self.addGestureRecognizer(pan)
        self.isUserInteractionEnabled = true
    
    }

    @objc func pan(rec: UIPanGestureRecognizer) {
        if rec.view == nil {
            return
        }

        self.newCoord = rec.location(in: parentView)
        
        let x = self.newCoord.x - (rec.view?.frame.width ?? 0) / 2
        let y = self.newCoord.y - (rec.view?.frame.height ?? 0) / 2
        self.frame = CGRect(x: x, y: y, width: self.frame.width, height: self.frame.height)
        print("New coordinator: x = \(x), y = \(y)")
        parentView.bringSubview(toFront: self)
        
        if rec.state == .began {
            let selectedIndexPath = parentView.indexPathForItem(at: rec.location(in: parentView))
            self.selectedIndexPath = (selectedIndexPath?.row)!
            UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
                self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
            //copiedView = self.copyView()
            //parentView.addSubview(copiedView)
        }
        else if rec.state == .ended {
            //parentView.sendSubview(toBack: self)
            print(selectedIndexPath)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
                self.transform = CGAffineTransform.identity
                self.frame = self.cellFrame[self.selectedIndexPath]
                self.parentView.bringSubview(toFront: self)
//                let when = DispatchTime.now() + 0.5
//                DispatchQueue.main.asyncAfter(deadline: when){
//                    self.copiedView.removeFromSuperview()
//                }
            }, completion: nil)
        }
    }
    
}

//extension CollectionViewCell {
//    func copyView<T: UICollectionViewCell>() -> T {
//        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
//    }
//}

