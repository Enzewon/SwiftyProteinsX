//
//  Ligand.swift
//  SwiftyProteins
//
//  Created by Danil Vdovenko on 3/30/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import Foundation

struct Coordinate {
    var x: Float = 0.0
    var y: Float = 0.0
    var z: Float = 0.0
}

struct Atom {
    var id: Int
    var coordinates: Coordinate
    var symbol: String
}

class Ligand {
    
    var info: String?
    var name: String?
    var atoms = [Atom]()
    var connections = [[Int]]()
    
    public func parseAtomAndConnections() {
        
        if let pdbInfo = info?.components(separatedBy: .newlines) {
            
            for line in pdbInfo {
                
                if line.range(of: "ATOM") != nil {
                    let atom = Atom(id: Int(line[6..<11].trimmingCharacters(in: .whitespaces)) ?? 0, coordinates: Coordinate.init(x: Float(line[30..<38].trimmingCharacters(in: .whitespaces)) ?? 0, y: Float(line[38..<46].trimmingCharacters(in: .whitespaces)) ?? 0, z: Float(line[46..<54].trimmingCharacters(in: .whitespaces)) ?? 0), symbol: line[76...77].trimmingCharacters(in: .whitespaces))
                    atoms.append(atom)
                } else if line.range(of: "CONECT") != nil {
                    let connectionInfo = line[6..<line.count].split(separator: " ").map { Int($0) ?? 0 }
                    connections.append(connectionInfo)
                }
                
            }
            
        }
        
    }
    
    deinit {
        print("Deinit Ligand with name \(name ?? "Default")")
    }
    
}
