//
//  RequestNewIndetity.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 6/1/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import Alamofire

class RequestNewIndetity{
    
    static func createnewIndentity(newIndeity: NewIdentity){
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        Alamofire.request(BaseURL.baseURL(url: "identity"), method: .post, parameters: nil,encoding: JSONEncoding.default, headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                print(response)
//                let newIdentityResponse = Mapper<Response>().map(JSONObject:response.result.value)
//                print(newIdentityResponse as Any)
                break
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
}
