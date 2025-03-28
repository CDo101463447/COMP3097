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
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    
    var products: [Product] = []
    var currentIndex = 0  // Track the current product
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        fetchProducts()
        
        if !products.isEmpty {
            displayProductAtIndex(index: currentIndex)
        }
        updateNavigationButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchProducts()
    }

    func fetchProducts() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            products = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching data: \(error)")
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = products[indexPath.row]

        if let productNameLabel = cell.viewWithTag(1) as? UILabel,
           let productDescriptionLabel = cell.viewWithTag(2) as? UILabel,
           let productPriceLabel = cell.viewWithTag(3) as? UILabel,
           let productProviderLabel = cell.viewWithTag(4) as? UILabel {

            productNameLabel.text = product.productName
            productDescriptionLabel.text = product.productDescription
            productPriceLabel.text = "$\(product.productPrice?.stringValue ?? "0.00")"
            productProviderLabel.text = product.productProvider ?? "Unknown"
        }

        return cell
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            fetchProducts()
        } else {
            filterProducts(searchText: searchText)
        }
    }

    func filterProducts(searchText: String) {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "productName CONTAINS[cd] %@ OR productDescription CONTAINS[cd] %@", searchText, searchText)

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            products = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching filtered data: \(error)")
        }
    }

    func displayProductAtIndex(index: Int) {
        guard index >= 0, index < products.count else { return }
        
        let indexPath = IndexPath(row: index, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        updateNavigationButtons()
    }

    func updateNavigationButtons() {
        previousButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = currentIndex < products.count - 1
    }

    // MARK: - Show product details in an alert
    func showProductDetails(product: Product) {
        let alertController = UIAlertController(title: product.productName, message: """
            Description: \(product.productDescription ?? "No description available.")
            Price: $\(product.productPrice?.stringValue ?? "0.00")
            Provider: \(product.productProvider ?? "Unknown")
        """, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alertController, animated: true, completion: nil)
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        showProductDetails(product: product)
    }

    @IBAction func previousProductTapped(_ sender: UIButton) {
        if currentIndex > 0 {
            currentIndex -= 1
            displayProductAtIndex(index: currentIndex)
        }
    }

    @IBAction func nextProductTapped(_ sender: UIButton) {
        if currentIndex < products.count - 1 {
            currentIndex += 1
            displayProductAtIndex(index: currentIndex)
        }
    }
}
