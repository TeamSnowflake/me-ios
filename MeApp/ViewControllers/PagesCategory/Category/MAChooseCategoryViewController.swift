//
//  MAChooseCategoryViewController.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 7/20/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import SwiftMessages

class MAChooseCategoryViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var recordCategories : NSMutableArray! = NSMutableArray()
    var previusCell: MAChooseCategoryCollectionViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRecordCategory()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getRecordCategory(){
        RecordCategoryRequest.getRecordCategory(completion: { (response) in
            self.recordCategories.addObjects(from: response as! [Any])
            self.collectionView.reloadData()
        }) { (error) in
            AlertController.showError()
        }
    }
    

}

extension MAChooseCategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recordCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MAChooseCategoryCollectionViewCell
        let recordCategory = recordCategories[indexPath.row] as! RecordCategory
        cell.titleCategory.text = recordCategory.name
        if recordCategory.name ==  "Personal"{
            cell.imageCategory.image = UIImage.init(named: "iconPersonal")
        }else if recordCategory.name == "Relaties"{
            cell.imageCategory.image = UIImage.init(named: "iconRelations")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recordCategory = recordCategories[indexPath.row] as! RecordCategory
        if recordCategory.name == "Personal" {
            let cell = collectionView.cellForItem(at: indexPath) as! MAChooseCategoryCollectionViewCell
            cell.viewBody.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9725490196, alpha: 1)
            if previusCell != nil {
                previusCell.viewBody.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
            }
            previusCell = cell
            
            UserDefaults.standard.set(try? PropertyListEncoder().encode(recordCategory), forKey: "category")
            NotificationCenter.default.post(name: Notification.Name("SETSELECTEDCATEGORY"), object: nil)
            NotificationCenter.default.post(name: Notification.Name("EnableNextButton"), object: nil)
        } else{
            let error = MessageView.viewFromNib(layout: .tabView)
            error.configureTheme(.warning)
            error.configureContent(title: "Warning", body: "Only personal category can be choose for this moment" , iconImage: nil, iconText: "", buttonImage: nil, buttonTitle: "YES") { _ in
                SwiftMessages.hide()
            }
            error.button?.setTitle("OK", for: .normal)
            
            SwiftMessages.show( view: error)
        }
    }
    
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.size.width / 2 - 25, height: 110)
    }
}

