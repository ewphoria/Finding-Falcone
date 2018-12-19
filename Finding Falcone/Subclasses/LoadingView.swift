//
//  LoadingView.swift
//  Finding Falcone
//
//  Created by myMac on 14/07/18.
//  Copyright © 2018 Love. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    enum State {
        case noData
        case loading
        case notConnected
    }
    
    var lblMessage = UILabel()
    var imgVwIcon = UIImageView(image: UIImage(named: "falcone"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private func setMessage(_ message : String) -> Void {
        lblMessage.text = message
    }
    
    private func createViews() -> Void {
      
        imgVwIcon.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imgVwIcon)
        imgVwIcon.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imgVwIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        lblMessage.text = "Searching space..."
        if let labelFont = UIFont.init(name: "Poppins", size: 14.0) {
            lblMessage.font = labelFont
        }
        lblMessage.textColor = UIColor.white
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblMessage)

        lblMessage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        lblMessage.topAnchor.constraint(equalTo: imgVwIcon.bottomAnchor).isActive = true
    }
    
    func setError(_ error : String) -> Void {
        setMessage(error)
    }
    
    func setState(_ state : State) -> Void {
        
        switch state {
            
        case .noData:
            setMessage("No planets found!")
            break
            
        case .loading:
            setMessage("Searching space...")
            break
            
        case .notConnected:
            setMessage("Unable to reach the outer world! Check your internet.")
            break

        }
    }
    
    
}
