//
//  GradientView.swift
//  TaxiCramea
//
//  Created by жека on 12.06.17.
//  Copyright © 2017 админ. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

    @IBInspectable var FirstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var SecondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    func updateView() {
        let layer = self.layer as!CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
    }

}
