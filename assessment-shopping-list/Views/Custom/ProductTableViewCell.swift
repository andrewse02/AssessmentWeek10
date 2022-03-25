//
//  ProductTableViewCell.swift
//  assessment-shopping-list
//
//  Created by Andrew Elliott on 3/25/22.
//

import UIKit

protocol ProductActionDelegate: AnyObject {
    func productCellButtonTapped(sender: ProductTableViewCell)
}

class ProductTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var product: Product? {
        didSet {
            updateViews()
        }
    }
    weak var delegate: ProductActionDelegate?
    
    // MARK: - Outlets

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var checkedButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func checkedButtonTapped(_ sender: Any) {
        guard let delegate = delegate else { return }
        delegate.productCellButtonTapped(sender: self)
    }
    
    // MARK: - Helper Methods
    
    func updateViews() {
        guard let product = product else { return }
        
        nameLabel.text = product.name
        quantityLabel.text = "\(product.quantity)"
        checkedButton.setBackgroundImage(UIImage(named: product.isChecked ? "complete" : "incomplete"), for: .normal)
    }
}
