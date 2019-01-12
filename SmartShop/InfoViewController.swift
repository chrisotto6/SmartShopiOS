//  Converted to Swift 4 by Swiftify v4.2.20229 - https://objectivec2swift.com/
//
//  InfoViewController.swift
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

import UIKit

protocol InfoViewControllerDelegate: class {
}

class InfoViewController: UIViewController, UITextViewDelegate {
    var delegate: InfoViewControllerDelegate?
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var attributesText: UITextView!
    var itemIDToView: Int = 0
    private var dbManager: DBManager?

    private func loadInfo() {
        // Create the query
        let query = "select Name, Attributes from items where pk_ItemId=\(itemIDToView)"

        var results: [Any]

        // Load the results
        if let load = dbManager?.loadData(fromDB: query) {
            results = load
        }

        print("Name :\(results[0][(dbManager?.arrColumnNames as NSArray?)?.index(of: "Name") ?? 0])")

        // Set the loaded data to the labels
        nameText.text = results[0][(dbManager?.arrColumnNames as NSArray?)?.index(of: "Name") ?? 0] as? String
        attributesText.text = results[0][(dbManager?.arrColumnNames as NSArray?)?.index(of: "Attributes") ?? 0] as? String ?? ""
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Custom initialization
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        // Initialize the dbManager object
        dbManager = DBManager(databaseFilename: "smartShop.db")

        // assign delegates
        attributesText.delegate = self

        loadInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}