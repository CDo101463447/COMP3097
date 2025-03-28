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

    @IBOutlet weak var addProductTapped: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self  // Add this
        tableView.dataSource = self  // Add this
        fetchProducts()
    }

    // Fetch the products from Core Data
    func fetchProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            products = try context.fetch(fetchRequest)
            print("Fetched products: \(products)")
            tableView.reloadData()
        } catch {
            print("Error fetching data")
        }
    }

    // Reload data when returning to the view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts() // Refresh the product list when returning to this screen
    }

    // Table view delegate and data source methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of products: \(products.count)")  // Debugging line
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)

        // Get the product for the current index path
        let product = products[indexPath.row]

        // Find the labels in the cell (assuming you have outlets for them)
        if let productNameLabel = cell.viewWithTag(1) as? UILabel,
           let productDescriptionLabel = cell.viewWithTag(2) as? UILabel {
            // Assign the product name and description to the labels
            productNameLabel.text = product.productName
            productDescriptionLabel.text = product.productDescription
        }

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

    // Function to add 10 sample products to Core Data
    func addSampleProducts() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Check if there are already products in Core Data, if not, add sample products
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            let existingProducts = try context.fetch(fetchRequest)
            if existingProducts.isEmpty {  // Only add if no products exist
                for i in 1...10 {
                    let product = Product(context: context)
                    product.productName = "Product \(i)"
                    product.productDescription = "Description for product \(i)"
                    // Wrap the Double value in NSDecimalNumber
                    product.productPrice = NSDecimalNumber(value: Double(i * 10))
                }
                try context.save()  // Save the new products to Core Data
            }
        } catch {
            print("Failed to add sample products: \(error)")
        }
    }

}
