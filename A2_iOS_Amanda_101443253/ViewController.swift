//
//  ViewController.swift
//  A2_iOS_Amanda_101443253
//
//  Created by Amanda Gurney on 2025-03-24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    // Array of each text field.
    @IBOutlet var textFields: [UITextField]!
    
    var products: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func addProduct(_ sender: UIBarButtonItem) {
        // Take user input or fill in default values if left blank.
        let name = textFields[0].text ?? "N/A"
        let productDesc = textFields[1].text ?? "N/A"
        let price = textFields[2].text ?? "0.00"
        let provider = textFields[3].text ?? "N/A"
        
        // Grab core data context.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Add user given values to product object.
        let product = Product(context: context)
        product.id = UUID()
        product.name = name
        product.productDescription = productDesc
        product.price = Float(price) ?? 0
        product.provider = provider
        
        // Append the new product to the products array.
        products?.append(product)
        
        // Save this to the DB.
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    // Function to save info to DB.
    @objc func saveToDB() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            try context.save()
        } catch {
            print("ERROR: There was an error while trying to save the product to the DB.")
            print("\(error.localizedDescription)")
        }
    }
    
}

