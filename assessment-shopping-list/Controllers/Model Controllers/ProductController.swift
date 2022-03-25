//
//  ProductController.swift
//  assessment-shopping-list
//
//  Created by Andrew Elliott on 3/25/22.
//

import UIKit

class ProductController {
    // MARK: - Properties
    
    static let shared = ProductController()
    var products: [Product] = []
    
    // MARK: - CRUD Methods
    
    func createProduct(name: String, quantity: Int = 1, isChecked: Bool = false) {
        for product in products {
            if product.name == name {
                updateProduct(product, quantity: product.quantity + 1)
                return
            }
        }
        
        let newProduct = Product(name: name, quantity: quantity, isChecked: isChecked)
        products.append(newProduct)
        
        saveToPersistentStorage()
    }
    
    func updateProduct(_ product: Product, name: String? = nil, quantity: Int? = nil, isChecked: Bool? = nil) {
        guard let index = products.firstIndex(of: product) else { return }
        let foundProduct = products[index]
        
        foundProduct.name = name ?? foundProduct.name
        foundProduct.quantity = quantity ?? foundProduct.quantity
        foundProduct.isChecked = isChecked ?? foundProduct.isChecked
        
        saveToPersistentStorage()
    }
    
    func updateProduct(at index: Int, name: String? = nil, quantity: Int? = nil, isChecked: Bool? = nil) {
        guard products.indices.contains(index) else { return }
        let foundProduct = products[index]
        
        foundProduct.name = name ?? foundProduct.name
        foundProduct.quantity = quantity ?? foundProduct.quantity
        foundProduct.isChecked = isChecked ?? foundProduct.isChecked
        
        saveToPersistentStorage()
    }
    
    func toggleChecked(product: Product) {
        guard let index = products.firstIndex(of: product) else { return }
        products[index].isChecked = !products[index].isChecked
        
        saveToPersistentStorage()
    }
    
    func toggleChecked(at index: Int) {
        guard products.indices.contains(index) else { return }
        products[index].isChecked = !products[index].isChecked
        
        saveToPersistentStorage()
    }
    
    func deleteProduct(_ product: Product) {
        guard let index = products.firstIndex(of: product) else { return }
        products.remove(at: index)
        
        saveToPersistentStorage()
    }
    
    func deleteProduct(at index: Int) {
        guard products.indices.contains(index) else { return }
        products.remove(at: index)
        
        saveToPersistentStorage()
    }
    
    // MARK: - Persistence Methods
    
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectoryURL = urls[0].appendingPathComponent("ShoppingList.json")
        return documentsDirectoryURL
    }
    
    func saveToPersistentStorage() {
        let je = JSONEncoder()
        
        do {
            let data = try je.encode(self.products)
            try data.write(to: self.fileURL())
        } catch {
            print(error)
        }
    }
    
    func loadFromPersistentStorage() {
        do {
            let data = try Data(contentsOf: self.fileURL())
            let jd = JSONDecoder()
            
            let products = try jd.decode([Product].self, from: data)
            self.products = products
        } catch {
            print(error)
        }
    }
}
