//  Converted to Swift 4 by Swiftify v4.2.20229 - https://objectivec2swift.com/
//
//  ItemBuilder.swift
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

import Foundation

class ItemBuilder: NSObject {
    class func item(fromJSON objectNotation: Data?) throws -> [Any]? {
        var localError: Error? = nil
        var parsedObject: [AnyHashable : Any]? = nil
        if let objectNotation = objectNotation {
            parsedObject = try? JSONSerialization.jsonObject(with: objectNotation, options: []) as? [AnyHashable : Any]
        }

        if localError != nil {
            error = localError
            return nil
        }

        var items: [AnyHashable] = []

        let results = parsedObject?["results"] as? [Any]
        print(String(format: "Count %lu", UInt(results?.count ?? 0)))

        for itemDic: [AnyHashable : Any]? in results as? [[AnyHashable : Any]?] ?? [] {
            var item = Item()

            for key: String? in itemDic as? [String?] ?? [:] {
                if item.responds(to: NSSelectorFromString(key)) {
                    item.setValue(itemDic?[key], forKey: key ?? "")
                }
            }

            items.append(item)
        }

        return items
    }
}