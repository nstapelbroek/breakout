//
//  BezierPathsView.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

@IBDesignable
class BreakoutView: UIView {
    
    private let levels = [
        "1,1,1,1:" +
        "1,1,1,1:" +
        "1,1,1,1:" +
        "1,1,1,1:" +
        "1,1,1,1:" +
        "1,1,1,1:",
        
        "2,2,2,2:" +
        "1,1,1,1:" +
        "2,2,2,2:" +
        "1,1,1,1:" +
        "2,2,2,2:" +
        "1,1,1,1:",
        
        "0,1,2,1,0:" +
        "1,0,1,0,1:" +
        "2,1,2,1,2:" +
        "1,2,1,2,1:" +
        "2,0,2,0,2:" +
        "0,1,2,1,0:",
        
        "2,2,2,2,2:" +
        "2,2,2,2,2:" +
        "2,2,2,2,2:" +
        "2,2,2,2,2:" +
        "2,2,2,2,2:" +
        "2,2,2,2,2:",
        
        "3,3,3,3,3:" +
        "3,2,2,2,3:" +
        "3,2,3,2,3:" +
        "3,2,3,2,3:" +
        "3,2,2,2,3:" +
        "3,3,3,3,3:"
    ]

    private var bezierPaths = [String:UIBezierPath]()
    
    var bricksPerRow: Int?
    var numberOfRows: Int?
    let brickPadding = 5
    var currentLevel = 0
    var breakoutBehavior: BreakoutBehavior?
    var bricks = [Int:BrickView]()
    
    var brickSize: CGSize {
        let width = (self.bounds.size.width / CGFloat(bricksPerRow!)) - CGFloat(2 * brickPadding )
        let height = (self.bounds.size.height / 3 / CGFloat(numberOfRows!)) - (2 * CGFloat(brickPadding))
        return CGSize(width: width, height: height)
    }
    
    func setPath(path: UIBezierPath?, named name: String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }
    
    override func drawRect(rect: CGRect) {
        for(_, path) in bezierPaths {
            path.stroke()
        }
    }
    
    func addBricks() {
        var rows = split(self.levels[self.currentLevel]) {$0 == ":"}
        self.numberOfRows = rows.count
        for var rowNumber = 0; rowNumber < self.numberOfRows!; rowNumber++ {
            addRow(rowNumber, rowString: rows[rowNumber])
        }
    }
    
    func addRow(rowNumber: Int, rowString: String) {
        let brickInfo = split(rowString) {$0 == ","}
        self.bricksPerRow = brickInfo.count
        let size = self.brickSize
        
        for var brickNumber = 0; brickNumber < brickInfo.count; brickNumber++ {
            if brickInfo[brickNumber] != "0" {
                let x = (CGFloat(brickNumber) * (size.width + (2 * CGFloat(brickPadding)))) + CGFloat(brickPadding)
                let y = (CGFloat(rowNumber) * (size.height + (2 * CGFloat(brickPadding)))) + CGFloat(brickPadding)
                let origin = CGPoint(x: x, y: y)
                let brick = BrickView(frame: CGRect(origin: origin, size: size), health: brickInfo[brickNumber].toInt()!)
                
                let brickId = brickNumber + (brickInfo.count * rowNumber)
                bricks[brickId] = brick
                breakoutBehavior!.addBarrier(UIBezierPath(roundedRect: brick.frame, cornerRadius: 0), named: brickId)
                self.breakoutBehavior!.addBrick(brick)
            }
        }
    }
    
    func removeBricks() {
        for var i = 0; i < self.numberOfRows! * self.bricksPerRow!; i++ {
            if let brick = self.bricks[i] {
                brick.removeFromSuperview()
                self.breakoutBehavior!.removeBrick(brick)
                self.breakoutBehavior!.removeBarrier(named: i)
            }
        }
        
        if self.bricks.count > 0 {
            self.bricks.removeAll(keepCapacity: true)
        }
    }
    
    func removeBrickAtIndex(index: Int) {
        if let brick = bricks[index] {
            breakoutBehavior!.removeBrick(brick)
            breakoutBehavior!.removeBarrier(named: index)
        }
    }
}
