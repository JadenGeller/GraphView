//
//  ViewController.swift
//  GraphViewExample
//
//  Created by Jaden Geller on 1/23/16.
//  Copyright © 2016 Jaden Geller. All rights reserved.
//

import UIKit
import GraphView

let frame = CGRect(x: 100, y: 100, width: 80, height: 80)

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from red nib.
        let red: UIView = RoundedView()
        red.backgroundColor = .redColor()
        red.frame = frame
        
        let blue: UIView = RoundedView()
        blue.backgroundColor = .blueColor()
        blue.frame = frame
        
        let green: UIView = RoundedView()
        green.backgroundColor = .greenColor()
        green.frame = frame
        
        let cyan: UIView = RoundedView()
        cyan.backgroundColor = .cyanColor()
        cyan.frame = frame
        
        let purple: UIView = RoundedView()
        purple.backgroundColor = .purpleColor()
        purple.frame = frame
        
        let brown: UIView = RoundedView()
        brown.backgroundColor = .brownColor()
        brown.frame = frame
        
        let orange: UIView = RoundedView()
        
        orange.backgroundColor = .orangeColor()
        orange.frame = frame
        
        let gray: UIView = RoundedView()
        gray.backgroundColor = .grayColor()
        gray.frame = frame
        
        view = GraphView(graph: Graph(nodes: [red, blue, green, cyan, purple, brown, orange, gray], undirectedEdges: [(red,blue), (blue, green), (green, cyan), (purple, brown), (brown, red), (red, orange), (orange, gray), (cyan, gray)]))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

