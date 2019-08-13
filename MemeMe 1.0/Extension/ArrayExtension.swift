//
//  ArrayExtension.swift
//  MemeMe 1.0
//
//  Created by Paul Forstner on 24.06.19.
//  Copyright © 2019 Udacity. All rights reserved.
//


import UIKit

public extension Array {
    
    /// Element at the given index if it exists.
    ///
    /// - Parameter index: index of element.
    /// - Returns: optional element (if exists).
    func item(at index: Int) -> Element? {
        
        if 0..<self.count ~= index {
            return self[index]
        }
        
        return nil
    }
}
