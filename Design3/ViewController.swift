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
    
    //var dragView: UIView!
    
    var newCoord:CGPoint = CGPoint(x: 0, y: 0)
    
    //var cellView: UICollectionViewCell!

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
        cell.parentView = self.collectionView
        cell.parentVC = self
        //cell.cellDelegate = self
        
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

//extension ViewController: CollectionViewCellDelegate {
//    func didReceiveView(dragView: UIView) {
//        self.dragView = UIView()
//        self.dragView = dragView
//        self.view.addSubview(self.dragView)
//    }
//}

