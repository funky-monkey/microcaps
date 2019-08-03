//
//  NSViewExtension.swift
//  Microcaps
//
//  Created by Sidney de Koning on 12/03/2018.
//  Copyright © 2018 Funky Monkey. All rights reserved.
//

import Foundation
import AppKit

extension NSView {
    
    var backgroundColor: NSColor? {
        
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
}
