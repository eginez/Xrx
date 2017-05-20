//
//  BufferContent.swift
//  Xrx
//
//  Created by Esteban on 5/19/17.
//  Copyright © 2017 org.eginez. All rights reserved.
//

import Foundation

class BufferContent {
    
    var content: Set<String> = []
    var orderedView: [String] = []
    
    func insert(aString:String)  {
        if content.contains(aString) {
            return
        }
        content.insert(aString)
        orderedView.insert(aString, at: 0)
    }
    
    func getAt(position: Int) -> String {
        return orderedView[position]
    }
    
    func count() -> Int {
        return content.count
    }
}
