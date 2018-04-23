//
//  CollectionHeaderView.swift
//  Design3
//
//  Created by LeeX on 4/16/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
        
    @IBOutlet weak var arrowImg: UIImageView!
    
    var parentView: UICollectionView!
    
    var parentVC: ViewController!
    
    var isShow = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.arrowImg.image = #imageLiteral(resourceName: "Accordion_ExpandableAccordion_Arrow_Up")
        let tap = UITapGestureRecognizer(target: self, action: #selector(showAndHidden(sender:)))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
    }

    @objc func showAndHidden(sender: UITapGestureRecognizer) {
        
        isShow = !isShow
        let viewHeight = parentVC.view.frame.height
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            switch self.isShow {
            case true:
                print("Show")
                self.parentView.reloadData()
                self.parentView.transform = CGAffineTransform(translationX: 0, y: -(viewHeight/2 - 88))
                self.isShow = true
                self.arrowImg.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            case false:
                print("Hidden")
                self.parentView.reloadData()
                self.parentView.transform = CGAffineTransform.identity
                self.isShow = false
                self.arrowImg.transform = CGAffineTransform.identity
            }
        }, completion: nil)
    }
    
}
