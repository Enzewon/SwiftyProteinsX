//
//  NewsFeedCell.swift
//  NewsFeed
//
//  Created by Danil Vdovenko on 3/12/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import Foundation
import UIKit

class LigandsCell: BaseCell {
    
    var text: String? {
        didSet {
            if let ligandName = text {
                textView.text = ligandName
            }
        }
    }
    
    let textView: UILabel = {
        
        let textView = UILabel()
        
        textView.numberOfLines = 0
        textView.text = "Default"
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
        
    }()
    
    override func setupViews() {
        
        backgroundColor = UIColor.white
        
        addSubview(textView)
        
        addConstraintsWithFormat(format: "H:|-24-[v0]-24-|", views: textView)
        
        addConstraintsWithFormat(format: "V:|-8-[v0]-8-|", views: textView)
        
    }
    
}
