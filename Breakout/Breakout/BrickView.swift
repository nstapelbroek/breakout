//
//  DropView.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class BrickView: UIView {
    
    private var size: CGSize?
    
    private var origin: CGPoint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.size = frame.size
        self.origin = frame.origin
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
}