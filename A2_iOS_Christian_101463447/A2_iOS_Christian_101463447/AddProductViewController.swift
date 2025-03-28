//
//  AddProductViewController.swift
//  A2_iOS_Christian_101463447
//
//  Created by Christian Do on 2025-03-27.
//

import UIKit
import CoreData

class AddProductViewController: UIViewController {

    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescriptionTextField: UITextField!
    @IBOutlet weak var productPriceTextField: UITextField!
    @IBOutlet weak var productProviderTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Save the new product
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // Validate that all fields are filled in
        guard let productName = productNameTextField.text, !productName.isEmpty,
              let productDescription = productDescriptionTextField.text, !productDescription.isEmpty,
              let productPriceText = productPriceTextField.text, !productPriceText.isEmpty,
              let productProvider = productProviderTextField.text, !productProvider.isEmpty else {
                  print("Please fill in all fields correctly")
                  return
        }

        // Validate the product price as a valid number
        guard let productPrice = Decimal(string: productPriceText) else {
            print("Invalid price format")
            return
        }

        // Create a new Product object
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newProduct = Product(context: context)
        newProduct.productName = productName
        newProduct.productDescription = productDescription
        newProduct.productPrice = NSDecimalNumber(decimal: productPrice)
        newProduct.productProvider = productProvider

        // Save the new product to Core Data
        do {
            try context.save()
            print("Product added successfully!")
            // Dismiss the view controller and go back to ProductListViewController
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Failed to save product: \(error)")
        }
    }

    // Cancel button to dismiss the Add Product screen
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
