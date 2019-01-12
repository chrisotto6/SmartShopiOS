//  Converted to Swift 4 by Swiftify v4.2.20229 - https://objectivec2swift.com/
//
//  ItemCommunicatorDelegate.swift
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

import Foundation

protocol ItemCommunicatorDelegate: NSObjectProtocol {
    func receivedItemJSON(_ objectNotation: Data?)
    func fetchingItemFailed() throws
}