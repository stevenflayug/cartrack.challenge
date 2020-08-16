//
//  SQLiteManager.swift
//  iOS Challange
//
//  Created by Steven Layug on 8/16/20.
//  Copyright © 2020 Steven Layug. All rights reserved.
//

import Foundation

class SQLiteManager {
    let fileManager = FileManager.default
    var sqliteDB: OpaquePointer?
    var dbURL: NSURL? = nil
    
    func addDefaultUser() {
        do {
            let baseUrl = try
                fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbURL = baseUrl.appendingPathComponent("swift.sqlite") as NSURL
        } catch {
            print(error)
        }
        
        if let _ = dbURL {
            let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
            let status = sqlite3_open_v2(dbURL?.absoluteString?.cString(using: String.Encoding.utf8), &sqliteDB, flags, nil)
            if status == SQLITE_OK {
                let errorMessage: UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
                let sqlStatement = """
                        CREATE TABLE User(
                        Username CHAR(255),
                        Password CHAR(255));
                        """
                
                if sqlite3_exec(sqliteDB, sqlStatement, nil, nil, errorMessage) == SQLITE_OK {
                    print ("Table created")
                } else {
                    print ("Failed to create table")
                }
                
                var statement: OpaquePointer?
                let insertStatement = "INSERT INTO User (Username, Password) VALUES ('stevenflayug', 'cartrack');"
                sqlite3_prepare_v2(sqliteDB, insertStatement, -1, &statement, nil)
                if sqlite3_step(statement) == SQLITE_DONE {
                    print ("Credentials inserted")
                } else {
                    print ("Credentials not inserted")
                }
                sqlite3_finalize(statement)
            }
        }
    }
    
    func deleteUser() {
        do {
            let baseUrl = try
                fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbURL = baseUrl.appendingPathComponent("swift.sqlite") as NSURL
        } catch {
            print(error)
        }
        
        if let _ = dbURL {
            let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
            let status = sqlite3_open_v2(dbURL?.absoluteString?.cString(using: String.Encoding.utf8), &sqliteDB, flags, nil)
            if status == SQLITE_OK {
                var deleteStatement: OpaquePointer?
                let deleteStatementString = "DELETE FROM User WHERE Username = 'stevenflayug';"
                if sqlite3_prepare_v2(sqliteDB, deleteStatementString, -1, &deleteStatement, nil) ==
                    SQLITE_OK {
                    if sqlite3_step(deleteStatement) == SQLITE_DONE {
                        print("\nSuccessfully deleted row.")
                    } else {
                        print("\nCould not delete row.")
                    }
                } else {
                    print("\nDELETE statement could not be prepared")
                }
                sqlite3_finalize(deleteStatement)
            }
        }
    }
    
    func login(username: String, password: String, completion: @escaping (_ success: Bool, _ error: String?) -> ()) {
        do {
            let baseUrl = try
                fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            dbURL = baseUrl.appendingPathComponent("swift.sqlite") as NSURL
        } catch {
            print(error)
        }
        
        if let _ = dbURL {
            let flags = SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE
            let status = sqlite3_open_v2(dbURL?.absoluteString?.cString(using: String.Encoding.utf8), &sqliteDB, flags, nil)
            if status == SQLITE_OK {
                var selectStatement: OpaquePointer?
                let selectSql = "SELECT * FROM User WHERE Username = '\(username)' AND Password = '\(password)';"
                if sqlite3_prepare_v2(sqliteDB, selectSql, -1, &selectStatement, nil) == SQLITE_OK {
                    while sqlite3_step(selectStatement) == SQLITE_ROW {
                        let usernameString = String(cString: sqlite3_column_text(selectStatement, 0))
                        let passwordString = String(cString: sqlite3_column_text(selectStatement, 1))
                        print("\(usernameString) \(passwordString)")
                        completion(true, nil)
                        sqlite3_finalize(selectStatement)
                        return
                    }
                    completion(false, "Incorrect Username or Password")
                    sqlite3_finalize(selectStatement)
                    return
                } else {
                    completion(false, "Incorrect Username or Password")
                }
                sqlite3_finalize(selectStatement)
            }
        }
    }
}

