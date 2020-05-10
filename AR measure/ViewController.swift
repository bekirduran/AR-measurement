//
//  ViewController.swift
//  AR measure
//
//  Created by Bekir Duran on 9.05.2020.
//  Copyright © 2020 info. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var dotNode = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if dotNode.count >= 2 {
            for dot in dotNode {
                dot.removeFromParentNode()
            }
            dotNode = [SCNNode]()
        }
        
        if let touchLocation = touches.first?.location(in: sceneView){
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
        }
    }
    func addDot(at hitResult:ARHitTestResult){

        let dot = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dot.materials = [material]
        let myDotnode = SCNNode(geometry: dot)
        myDotnode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(myDotnode)
        dotNode.append(myDotnode)
        
        if dotNode.count >= 2 {
            calculate()
        }
    }

    func calculate(){
        let startPoint = dotNode[0]
        let endPoint = dotNode[1]

        let distance = sqrt(
            pow(endPoint.position.x - startPoint.position.x, 2) +
            pow(endPoint.position.y - startPoint.position.y, 2) +
            pow(endPoint.position.z - startPoint.position.z, 2)
            )
        showScreenDistance(text: "\(abs(distance * 100))", Positon: endPoint.position)
    }
    
    func showScreenDistance (text input:String, Positon at:SCNVector3){
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: input, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(at.x, at.y + 0.1, at.z)
        textNode.scale = SCNVector3(0.005, 0.005, 0.005)
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
}
