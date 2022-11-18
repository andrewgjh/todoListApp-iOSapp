//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    
    
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
        
        //        let newItem = Item()
        //        newItem.title = "Find Mike"
        //        itemArray.append(newItem)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "Buy Eggos"
        //        itemArray.append(newItem2)
        //
        //        let newItem3 = Item()
        //        newItem3.title = "Destroy Demorgorgen"
        //        itemArray.append(newItem3)
        //
        //                loadItems()
        //        if let items = defaults.array(forKey: "ToDoListArr") as? [Item] {
        //            itemArray = items
        //        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.completed ? .checkmark : .none
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].completed = !itemArray[indexPath.row].completed
        
        saveItems()
        tableView.reloadData()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newTodeyItem = Item(context: self.context)
            newTodeyItem.title = textField.text!
            newTodeyItem.completed = false
            newTodeyItem.parentCategory = self.selectedCategory
            self.itemArray.append(newTodeyItem)
            
            self.saveItems()
            
            
            //            self.defaults.set(self.itemArray, forKey: "ToDoListArr")
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems () {
        do{
            try context.save()
        }catch{
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(with request:NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
            
        }catch {
            print("Error fetching data \(error)")
        }
        tableView.reloadData()
        
    }
    
    //    func saveItems(){
    //        let encoder = PropertyListEncoder()
    //
    //        do{
    //            let data = try encoder.encode(itemArray)
    //            try data.write(to: dataFilePath!)
    //        }
    //        catch{
    //            print("Encoding error found while trying to encode itemArray: \(error)")
    //        }
    //    }
    //
    //    func loadItems(){
    //        if let data = try? Data(contentsOf: dataFilePath!) {
    //            let decoder = PropertyListDecoder()
    //            do {
    //            itemArray = try decoder.decode([Item].self, from: data)
    //            } catch{
    //                print("Error decoding item array \(error)")
    //            }
    //        }
    //    }
    
    
}



extension TodoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
