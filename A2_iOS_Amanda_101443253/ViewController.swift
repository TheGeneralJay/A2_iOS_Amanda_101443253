//
//  ViewController.swift
//  A2_iOS_Amanda_101443253
//
//  Created by Amanda Gurney on 2025-03-24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    // Make context available here.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // Array of each text field.
    @IBOutlet var textFields: [UITextField]!
    
    var products: [Product]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(context: context)
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
        saveToDB(context: context)
    }
    
    // Passing data to table view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let productTable = segue.destination as? ProductTableViewController
        
        productTable?.products = products
    }
    
    
    // Function to save info to DB.
    @objc func saveToDB(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("INFO: Product successfully saved to the DB.")
        } catch {
            print("ERROR: There was an error while trying to save the product to the DB.")
            print("\(error.localizedDescription)")
        }
    }
    
    func fetchData(context: NSManagedObjectContext) {
        // Fetch list of all products when application loads.
        products = [Product]()
        
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            products = try context.fetch(request)
            
            print("INFO: Products successfully fetched.")
        } catch {
            print("ERROR: There was an error while trying to fetch the products in the DB.")
            print("\(error.localizedDescription)")
        }
    }
    
}

