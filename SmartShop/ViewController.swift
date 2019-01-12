//  Converted to Swift 4 by Swiftify v4.2.20229 - https://objectivec2swift.com/
//
//  ViewController.swift
//  SmartShop
//
//  Created by Chris on 10/30/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

import UIKit

//Global Variables
    var listName = ""

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var addList: UIBarButtonItem!

    @IBAction func addNewList(_ sender: Any) {
        let alert = UIAlertView(title: "Add List", message: "Enter new list name:", delegate: self, cancelButtonTitle: "Add", otherButtonTitles: "")
        alert.alertViewStyle = .plainTextInput
        let alertTextField: UITextField? = alert.textField(at: 0)
        alertTextField?.placeholder = "List name"
        alert.show()
    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        let listName = alertView.textField(at: 0)?.text
        print("ENTERED: \(listName ?? "")")

        //Prepare the query String
        let query = "insert into lists values (null, '\(listName ?? "")')"

        // Execute the query.
        dbManager?.executeQuery(query)

        // If the query was successfully executed then pop the view controller.
        if dbManager?.affectedRows != 0 {
            print("Query was executed successfully. Affected rows = \(dbManager?.affectedRows ?? 0)")

            // Pop the view controller.
            navigationController?.popViewController(animated: true)
        } else {
            print("Could not execute the query.")
        }

        loadData()
    }

    @IBOutlet weak var tblList: UITableView!
    private var dbManager: DBManager?
    private var arrLists: [Any] = []
    private var recordIDToView: Int = 0

    private func loadData() {
        // Form the query.
        let query = "select * from lists"

        // Get the results.
        if arrLists != nil {
            arrLists = nil
        }
        if let load = dbManager?.loadData(fromDB: query) {
            arrLists = load
        }

        // Reload the table view.
        tblList.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tblList.delegate = self
        tblList.dataSource = self

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
        let itemViewController = segue.destination as? ItemViewController
        itemViewController?.delegate = self
        itemViewController?.recordIDToView = recordIDToView

    }

// MARK: - Private method implementation

// MARK: - UITableView method implementation
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrLists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the cell.
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "listNames", for: indexPath)

        let indexOfListname: Int? = (dbManager?.arrColumnNames as NSArray?)?.index(of: "ListName")

        // Set the loaded data to the appropriate cell labels.
        cell.textLabel?.text = "\(arrLists[indexPath.row][indexOfListname ?? 0])"

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        // Get the record ID of the selected name and set it to the recordIDToEdit property.
        recordIDToView = (arrLists[indexPath.row][0] as? NSNumber)?.intValue

        // Perform the segue.
        performSegue(withIdentifier: "idSegueViewList", sender: self)
        print("ID : \(recordIDToView)")
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
            // Delete the selected record.
            // Find the record ID.
            let recordIDToDelete: Int = (arrLists[indexPath.row][0] as? NSNumber)?.intValue

            // Prepare the query.
            var query = "delete from lists where pk_ListId=\(recordIDToDelete)"

            // Execute the query.
            dbManager?.executeQuery(query)

            // Delete from items
            query = "delete from items where fk_ListID=\(recordIDToDelete)"

            // Execute the query.
            dbManager?.executeQuery(query)

            // Reload the table view.
            loadData()
        }
    }
}