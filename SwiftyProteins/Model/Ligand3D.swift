//
//  Ligand3D.swift
//  SwiftyProteins
//
//  Created by Danil Vdovenko on 4/10/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import Foundation
import UIKit
import SceneKit

final class Ligand3D {
    
    let colors = ["H": UIColor.white,
                "C": UIColor.black,
                "N": UIColor.blue,
                "O": UIColor.red,
                "F": UIColor.green,
                "CL": UIColor.green,
                "BR": UIColor.fromHex(rgbValue: 0xff2200, alpha: 1),
                "I": UIColor.fromHex(rgbValue: 0x6600bb, alpha: 1),
                "HE": UIColor.cyan,
                "NE": UIColor.cyan,
                "AR": UIColor.cyan,
                "XE": UIColor.cyan,
                "KR": UIColor.cyan,
                "P": UIColor.orange,
                "S": UIColor.yellow,
                "B": UIColor.fromHex(rgbValue: 0xffaa77, alpha: 1),
                "LI": UIColor.fromHex(rgbValue: 0x7700ff, alpha: 1),
                "NA": UIColor.fromHex(rgbValue: 0x7700ff, alpha: 1),
                "K": UIColor.fromHex(rgbValue: 0x7700ff, alpha: 1),
                "RB": UIColor.fromHex(rgbValue: 0x7700ff, alpha: 1),
                "CS": UIColor.fromHex(rgbValue: 0x7700ff, alpha: 1),
                "FR": UIColor.fromHex(rgbValue: 0x7700ff, alpha: 1),
                "BE": UIColor.fromHex(rgbValue: 0x007700, alpha: 1),
                "MG": UIColor.fromHex(rgbValue: 0x007700, alpha: 1),
                "CA": UIColor.fromHex(rgbValue: 0x007700, alpha: 1),
                "SR": UIColor.fromHex(rgbValue: 0x007700, alpha: 1),
                "BA": UIColor.fromHex(rgbValue: 0x007700, alpha: 1),
                "RA": UIColor.fromHex(rgbValue: 0x007700, alpha: 1),
                "TI": UIColor.gray,
                "FE": UIColor.fromHex(rgbValue: 0xdd7700, alpha: 1),
                "Other": UIColor.fromHex(rgbValue: 0xdd77ff, alpha: 1)]
    
    //MARK: - Public API
    public func addAtoms(_ atoms: [Atom], isSquare: Bool) -> SCNNode {
        
        let atomNode = SCNNode()
        
        for atom in atoms {
            
            nodeWithAtom(atom: myAtom(atom.symbol, isSquare), molecule: atomNode, position:
                SCNVector3(atom.coordinates.x, atom.coordinates.y, atom.coordinates.z))
            
        }
        
        return atomNode
    }
    
    public func addConnections(from firstAtom: Atom, to secondAtom: Atom) -> ConnectionModel {
        
        let cylinder = ConnectionModel(parent: SCNNode(), v1: SCNVector3(firstAtom.coordinates.x, firstAtom.coordinates.y, firstAtom.coordinates.z), v2:
            SCNVector3(secondAtom.coordinates.x, secondAtom.coordinates.y, secondAtom.coordinates.z), r: 0.1, segmentCount: 150, color: UIColor.lightGray)
        
        return cylinder

    }
    
    //MARK: - Private API
    
    private func nodeWithAtom(atom: SCNGeometry, molecule: SCNNode, position: SCNVector3) {
        
        let node = SCNNode(geometry: atom)
        
        node.position = position
        
        molecule.addChildNode(node)
        
    }
    
    private func myAtom(_ name: String, _ isSquare: Bool) -> SCNGeometry {
        
        var atom = SCNGeometry()
        
        if isSquare {
            
            atom = SCNBox(width: 0.5, height: 0.5, length: 0.5, chamferRadius: 0.1)
            
        } else {
            
            atom = SCNSphere(radius: 0.25)
            
        }
        
        atom.firstMaterial?.diffuse.contents = colors[name] ?? colors["Other"]
        atom.firstMaterial?.specular.contents = UIColor.white
        
        return atom
        
    }
    
    deinit {
        print("Deinit Ligand3D")
    }
    
}

extension SCNGeometry {
    class func lineFrom(vector vector1: SCNVector3, toVector vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        
        return SCNGeometry(sources: [source], elements: [element])
        
    }
    
}
