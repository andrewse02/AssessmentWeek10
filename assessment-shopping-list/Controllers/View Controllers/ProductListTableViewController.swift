//
//  ProductListTableViewController.swift
//  assessment-shopping-list
//
//  Created by Andrew Elliott on 3/25/22.
//

import UIKit

class ProductListTableViewController: UITableViewController {
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        ProductController.shared.loadFromPersistentStorage()
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "New Product", message: "Enter the name here", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Product name..."
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            guard let alert = alert,
                  let textFields = alert.textFields,
                  let text = textFields[0].text else { return }
            ProductController.shared.createProduct(name: text)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductController.shared.products.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductTableViewCell else { return UITableViewCell() }

        cell.delegate = self
        cell.product = ProductController.shared.products[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Quantity") { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            
            let alert = UIAlertController(title: "Change Quantity", message: "Enter the new quantity here", preferredStyle: .alert)
            
            alert.addTextField { (textField) in
                textField.placeholder = "Quantity..."
            }
            
            let doneAction = UIAlertAction(title: "Done", style: .default, handler: { [weak alert] (_) in
                guard let alert = alert,
                      let textFields = alert.textFields,
                      let text = textFields[0].text else { return }
                ProductController.shared.updateProduct(at: indexPath.row, quantity: Int(text))
                self.tableView.reloadData()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addAction(doneAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true)
        }
        
        action.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            ProductController.shared.deleteProduct(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let productToMove = ProductController.shared.products[fromIndexPath.row]
        
        ProductController.shared.products.remove(at: fromIndexPath.row)
        ProductController.shared.products.insert(productToMove, at: to.row)
        
        ProductController.shared.saveToPersistentStorage()
    }


    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ProductListTableViewController: ProductActionDelegate {
    func productCellButtonTapped(sender: ProductTableViewCell) {
        guard let product = sender.product else { return }
        ProductController.shared.toggleChecked(product: product)
        
        sender.updateViews()
    }
}
