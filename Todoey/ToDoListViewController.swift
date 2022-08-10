//
//  ViewController.swift
//  Todoey
//
//  Created by Francesco Terlizzi on 10/08/2022.
//  Copyright © 2022 acRm net. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var lista : [String] = ["Compra il latte", "Paga la rata di scuola", "Verifica Zalando"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

        


// MARK - Datasource
// i dati della tableview vengono dal dataource un oggetto indicato dalla proprietà datasource : in questo caso è self
// il datasource è un set di metodi che la tableview chiamerà quando necessita di informazioni ; il datasource non sa quando e quanto spesso  questi metodi saranno chiamati

    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count
    }

    // Provide a cell object for each row.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
       
       // Configure the cell’s contents.
        cell.textLabel!.text = lista[indexPath.row]
           
       return cell
    }

    
}
