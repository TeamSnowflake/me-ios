//
//  ViewController.swift
//  HelloWorld
//
//  Created by Tcacenco Daniel on 6/12/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import Alamofire
import JSONCodable
import ANLoader

class MAHelloWorldViewController: UIViewController {
    @IBOutlet weak var nameUITextField: UITextField!
    @IBOutlet weak var messageUITextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var messages: [Messages]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMessages()
        messages = [Messages]()
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendRequest(_ sender: Any) {
        ANLoader.showLoading()
        let newMessageJSON = try! NewMessage(name: nameUITextField.text!, message: messageUITextField.text!).toJSON()
        
        Alamofire.request("http://localhost:4000/api/v1/messages", method: .post, parameters: (newMessageJSON as! Parameters), encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            self.getMessages()
            
        }
    }
    
    func getMessages(){
        ANLoader.showLoading()
        Alamofire.request("http://localhost:4000/api/v1/messages").responseJSON { response in
            print("Request: \(String(describing: response.request))")
            print("Response: \(String(describing: response.response))")
            print("Result: \(response.result)")
            
            if let json = response.result.value {
                let messages = try! ResponseMessage(object: json as! JSONObject)
                self.messages = messages.messages
                self.tableView.reloadData()
                print(messages)
                ANLoader.hide()
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)")
            }
        }
    }
}

extension MAHelloWorldViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MAHelloWorldTableViewCell
        let message = messages[indexPath.row]
        cell.nameLabel.text = message.name
        cell.messageLabel.text = "- \(message.message)"
        return cell
    }
}

