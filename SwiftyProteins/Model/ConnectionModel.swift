//
//  ConnectionModel.swift
//  SwiftyProteins
//
//  Created by Danil Vdovenko on 4/10/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import Foundation
import SceneKit

class ConnectionModel: SCNNode
{
    init(parent: SCNNode,   //Needed to add destination point of your line
        v1: SCNVector3, //source
        v2: SCNVector3, //destination
        r radius: CGFloat,    //radius for cylinder
        segmentCount: Int,   // number of segment in cylinder
        color: UIColor)    // color of cylinder
    {
        super.init()
        
        //Calcul the height of our line
        let  height = v1.distance(receiver: v2)
        
        //set position to v1 coordonate
        position = v1
        
        //Create the second node to draw direction vector
        let nodeV2 = SCNNode()
        
        //define his position
        nodeV2.position = v2
        //add it to parent
        parent.addChildNode(nodeV2)
        
        //Align Z axis
        let zAlign = SCNNode()
        zAlign.eulerAngles.x = Float(Double.pi / 2)
        
        //create our cylinder
        let cylinder = SCNCylinder(radius: radius, height: CGFloat(height))
        cylinder.radialSegmentCount = segmentCount
        cylinder.firstMaterial?.diffuse.contents = color
        
        //Create node with cylinder
        let nodeWithCylinder = SCNNode(geometry: cylinder)
        nodeWithCylinder.position.y = -height / 2
        zAlign.addChildNode(nodeWithCylinder)
        
        //Add it to child
        addChildNode(zAlign)
        
        //set constrainte direction to our vector
        constraints = [SCNLookAtConstraint(target: nodeV2)]
    }
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

private extension SCNVector3{
    func distance(receiver:SCNVector3) -> Float{
        let xd = receiver.x - self.x
        let yd = receiver.y - self.y
        let zd = receiver.z - self.z
        let distance = Float(sqrt(xd * xd + yd * yd + zd * zd))
        
        if (distance < 0){
            return (distance * -1)
        } else {
            return (distance)
        }
    }
}
