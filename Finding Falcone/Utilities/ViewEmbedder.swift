//
//  ViewEmbedder.swift
//  Finding Falcone
//
//  Created by myMac on 16/07/18.
//  Copyright © 2018 Love. All rights reserved.
//

import Foundation
import UIKit

class ViewEmbedder {
    
    class func embed(
        parent:UIViewController,
        container:UIView,
        child:UIViewController,
        previous:UIViewController?){
        
        if let previous = previous {
            removeFromParent(vc: previous)
        }
        child.willMove(toParentViewController: parent)
        parent.addChildViewController(child)
        container.addSubview(child.view)
        child.didMove(toParentViewController: parent)
        let w = container.frame.size.width;
        let h = container.frame.size.height;
        child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
    
    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParentViewController: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    class func embed(withIdentifier id:String, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
        embed(
            parent: parent,
            container: container,
            child: vc,
            previous: parent.childViewControllers.first
        )
        completion?(vc)
    }
}
