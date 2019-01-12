//  Converted to Swift 4 by Swiftify v4.2.20229 - https://objectivec2swift.com/
//
//  ItemManager.swift
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

import Foundation

class ItemManager: NSObject, ItemManagerDelegate {
    var communicator: ItemCommunicator?
    weak var delegate: ItemManagerDelegate?

    func fetchItems(_ barcode: String?) {
        communicator?.searchItems(barcode)
    }

    func receivedItemsJSON(_ objectNotation: Data?) {
        var error: Error? = nil
        let items = try? ItemBuilder.item(fromJSON: objectNotation)

        if error != nil {
            try? delegate?.fetchingItemsFailed()
        } else {
            delegate?.didReceiveItems(items)
        }
    }

    func fetchingItemsFailed() throws {
        try? delegate?.fetchingItemsFailed()
    }
}