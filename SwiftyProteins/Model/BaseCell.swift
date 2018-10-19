//
//  BaseCell.swift
//  Evento
//
//  Created by Danil Vdovenko on 2/26/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {

        super.init(frame: frame)
        
        setupViews()
        
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
