//
//  ViewController.swift
//  CodeDataDemo
//
//  Created by Amol Bombe on 25/02/17.
//  Copyright © 2017 Amol Bombe. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var peoples: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "The Name List"
        self.automaticallyAdjustsScrollViewInsets = false
        self.fetch()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    @IBAction func addNameTapped(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name", message: "Add New Name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            [unowned self] action in
            guard let nameTextField = alert.textFields?.first, let nameToSave = nameTextField.text else {
                return
            }
            guard let ageTextField = alert.textFields?.last, let ageToSave = ageTextField.text else {
                return
            }
            self.save(name: nameToSave, age: Int(ageToSave))
            self.fetch()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addTextField()
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true)
    }
    
    func save(name: String?, age: Int?) {
        let dataDictionary:[String: Any?] = ["name": name,
                              "age": age]
        CoreDataUtility.insertData(values: dataDictionary, entityName: "Person")
    }
    
    func fetch() {
        if let data = CoreDataUtility.fetchData(entityName: "Person") {
            peoples = data
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peoples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let people = peoples[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = people.value(forKeyPath: "name") as? String
        if let age = people.value(forKeyPath: "age") as? Int {
            cell.detailTextLabel?.text = String(age)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            let isDataDeleted = CoreDataUtility.deleteData(data: peoples[indexPath.row])
            if isDataDeleted {
                peoples.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            break
        default:
            break
        }
    }
}
