//  Converted to Swift 4 by Swiftify v4.2.20229 - https://objectivec2swift.com/
//
//  ItemViewController.swift
//  SmartShop
//
//  Created by Chris on 12/13/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

import UIKit

protocol ItemViewControllerDelegate: class {
}

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var delegate: ItemViewControllerDelegate?
    @IBOutlet weak var itemAdd: UIBarButtonItem!

    @IBAction func itemAddNew(_ sender: Any) {
    }

    @IBOutlet weak var tblItems: UITableView!
    var recordIDToView: Int = 0
    private var dbManager: DBManager?
    private var arrItem: [Any] = []
    private var itemIDToView: Int = 0

    private func loadData() {
        print("The previous record is \(recordIDToView)")

        // Form the query.
        let query = "select * from items where fk_ListID = \(recordIDToView)"

        // Get the results.
        if arrItem != nil {
            arrItem = nil
        }
        if let load = dbManager?.loadData(fromDB: query) {
            arrItem = load
        }

        // Reload the table view.
        tblItems.reloadData()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        // Custom initialization
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        tblItems.delegate = self
        tblItems.dataSource = self

        // Initialize the dbManager object.
        dbManager = DBManager(databaseFilename: "smartShop.db")

        // Load the Data
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "idSegueViewItem") {
            let infoViewController = segue.destination as? InfoViewController
            infoViewController?.itemIDToView = itemIDToView
        } else if (segue.identifier == "segueCapture") {
            let captureViewController = segue.destination as? CaptureViewController
            captureViewController?.recordIDToView = recordIDToView
        }
    }

// MARK: - UITableView method implementation
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrItem.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the cell.
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "itemNames", for: indexPath)

        let indexOfItemname: Int? = (dbManager?.arrColumnNames as NSArray?)?.index(of: "Name")

        // Set the loaded data to the appropriate cell labels.
        cell.textLabel?.text = "\(arrItem[indexPath.row][indexOfItemname ?? 0])"

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // Get the record ID of the selected name and set it to the recordIDToEdit property.
        itemIDToView = (arrItem[indexPath.row][0] as? NSNumber)?.intValue

        // Perform the segue.
        performSegue(withIdentifier: "idSegueViewItem", sender: self)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            // Delete the selected record.
            // Find the record ID.
            let recordIDToDelete: Int = (arrItem[indexPath.row][0] as? NSNumber)?.intValue

            // Prepare the query.
            let query = "delete from items where pk_ItemId=\(recordIDToDelete)"

            // Execute the query.
            dbManager?.executeQuery(query)

            // Reload the table view.
            loadData()
        }
    }

    @IBAction func addNewItem(_ sender: Any) {
        performSegue(withIdentifier: "segueCapture", sender: self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}