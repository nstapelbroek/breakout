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
        addPaddle()
    }

    let bricksPerRow = 4
    let numberOfRows = 6
    let brickPadding = 5
    var paddle: PaddleView?
    
    var brickSize: CGSize {
        let width = (gameView.bounds.size.width / CGFloat(bricksPerRow)) - CGFloat(2 * brickPadding )
        let height = (gameView.bounds.size.height / 3 / CGFloat(numberOfRows)) - (2 * CGFloat(brickPadding))
        return CGSize(width: width, height: height)
    }

    func addPaddle() {
        let width = gameView.bounds.size.width / 5
        let height = gameView.bounds.size.height / 30
        let size = CGSize(width: width, height: height)
        let x = (gameView.bounds.size.width + width) / 2
        let y = gameView.bounds.size.height - (2 * height)
        let origin = CGPoint(x: x, y: y)

        paddle = PaddleView(frame: CGRect(origin: origin, size: size))
        paddle?.backgroundColor = UIColor.blackColor()
        gameView.addSubview(paddle!)
    }
    
    func addBricks() {
        for var rowNumber = 0; rowNumber < numberOfRows; rowNumber++ {
            addRow(rowNumber)
        }
    }
    
    func addRow(rowNumber: Int) {
        let size = brickSize
        for var brickNumber = 0; brickNumber < bricksPerRow; brickNumber++ {
            let x = (CGFloat(brickNumber) * (size.width + (2 * CGFloat(brickPadding)))) + CGFloat(brickPadding)
            let y = (CGFloat(rowNumber) * (size.height + (2 * CGFloat(brickPadding)))) + CGFloat(brickPadding)
            let origin = CGPoint(x: x, y: y)
            let brick = BrickView(frame: CGRect(origin: origin, size: size))
            brick.backgroundColor = UIColor.random
            gameView.addSubview(brick)
        }
    }
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

