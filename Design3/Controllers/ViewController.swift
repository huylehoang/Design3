//
//  ViewController.swift
//  Design3
//
//  Created by LeeX on 4/16/18.
//  Copyright © 2018 LeeX. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var emoticons = [UIImage(named: "emo1"),UIImage(named: "emo2"),UIImage(named: "emo3"),UIImage(named: "emo4"),UIImage(named: "emo5"),UIImage(named: "emo6")]
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffSet: CGFloat!
    var trayUp: CGPoint!
    var collectionViewTrans: CGPoint!
    
    var isTray = false
    var isChanging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func setupCollectionView() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.lightGray
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil).self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil).self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionHeaderView")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let viewHeight = view.frame.height
        let viewWidth = view.frame.width
        collectionView.frame = CGRect(x: 0, y: viewHeight - 40, width: viewWidth, height: view.frame.height/2 - 48)
        trayDownOffSet = viewHeight/2 - 88
        trayUp = collectionView.center
        let panTray = UIPanGestureRecognizer(target: self, action: #selector(didPanTray(rec:)))
        collectionView.addGestureRecognizer(panTray)
        collectionView.isUserInteractionEnabled = true
    }
    
    @objc func didPanTray(rec: UIPanGestureRecognizer) {
        let translation = rec.translation(in: self.view)
        self.collectionViewTrans = translation
        if rec.state == .began {
            isTray = true
            trayOriginalCenter = collectionView.center
        } else if rec.state == .changed {
            isChanging = true
            collectionView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            collectionView.reloadData()
        } else if rec.state == .ended {
            isTray = false
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView.center = self.trayUp
            })
            collectionView.reloadData()
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width)/3 - 8, height: (collectionView.frame.width)/3 - 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell" , for: indexPath) as! CollectionViewCell
        cell.cellImg.image = emoticons[indexPath.row]
        cell.parentVC = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionHeaderView", for: indexPath) as! CollectionHeaderView
            reusableView.backgroundColor = UIColor.lightGray
            reusableView.parentView = self.collectionView
            reusableView.parentVC = self
            return reusableView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }

}

