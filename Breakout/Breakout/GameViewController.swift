//
//  ViewController.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameView: BezierPathsView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addBricks()
    }
    
    let bricksPerRow = 10
    let numberOfRows = 2
    
    func addBricks() {
        for var rowNumber = 0; rowNumber < numberOfRows; rowNumber++ {
            addRow(rowNumber)
        }
    }
    
    
    func addRow(rowNumber: Int) {
        let brickWidth = gameView.bounds.size.width / CGFloat(bricksPerRow)
        let brickHeight = brickWidth
        for var brickNumber = 0; brickNumber < bricksPerRow; brickNumber++ {
            let x = CGFloat(brickNumber) * brickWidth
            let y = CGFloat(rowNumber) * brickHeight
            let origin = CGPoint(x: x, y: y)
            let brick = BrickView(frame: CGRect(origin: origin, size: CGSize(width: brickWidth, height: brickHeight)))
            brick.backgroundColor = UIColor.random
            gameView.addSubview(brick)
        }
    }
    
//
//    let bricksPerRow = 4
//    let numberOfRows = 3
//    let brickPadding = 5
//    
//    var brickSize: CGSize {
//        let width = (gameView.bounds.size.width / CGFloat(bricksPerRow)) - CGFloat(2 * brickPadding )
//        let height = (gameView.bounds.size.height / 2 / CGFloat(numberOfRows)) - (2 * CGFloat(brickPadding))
//        return CGSize(width: width, height: height)
//    }
//    
//    //Call this in viewDidLoad()
//    func addBricks() {
//        for var rowNumber = 0; rowNumber < numberOfRows; rowNumber++ {
//            addRow(rowNumber)
//        }
//    }
//    
//    func addRow(rowNumber: Int) {
//        let size = brickSize
//        for var brickNumber = 0; brickNumber < bricksPerRow; brickNumber++ {
//            let x = (CGFloat(brickNumber) * (size.width + (2 * CGFloat(brickPadding)))) + CGFloat(brickPadding)
//            let y = (CGFloat(rowNumber) * (size.height + (2 * CGFloat(brickPadding)))) + CGFloat(brickPadding)
//            let origin = CGPoint(x: x, y: y)
//            let brick = BrickView(frame: CGRect(origin: origin, size: size))
//            brick.backgroundColor = UIColor.random
//            gameView.addSubview(brick)
//        }
//    }
}

private extension CGFloat {
    static func random(max: Int) -> CGFloat {
        return CGFloat(arc4random() % UInt32(max))
    }
}

private extension UIColor {
    class var random: UIColor {
        switch arc4random()%5 {
        case 0: return UIColor.greenColor()
        case 1: return UIColor.blueColor()
        case 2: return UIColor.orangeColor()
        case 3: return UIColor.redColor()
        case 4: return UIColor.purpleColor()
        default: return UIColor.blackColor()
        }
    }
}

