//
//  ViewController.swift
//  Todoey
//
//  Created by Sumit Nihalani on 31/01/18.
//  Copyright © 2018 Sumit Nihalani. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var todoItems : Results<Item>?
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    var selectedCategory : Categoryy? {
        didSet{
            //print("DID set")
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //searchBar.delegate = self
        print(filePath)

    }

    //MARK - Tableview data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            if todoItems![indexPath.row].done == true {
                cell.accessoryType = .checkmark
            }
            else {
                cell.accessoryType = .none
            }
        } else {
            cell.textLabel?.text = "No item added"
        }
        
        return cell
    }

    //MARK - Tableview delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                    //realm.delete(item)
                }
            }catch{
                print("Error updating done value")
            }
        }
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) // so that it doesn't remain highlighted
    }
    
    //MARK - add item in list
    @IBAction func addPressedButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //let context = AppDelegate().persistentContainer.viewContext
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print("Error saving new items \(error)")
                }
                
            }
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create an item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    //MARK:- DATA manipulation method
 
    
    func loadItems(){
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
  }
}

extension TodoListViewController : UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)

        tableView.reloadData()


    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
 }

