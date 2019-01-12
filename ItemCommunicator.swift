//  Converted to Swift 4 by Swiftify v4.2.20229 - https://objectivec2swift.com/
//
//  ItemCommunicator.swift
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

import Foundation

class ItemCommunicator: NSObject {
    weak var delegate: ItemCommunicatorDelegate?

    func searchItems(_ barcode: String?) {
        let urlAsString = "http://www.outpan.com/api/get-product.php?apikey=\(API_KEY)&barcode=\(barcode ?? "")"
        let url = URL(string: urlAsString)
        print("\(urlAsString)")

        if let url = url {
            NSURLConnection.sendAsynchronousRequest(URLRequest(url: url), queue: OperationQueue(), completionHandler: { response, data, error in
    
                if error != nil {
                    try? self.delegate?.fetchingItemFailed()
                } else {
                    self.delegate?.receivedItemJSON(data)
                }
            })
        }
    }
}

let API_KEY = "9b322eaada88d663930626c7feda769b"