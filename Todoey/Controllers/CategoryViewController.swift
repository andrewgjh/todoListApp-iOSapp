//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Andrew Ho on 2022-11-17.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArr = [Category]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            
            self.categoryArr.append(newCategory)
            self.saveCategories()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        let category = categoryArr[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categoryArr[indexPath.row]
            }
        }
    }
    
    
    func loadCategories(){
        
       let request = Category.fetchRequest()
        do {
            categoryArr = try context.fetch(request)
            
        }catch {
            print("Error category fetching data \(error)")
        }
      
    }
    
    func saveCategories(){
        do{
            try context.save()
        }catch{
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    
    
   
}
