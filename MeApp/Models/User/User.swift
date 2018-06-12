//
//  User.swift
//  MeApp
//
//  Created by Tcacenco Daniel on 5/31/18.
//  Copyright © 2018 Tcacenco Daniel. All rights reserved.
//

import UIKit
import JSONCodable

struct User{
    var name: String?
    var image: String?
}

extension User: JSONDecodable{
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object:object)
        name = try decoder.decode("name")
        image = try decoder.decode("image")
    }
}

extension User: JSONEncodable{
    func toJSON() throws -> Any {
        return try JSONEncoder.create({ (encoder) -> Void in
            try encoder.encode(name, key:"name")
            try encoder.encode(image, key:"image")
        })
    }
}
