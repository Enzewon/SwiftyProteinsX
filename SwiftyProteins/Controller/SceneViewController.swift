//
//  SceneViewController.swift
//  SwiftyProteins
//
//  Created by Danil Vdovenko on 4/10/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import UIKit
import SceneKit

class SceneViewController: UIViewController {
    
    let sceneView: SCNView = {
       
        let sceneView = SCNView()
        
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        
        return sceneView
        
    }()
    
    let atomLabel: UILabel = {
       
        let label = UILabel()
        
        label.text = "   Selected Atom: -   "
        label.textColor = .white
        label.layer.backgroundColor = UIColor.rgb(red: 96, green: 125, blue: 139, alpha: 1).cgColor
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        
        return label
        
    }()
    
    let segmentControl: UISegmentedControl = {
       
        let segmentControl = UISegmentedControl()
        
        segmentControl.insertSegment(withTitle: "Ball-and-Sticks", at: 0, animated: true)
        segmentControl.insertSegment(withTitle: "Squares-and-Sticks", at: 1, animated: true)
        segmentControl.backgroundColor = .white
        segmentControl.layer.cornerRadius = 5
        segmentControl.addTarget(self, action: #selector(changeDraw), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        
        return segmentControl
        
    }()
    
    weak var ligandInfo: Ligand!
    
    var ligandModel = Ligand3D()
    var atomNodes = SCNNode()
    var connectionNodes = SCNNode()
    var mainScene = SCNScene()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.becomeFirstResponder()
        
        let shareButton = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(SceneViewController.shareButton(sender:)))
        navigationItem.rightBarButtonItem = shareButton
        navigationItem.title = "Ligand \(ligandInfo.name ?? "unknown" )"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        sceneView.scene = mainScene
        
        view.addSubview(atomLabel)
        
        view.addConstraintsWithFormat(format: "H:|-8-[v0]", views: atomLabel)
        view.addConstraintsWithFormat(format: "V:|-\((self.navigationController?.navigationBar.frame.size.height)! + 36)-[v0(\(UIFont.systemFontSize * 3))]", views: atomLabel)
        
        view.addSubview(segmentControl)
        
        view.addConstraintsWithFormat(format: "H:|-24-[v0]-24-|", views: segmentControl)
        view.addConstraintsWithFormat(format: "V:[v0]-30-|", views: segmentControl)
        
        view.addSubview(sceneView)
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: sceneView)
        view.addConstraintsWithFormat(format: "V:|[v0]|", views: sceneView)
        
        view.sendSubview(toBack: sceneView)
        
        let cameraNode = SCNNode()
        
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 35)
        mainScene.rootNode.addChildNode(cameraNode)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SceneViewController.handleTab(recognize:)))
        sceneView.addGestureRecognizer(tap)
        
        sceneView.prepare(mainScene, shouldAbortBlock: nil)
        
        atomNodes = ligandModel.addAtoms(ligandInfo.atoms, isSquare: false)
        connectEverything()
        sceneView.scene?.rootNode.addChildNode(atomNodes)
        sceneView.scene?.rootNode.addChildNode(connectionNodes)
        
    }
    
    @objc func changeDraw() {
        
        atomNodes.removeFromParentNode()
        connectionNodes.removeFromParentNode()
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            atomNodes = ligandModel.addAtoms(ligandInfo.atoms, isSquare: false)
        case 1:
            atomNodes = ligandModel.addAtoms(ligandInfo.atoms, isSquare: true)
        default:
            atomNodes = ligandModel.addAtoms(ligandInfo.atoms, isSquare: false)
        }
        
        connectEverything()
        sceneView.scene?.rootNode.addChildNode(atomNodes)
        sceneView.scene?.rootNode.addChildNode(connectionNodes)
        
    }
    
    @objc func shareButton(sender: UIButton) {

        UIGraphicsBeginImageContextWithOptions(self.sceneView.frame.size, true, 0.0)
        self.sceneView.drawHierarchy(in: self.sceneView.frame, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let img = img {
            let objectsToShare = [img] as [UIImage]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    func connectEverything() {
        
        for connection in ligandInfo.connections {
            
            let mainAtom = ligandInfo.atoms[connection[0] - 1]
            
            for link in connection {
                
                if link != mainAtom.id {
                    
                    connectionNodes.addChildNode(ligandModel.addConnections(from: mainAtom, to: ligandInfo.atoms[link - 1]))
                    
                }
                
            }
            
        }
        
    }
    
    @objc func handleTab(recognize: UITapGestureRecognizer) {
        if recognize.state == .ended {
            let location = recognize.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if !hits.isEmpty {
                if let tappedNode = hits.first?.node {
                    for atom in ligandInfo.atoms {
                        if atom.coordinates.x == tappedNode.position.x {
                            if atom.coordinates.y == tappedNode.position.y {
                                atomLabel.text = "   Selected Atom: \(atom.symbol)   "
                            }
                        }
                    }
                }
            }
        }
    }
}
