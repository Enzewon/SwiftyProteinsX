//
//  Database.swift
//  SwiftyProteins
//
//  Created by Danil Vdovenko on 3/27/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import Foundation

struct Database {
    
    let name = "ligands"
    let type = "txt"
    var ligandsBase = [String]()
    
    mutating func readFromFile() {
        if let path = Bundle.main.path(forResource: name, ofType: type) {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                ligandsBase = data.components(separatedBy: .newlines)
            } catch {
                print(error)
            }
        }
    }
}
