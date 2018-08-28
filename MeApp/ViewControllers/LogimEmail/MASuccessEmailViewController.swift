//
//  MASuccessEmailViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/27/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import CoreData

class MASuccessEmailViewController: MABaseViewController {
    var timer : Timer! = Timer()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.standard.string(forKey: "auth_token") != ""{
            self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.authorizeToken), userInfo: nil, repeats: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func openMailApp(_ sender: Any) {
        let mailURL = NSURL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL as URL) {
            UIApplication.shared.open(mailURL as URL, options: [:],
                                      completionHandler: {
                                        (success) in
            })
        }
    }
    
    @objc func authorizeToken(){
        Status.checkStatus(accessToken: UserDefaults.standard.string(forKey: "auth_token")!, completion: { (code) in
            if code == 200 {
                self.timer.invalidate()
                self.performSegue(withIdentifier: "goToWalet", sender: nil)
                //check if user exist or no
                self.saveNewIdentity(accessToken: UserDefaults.standard.string(forKey: "auth_token")!, email: "")
                self.updateOldIndentity()
                self.getCurrentUser(accessToken: UserDefaults.standard.string(forKey: "auth_token")!)
              
            }
        }) { (error) in
            AlertController.showError()
        }
    }
    
    func saveNewIdentity(accessToken: String, email: String){
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", email)
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                let newUser = NSManagedObject(entity: entity!, insertInto: context)
                newUser.setValue(true, forKey: "currentUser")
                newUser.setValue(accessToken, forKey: "accessToken")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }else{
                results![0].setValue(accessToken, forKey: "accessToken")
                results![0].setValue(true, forKey: "currentUser")
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{
            
        }
    }
    
    func updateOldIndentity(){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"currentUser == YES")
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count == 0 {
                results![0].setValue(false, forKey: "currentUser")
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{
            
        }
    }
    
    func getCurrentUser(accessToken: String!){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"accessToken == %@", accessToken)
        
        do{
            let results = try context.fetch(fetchRequest) as? [User]
            UserShared.shared.currentUser = results![0]
            
        } catch{
            
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        UserDefaults.standard.setValue("", forKeyPath: "auth_token")
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
