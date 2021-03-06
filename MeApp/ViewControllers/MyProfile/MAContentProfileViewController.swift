//
//  MAContentProfileViewController.swift
//  Me
//
//  Created by Tcacenco Daniel on 8/24/18.
//  Copyright © 2018 Foundation Forus. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreData
import Alamofire
import Reachability

class MAContentProfileViewController: MABaseViewController, AppLockerDelegate {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var switchFaceID: UISwitch!
    @IBOutlet weak var faceIdImage: UIImageView!
    @IBOutlet weak var faceIdLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileEmailLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    let reachability = Reachability()!
    
    @IBOutlet weak var profileImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
         if UserDefaults.standard.bool(forKey: "isWithTouchID"){
            switchFaceID.isOn = true
         }else {
            switchFaceID.isOn = false
        }

        
        if !faceIDAvailable(){
            faceIdImage.image = #imageLiteral(resourceName: "touchId")
            faceIdLabel.text = "Use Touch ID for login"
        }
        if UserShared.shared.currentUser.firstName != nil {
        profileNameLabel.text = "\(UserShared.shared.currentUser.firstName!) \(UserShared.shared.currentUser.lastName!)"
        }
        profileEmailLabel.text = UserShared.shared.currentUser.primaryEmail
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        appVersionLabel.text = nsObject as? String
//        UserDefaults.standard.set("0000", forKey: ALConstants.kPincode)
//        UserDefaults.standard.synchronize()
//        updateIndentity()
    }
    
    func faceIDAvailable() -> Bool {
        if #available(iOS 11.0, *) {
            let context = LAContext()
            return (context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: nil) && context.biometryType == .faceID)
        }
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func faceIdEnable(_ sender: Any) {
        if (sender as! UISwitch).isOn{
            UserDefaults.standard.set(true, forKey: "isWithTouchID")
        }else{
            UserDefaults.standard.set(false, forKey: "isWithTouchID")
        }
        
    }
    
    @IBAction func editPasscode(_ sender: Any) {
        if reachability.connection != .none{
        var appearance = ALAppearance()
        appearance.image = UIImage(named: "lock")!
        appearance.title = "Edit passcode"
        appearance.subtitle = "Enter your new passcode"
        appearance.isSensorsEnabled = true
        appearance.delegate = self
        
        AppLocker.present(with: .change, and: appearance, withController: self)
        }else {
            AlertController.showInternetUnable()
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        self.logOut()
    }
    
    func updateIndentity(){
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format:"primaryEmail == %@", UserShared.shared.currentUser.primaryEmail!)
        
        do{
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(UserDefaults.standard.string(forKey: ALConstants.kPincode), forKey: "pinCode")
                
                do {
                    try context.save()
                } catch {
                    print("Failed saving")
                }
            }
        } catch{
            
        }
    }
    
    // AppLocker Delegate
    func closePinCodeView(typeClose: typeClose) {
        if typeClose == .create {
            let parameters: Parameters = ["pin_code" : Int16(UserDefaults.standard.integer(forKey: ALConstants.kPincode)),
                                          "old_pin_code" : UserShared.shared.currentUser.pinCode!]
            RequestNewIndetity.updatePinCode(parameters: parameters, completion: { (response, statusCode) in
                if statusCode == 401{
//                    self.logOut()
                }
                
            }) { (error) in
                
            }
            updateIndentity()
            
        }
    }
    

}
