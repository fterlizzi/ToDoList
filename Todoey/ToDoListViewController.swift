//
//  ViewController.swift
//  Todoey
//
//  Created by Francesco Terlizzi on 10/08/2022.
//  Copyright © 2022 acRm net. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController, UITextFieldDelegate {

    var lista : [String] = ["Compra il latte", "Paga la rata di scuola", "Verifica Zalando"]
    var myalert = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

        


//MARK - tableview Datasource methods
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
        cell.accessoryType = . detailButton
           
       return cell
    }

//MARK - tableView Delegate methods
    
    // Respond to row selections : https://developer.apple.com/documentation/uikit/uitableviewdelegate/handling_row_selection_in_a_table_view
    // When the user taps a row, the table view calls the delegate method tableView(_:didSelectRowAt:)
    // a questo punto posso eseguire azioni 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row) \(lista[indexPath.row]) \n")
        // 3.2 evito di mostrare l'evidenziazione in grigio permanente rende + elegante la selezione
        tableView.deselectRow(at: indexPath, animated: true)
        
        //3.2 AccessoryType cell : https://developer.apple.com/documentation/uikit/uitableviewcell/accessorytype/checkmark
        // vedi anche qui : https://www.codegrepper.com/code-examples/swift/remove+checkmark+when+selecting+the+cell+again+swift+5
        // tableView.cellForRow restituisce un optional
        if let cellSafe = tableView.cellForRow(at: indexPath as IndexPath) {
            if cellSafe.accessoryType == .checkmark {
                cellSafe.accessoryType = .none
            } else {
                cellSafe.accessoryType = .checkmark
            }
        }
    }
    
    
 //MARK - Add new elements
 // 3.2 Aggiungo altri elementi nella lista
    // utilizzo UIAlertControlle che è una sottoclasse di UIViewController con un textfield da compilare . Una volta inserito il nuovo item sarà aggiunto alla lista o al db; per mostrarlo occorre seguire 3 steps : a) istanzio un UIAlertController con
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print(" button pressed")
        
        var tf = UITextField()
        
        // creo un alert object
        let alert : UIAlertController = UIAlertController.init(title: " Aggiungi un nuovo item alla lista", message: "", preferredStyle: .alert)
        self.myalert = alert
        // aggiungo un textfield all'alert teoricamente ne potrei aggiungere più di un textfield all'alert nella properti textfields che è un array
        alert.addTextField { alertTextField in
            alertTextField.keyboardType = .default // per i numeri avrei usato .numberPad
            alertTextField.placeholder = "Aggiungi un nuovo item alla lista"
            alertTextField.delegate = self
            // un textField è anche un UIControl quindi che si può agganciare ad esso la coppia target-action ad unserie di eventi tra cui Editing Changed
            // quindi posso intercettare l'evento ed ricevere la notifica quando l'utente inizia ad editare e quindi abilitare di conseguenza il tasto "Aggiungi Item"
            // per farlo devo attaccare un azione  ( una funzione) per l'evento di controllo che intendo ascoltare editingChanged . Il Control mantiene una dispatch table per ciscun evento di controllo , quindi molte azioni possono essere aggiunte allo stesso control event.
            // quando questo evento si verifica l'azione( la funzione)  associata viene eseguita
            alertTextField.addTarget(self, action: #selector(self.textChanged), for: UIControl.Event.editingChanged)
           
            tf = alertTextField
        }
        
        // aggiungo una action : ovvero si aggiunge un button "Aggiungi Item" nella dialog box  con una funzione (una closure ) o handler che sarà eseguita/o quando l'utente preme il pulsante .
        // il button handler dell'action  può accedere al textfield aggiunto all'alert attraverso la textField property che è un array
        let action = UIAlertAction(title: "Aggiungi item", style: .default) { action in
            // inserisco quello che accade quando l'utente preme add item
            // to log print(" dialog button pressed \(action.title!)")
            alert.preferredAction = alert.actions[0]
            
            tf = alert.textFields![0]
            
            // se il text del textfield è not empty aggiungo alla lista il valore e poi reload la tableview
            if let safeTxt = tf.text , safeTxt != ""  {
                self.lista.append(safeTxt)
                self.tableView.reloadData()
            }
            
        }
        // aggiungo due pulsanti Cancel se è premuto non accade nulla e quindi non aggiungo
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(action)
        
        //disabilito il pulsante Aggiungi Item finchè il contenuto del text field non diventa utile per inserimento ovvero non vuoto
        // il txtfield può avere un delegato oppure una coppia event -target
        alert.actions[1].isEnabled = false
        
        //print(alert.actions)
        self.present(alert,animated: true)
    }
    
    // Test if textField empty ; note that it was created disabled
    @objc func textChanged(_ sender: UITextField) {
          
        let tf  = sender // sender is a tetxtField
        myalert.actions[1].isEnabled = true
        print(myalert)
        print(type(of: tf))
       
        
        }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("EDITING")
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("END EDITING")
    }
     
}

