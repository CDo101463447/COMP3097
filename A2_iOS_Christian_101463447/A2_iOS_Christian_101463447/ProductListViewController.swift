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
    @IBOutlet weak var addProductTapped: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        fetchProducts()
    }

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

        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            products = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Error fetching filtered data")
        }
    }
}
