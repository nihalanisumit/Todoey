//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sumit Nihalani on 01/02/18.
//  Copyright © 2018 Sumit Nihalani. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {

    let real = try! Realm()
    
    var categoryArray : Results<Categoryy>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added"

        // Configure the cell...

        return cell
    }
    
    //MARK:- Table view delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToitems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
    
 //MARK:- DATA manipulation method
    func save(category : Categoryy){
        
        do{
            try real.write {
                real.add(category)
            }
        } catch{
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        categoryArray = real.objects(Categoryy.self)
        tableView.reloadData()
    }
 
 //MARK: - add new categories
 
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //let context = AppDelegate().persistentContainer.viewContext
            
            let newItem = Categoryy()
            newItem.name = textField.text!
            //self.categoryArray.append(newItem) Result dataset is automatic appending
            self.save(category: newItem)
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create an item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
