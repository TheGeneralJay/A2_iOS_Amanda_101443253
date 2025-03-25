//
//  ProductTableViewController.swift
//  A2_iOS_Amanda_101443253
//
//  Created by Amanda Gurney on 2025-03-24.
//

import UIKit
import CoreData

class ProductTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var productTable: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Grab products.
    var products: [Product]?
    var filteringProducts: [Product] = []
    
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.showsCancelButton = true
        
        fetchData(context: context)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (searching) {
            return filteringProducts.count
        } else {
            return products?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell")
        
        if (searching) {
            let filtered = filteringProducts[indexPath.row]
            
            cell?.textLabel?.text = filtered.name
            cell?.detailTextLabel?.text = "Provider: \(filtered.provider ?? "N/A") \nDescription: \(filtered.productDescription ?? "N/A") \nPrice: \(filtered.price.formatted(.currency(code: "CAD")))"
        } else {
            if let products = products {
                let product = products[indexPath.row]
                
                cell?.textLabel?.text = "\(product.name ?? "N/A")"
                cell?.detailTextLabel?.text = "Provider: \(product.provider ?? "N/A") \nDescription: \(product.productDescription ?? "N/A") \nPrice: \(product.price.formatted(.currency(code: "CAD")))"
            }
        }
        
        return cell!
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var results:[Product] = []
        
        if let products = products {
            for product in products {
                let filter = searchText.lowercased()
                
                if let doesContainFilter = product.name?.lowercased().contains(filter) {
                    if (doesContainFilter) {
                        results.append(product)
                    }
                }
                
                // If search bar is empty, show everything.
                if (filter == "") {
                    results = products
                }
            }
            
            searching = true
            filteringProducts = results
        }
        productTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        
        searchBar.text = ""
        
        productTable.reloadData()
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
