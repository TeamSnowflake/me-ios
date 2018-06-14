//
//  Messages.swift
//  HelloWorld
//
//  Created by Tcacenco Daniel on 6/12/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import Foundation
import JSONCodable

struct  Messages{
    var name: String
    var message: String
}

extension Messages: JSONDecodable{
    
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        name = try decoder.decode("name")
        message = try decoder.decode("message")
    }
}

struct NewMessage{
    var name: String
    var message: String
}

extension NewMessage: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(name, key:"name")
            try encoder.encode(message, key:"message")
        })
    }
}
