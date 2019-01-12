//  Converted to Swift 4 by Swiftify v4.2.20229 - https://objectivec2swift.com/
//
//  DBManager.swift
//  SmartShop
//
//  Created by Chris on 10/30/14.
//  Copyright (c) 2014 ChrisOtto. All rights reserved.
//

//
//  DBManager.swift
//  SQLite3DBSample
//
//  Created by Gabriel Theodoropoulos on 25/6/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

import Foundation

class DBManager: NSObject {
    var arrColumnNames: [AnyHashable] = []
    var affectedRows: Int = 0
    var lastInsertedRowID: Int64 = 0

    init(databaseFilename dbFilename: String?) {
        super.init()
        
        // Set the documents directory path to the documentsDirectory property.
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        documentsDirectory = paths[0]

        // Keep the database filename.
        databaseFilename = dbFilename ?? ""

        // Copy the database file into the documents directory if necessary.
        copyDatabaseIntoDocumentsDirectory()
    
    }

    func loadData(fromDB query: String?) -> [Any]? {
        // Run the query and indicate that is not executable.
        // The query string is converted to a char* object.
        runQuery(Int8(query?.utf8CString ?? 0), isQueryExecutable: false)

        // Returned the loaded results.
        return arrResults as? [Any]
    }

    func executeQuery(_ query: String?) {
        // Run the query and indicate that is executable.
        runQuery(Int8(query?.utf8CString ?? 0), isQueryExecutable: true)
    }

    private var documentsDirectory = ""
    private var databaseFilename = ""
    private var arrResults: [AnyHashable] = []

    private func copyDatabaseIntoDocumentsDirectory() {
        // Check if the database file exists in the documents directory.
        let destinationPath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(databaseFilename).absoluteString
        if !FileManager.default.fileExists(atPath: destinationPath) {
            // The database file does not exist in the documents directory, so copy it from the main bundle now.
            let sourcePath = URL(fileURLWithPath: Bundle.main.resourcePath ?? "").appendingPathComponent(databaseFilename).absoluteString
            var error: Error?
            try? FileManager.default.copyItem(atPath: sourcePath, toPath: destinationPath)

            // Check if any error occurred during copying and display it.
            if error != nil {
                print("\(error?.localizedDescription ?? "")")
            }
        }
    }

    private func runQuery(_ query: UnsafePointer<Int8>?, isQueryExecutable queryExecutable: Bool) {
        // Create a sqlite object.
        var sqlite3Database: sqlite3?

        // Set the database file path.
        let databasePath = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(databaseFilename).absoluteString

        // Initialize the results array.
        if arrResults != nil {
            arrResults.removeAll()
            arrResults = nil
        }
        arrResults = [AnyHashable]()

        // Initialize the column names array.
        if arrColumnNames != nil {
            arrColumnNames.removeAll()
            arrColumnNames = nil
        }
        arrColumnNames = [AnyHashable]()


        // Open the database.
        let openDatabaseResult = sqlite3_open(databasePath.utf8CString, &sqlite3Database)
        if openDatabaseResult == SQLITE_OK {
            // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
            var compiledStatement: sqlite3_stmt?

            // Load all data from database to memory.
            let prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, nil)
            if prepareStatementResult == SQLITE_OK {
                // Check if the query is non-executable.
                if !queryExecutable {
                    // In this case data must be loaded from the database.

                    // Declare an array to keep the data for each fetched row.
                    var arrDataRow: [AnyHashable]

                    // Loop through the results and add them to the results array row by row.
                    while sqlite3_step(compiledStatement) == SQLITE_ROW {
                        // Initialize the mutable array that will contain the data of a fetched row.
                        arrDataRow = [AnyHashable]()

                        // Get the total number of columns.
                        let totalColumns = sqlite3_column_count(compiledStatement)

                        // Go through all columns and fetch each column data.
                        for i in 0..<totalColumns {
                            // Convert the column data to text (characters).
                            var dbDataAsChars = Int8(sqlite3_column_text(compiledStatement, i))

                            // If there are contents in the currenct column (field) then add them to the current row array.
                            if dbDataAsChars != nil {
                                // Convert the characters to string.
                                arrDataRow.append(String(utf8String: &dbDataAsChars) ?? "")
                            }

                            // Keep the current column name.
                            if arrColumnNames.count != totalColumns {
                                dbDataAsChars = Int8(sqlite3_column_name(compiledStatement, i))
                                arrColumnNames.append(String(utf8String: &dbDataAsChars) ?? "")
                            }
                        }

                        // Store each fetched data row in the results array, but first check if there is actually data.
                        if arrDataRow.count > 0 {
                            arrResults.append(arrDataRow)
                        }
                    }
                } else {
                    // This is the case of an executable query (insert, update, ...).

                    // Execute the query.
                    let executeQueryResults = sqlite3_step(compiledStatement)
                    if executeQueryResults == SQLITE_DONE {
                        // Keep the affected rows.
                        affectedRows = sqlite3_changes(sqlite3Database)

                        // Keep the last inserted row ID.
                        lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database)
                    } else {
                        // If could not execute the query show the error message on the debugger.
                        print("DB Error: \(sqlite3_errmsg(sqlite3Database))")
                    }
                }
            } else {
                // In the database cannot be opened then show the error message on the debugger.
                print("\(sqlite3_errmsg(sqlite3Database))")
            }

            // Release the compiled statement from memory.
            sqlite3_finalize(compiledStatement)
        }

        // Close the database.
        sqlite3_close(sqlite3Database)
    }

// MARK: - Initialization

// MARK: - Private method implementation

// MARK: - Public method implementation
}