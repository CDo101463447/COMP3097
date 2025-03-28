//
//  ProductListViewController.swift
//  A2_iOS_Christian_101463447
//
//  Created by Christian Do on 2025-03-27.
//

import Foundation
import UIKit
import CoreData

class ProductListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var addProductTapped: UIButton! // UIButton for adding a product
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchProducts()
        addProductTapped.addTarget(self, action: #selector(addProductButtonTapped), for: .touchUpInside)
    }

    // Action when Add Product button is tapped
    @objc func addProductButtonTapped() {
        let addProductVC = AddProductViewController() // Create the AddProductViewController
        let navigationController = UINavigationController(rootViewController: addProductVC) // Embed in navigation controller
        self.present(navigationController, animated: true, completion: nil) // Present modally (you can also push if using a nav controller)
    }

    // Fetch the products from Core Data
    func fetchProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            products = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching data")
        }
    }

    // Table view delegate and data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = products[indexPath.row]
        cell.textLabel?.text = product.productName
        cell.detailTextLabel?.text = product.productDescription
        return cell
    }

    // Search functionality to filter products
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchProducts()
        } else {
            filterProducts(searchText: searchText)
        }
    }

    // Filter the products based on search text
    func filterProducts(searchText: String) {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productName CONTAINS[cd] %@ OR productDescription CONTAINS[cd] %@", searchText, searchText)

        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            products = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching filtered data")
        }
    }
}
