//
//  PassViewController.swift
//  TestProject
//
//  Created by Tcacenco Daniel on 5/8/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Presentr

class PassViewController: MABaseViewController {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var imageQR: UIImageView!
    
    let dynamicSizePresenter: Presentr = {
        let presentationType = PresentationType.dynamic(center: .center)
        
        let presenter = Presentr(presentationType: presentationType)
       
        return presenter
    }()
    let presenter: Presentr = {
        let presenter = Presentr(presentationType: .alert)
        presenter.transitionType = TransitionType.coverHorizontalFromRight
        presenter.dismissOnSwipe = true
        return presenter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.placeholderColor(text: "Zoek transacties", withColor: .white)
        imageQR.generateQRCode(from: "456,66")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func showEmailToMe(_ sender: Any) {
        let popupTransction =  MAEmailForMeViewController(nibName: "MAEmailForMeViewController", bundle: nil)
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.keyboardTranslationType = .compress
        customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
    @IBAction func showAmmount(_ sender: Any) {
        let popupTransction =  MAShareVaucherViewController(nibName: "MAShareVaucherViewController", bundle: nil)
        presenter.presentationType = .popup
        presenter.transitionType = nil
        presenter.dismissTransitionType = nil
        presenter.keyboardTranslationType = .compress
        customPresentViewController(presenter, viewController: popupTransction, animated: true, completion: nil)
    }
    
}



// MARK: - UITableViewDelegate
extension PassViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PassTableViewCell
        
        if indexPath.row == 0 {
            cell.imageEarth.image = UIImage.init(named: "purpleEarth")
            cell.companyTitle.text = "RMinds"
        }else if indexPath.row == 1{
            cell.imageEarth.image = UIImage.init(named: "greenEarth")
            cell.companyTitle.text = "EBIntegrator"
            cell.price1UILabel.text = "+2"
            cell.price1UILabel.textColor = UIColor.init(red: 86/255, green: 177/255, blue: 222/255, alpha: 1.0)
            cell.price2UILabel.textColor = UIColor.init(red: 86/255, green: 177/255, blue: 222/255, alpha: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0){
            let popupTransction =  MATransactionBlueViewController(nibName: "MATransactionBlueViewController", bundle: nil)
            customPresentViewController(dynamicSizePresenter, viewController: popupTransction, animated: true, completion: nil)
        }else{
            let popupTransction =  MATransactionBlueViewController(nibName: "MATransactionBlueViewController", bundle: nil)
            customPresentViewController(dynamicSizePresenter, viewController: popupTransction, animated: true, completion: nil)
        }
    }
}

