//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sumit Nihalani on 01/02/18.
//  Copyright © 2018 Sumit Nihalani. All rights reserved.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {

    var categoryArray = [Categoryy]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name

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
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
 //MARK:- DATA manipulation method
    func saveCategories(){
        
        do{
            try context.save()
        } catch{
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(with request: NSFetchRequest<Categoryy> = Categoryy.fetchRequest()){
        //with -> external param, request -> internal param with default value
        do{
            categoryArray = try context.fetch(request)
        } catch{
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
 
 //MARK: - add new categories
 
    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //let context = AppDelegate().persistentContainer.viewContext
            
            let newItem = Categoryy(context: self.context)
            newItem.name = textField.text!
            self.categoryArray.append(newItem)
            self.saveCategories()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create an item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
