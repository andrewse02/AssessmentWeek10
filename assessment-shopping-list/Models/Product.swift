//
//  Product.swift
//  assessment-shopping-list
//
//  Created by Andrew Elliott on 3/25/22.
//

import Foundation

class Product: Codable {
    var name: String
    var quantity: Int
    var isChecked: Bool
    
    init(name: String, quantity: Int, isChecked: Bool = false) {
        self.name = name
        self.quantity = quantity
        self.isChecked = isChecked
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        guard lhs.name == rhs.name else { return false }
        guard lhs.quantity == rhs.quantity else { return false }
        guard lhs.isChecked == rhs.isChecked else { return false }
        
        return true
    }
}
