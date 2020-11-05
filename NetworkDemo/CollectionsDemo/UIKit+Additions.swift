//
//  UIKit+Additions.swift
//  CollectionsDemo
//
//  Created by a.dirsha on 19.10.2020.
//

import UIKit

final class BlockTapGestoreRecoginizer: UITapGestureRecognizer {
    private let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
        
        super.init(target: nil, action: nil)
        
        self.addTarget(self, action: #selector(onTap))
    }
    
    @objc
    private func onTap() {
        self.action()
    }
}
