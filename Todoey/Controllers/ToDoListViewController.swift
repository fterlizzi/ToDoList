//
//  ViewController.swift
//  Todoey
//
//  Created by Francesco Terlizzi on 10/08/2022.
//  Copyright © 2022 acRm net. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController, UITextFieldDelegate {

    var lista : [Item] = [Item]() //[String]  = ["Compra il latte", "Paga la rata di scuola", "Verifica Zalando","a" ,"b", "c","a" ,"b", "c","x" ,"y", "z","s5", "c2","x0" ,"y1","a1" ,"b2", "3c","4a" ,"6b",]
    var myalert = UIAlertController()
    var defaults = UserDefaults.standard // 3.3 creazione di persistent memory storage ( archiviazione permanente )  nella sandbox
    
    // 3.4 creazione del file Items.plist per la memorizzazione di un array di oggetti non basic
    // create a path for local database. I use FileManager to work with files and directories on iOS. It's a Swift API that helps you read from, and write to, various data and file formats.
    // FileManager è un interfaccia per il file system di iPhone. In breve, si usa FileManager per ottenere il percorso dei file sull'iPhone a cui ha accesso la tua app iOS. Puoi quindi utilizzare quel percorso per leggere il file o scriverci, a seconda delle esigenze della tua app. Puoi anche usare FileManager per lavorare con le directory.
    // 1. Le app su iOS sono vincolate a una sandbox, il che significa che non hanno accesso a file e risorse di sistema. Questa è una misura di sicurezza.
    // 2. I file su iOS hanno un percorso, ma di solito lavori solo con un oggetto URL che contiene quel percorso. Raramente lavori direttamente con i percorsi.
    // 3. In genere leggi/scrivi i file dell'app in alcune directory designate, come la directory dei documenti dell'app o dall'app bundle.
    // Il componente FileManager funge da wrapper sopra il file system. Lo si  usa per ottenere un riferimento a un file. Ecco un esempio:
    
     //let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("todos.txt")
    //  Abbiamo creato solo un riferimento a un file todos.txt nella directory dei documenti dell'app.  Il file effettivo viene salvato sull'iPhone in:
    // il documento è salvato file:///var/mobile/Containers/Data/Application//Documents/todos.txt
    // urls restituisce un array di URL
   
    // creo un riferimento al file Items.plist. FileManager.default è un oggetto unico condifviso per l'app . Non possiamo ottenere alcun file arbitrario da iOS, quindi dovremo utilizzare un punto di partenza: la directory dei documenti. Qui è dove si memorizzano i documenti utente, ovvero i file che l'utente della tua app desidera salvare.
    let datafilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(" data file path \(datafilePath!)")
        
        // Do any additional setup after loading the view.
        // 3.3 carico il defaults array da plist
        let items =  defaults.array(forKey: K.toDoListArrayforDefaults) as? [Item] // Returns the array associated with the specified key or nil if the key does not exist or its value is not an array.
        print(items)
        if let safeItems = items {
            lista = safeItems
        }
        
        
        let currentDevice = UIDevice.current.identifierForVendor!.uuidString
        print(" current device \(currentDevice) \n")
        if let storedDevice = defaults.string(forKey: "currentDevice") {
            if storedDevice == currentDevice {
                print(" can proceed because your storedDevice is \(storedDevice)")
            } else {
                print("STOP")
            }
        } else {
            self.defaults.set(currentDevice, forKey: "currentDevice")
        }
        
        
        var currentModelName = self.machineName()
        if currentModelName == "i386" || currentModelName == "x86_64" {
          print(" ** model name is a XCode Simulator")
            currentModelName = "Simulator"
        } else {
            print(" ** your model is \(currentModelName)")
        }
        if let storedModelName = defaults.string(forKey: "modelName"){
            if storedModelName  == currentModelName {
             print(" il modello in db coincide con quello che stai usando in questo momento \(storedModelName) : puoi procedere")
            } else{
                print(" il modello in db NON coincide con quello che stai usando in questo momento \(storedModelName) : puoi procedere")
            }
                
        } else {
            self.defaults.set(currentModelName, forKey: "modelName")
        }
        
    }

        


//MARK - tableview Datasource methods
// i dati della tableview vengono dal dataource un oggetto indicato dalla proprietà datasource : in questo caso è self
// il datasource è un set di metodi che la tableview chiamerà quando necessita di informazioni ; il datasource non sa quando e quanto spesso  questi metodi saranno chiamati

    // Return the number of rows for the table.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count
    }

    // Provide a cell object for each row.
    // cellfor è richiamata ogni vlta che viene fatto il reload della TV quindi per ogni item
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("cellForRowAt")
        
       // Fetch a cell of the appropriate type. La cella viene riusata e se ho settato il checkmark questo non viene reimpostato quando viene richiamato
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
       
       // Configure the cell’s contents.
        cell.textLabel!.text = lista[indexPath.row].titolo
        cell.accessoryType =  lista[indexPath.row].checked ? .checkmark : .none
       
           
       return cell
    }

//MARK - tableView Delegate methods
    
    // Respond to row selections : https://developer.apple.com/documentation/uikit/uitableviewdelegate/handling_row_selection_in_a_table_view
    // When the user taps a row, the table view calls the delegate method tableView(_:didSelectRowAt:)
    // a questo punto posso eseguire azioni 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("didSelectRowAt")
        print("\(indexPath.row) \(lista[indexPath.row]) \n")
        // 3.2 evito di mostrare l'evidenziazione in grigio permanente rende + elegante la selezione
        tableView.deselectRow(at: indexPath, animated: true)
        
        //3.2 AccessoryType cell : https://developer.apple.com/documentation/uikit/uitableviewcell/accessorytype/checkmark
        // vedi anche qui : https://www.codegrepper.com/code-examples/swift/remove+checkmark+when+selecting+the+cell+again+swift+5
        // tableView.cellForRow restituisce un optional
        if let cellSafe = tableView.cellForRow(at: indexPath as IndexPath) {
            if cellSafe.accessoryType == .checkmark {
                cellSafe.accessoryType = .none
                lista[indexPath.row].checked = false
            } else {
                cellSafe.accessoryType = .checkmark
                lista[indexPath.row].checked = true
            }
            self.saveItems()
            
        }
    }
    
    
 //MARK - Add new elements
 // 3.2 Aggiungo altri elementi nella lista
    // utilizzo UIAlertController che è una sottoclasse di UIViewController con un textfield da compilare . Una volta inserito il nuovo item sarà aggiunto alla lista o al db; per mostrarlo occorre seguire 3 steps : a) istanzio un UIAlertController con
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
            // un textField è anche un UIControl quindi che si può agganciare ad esso la coppia target-action ad una serie di eventi tra cui Editing Changed
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
                // agggiungo un nuovo elemento alla lista
                let item = Item()
                item.titolo = safeTxt
                item.checked = false
                self.lista.append(item)
                
                
                // 3.3 archivio il contenuto dell'array nel defaults ovvero nel plist file presente nella sandbox; Questa sezione viene sostituita nella 3.4
               // self.defaults.set(self.lista, forKey: K.toDoListArrayforDefaults)
                
                self.saveItems()
                
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
    
    func saveItems(){
        // 3.4 memorizzo il contenuto nell'Items.plist file nella document directory
        // uso PPropertyListEncoder Un oggetto che codifica istanze di tipi di dati in un elenco di proprietà.
        let encoder = PropertyListEncoder()
        // utilizzo il metodo o funzione encode che Restituisce un elenco di proprietà una plist che rappresenta una versione codificata del valore fornito.
        // l'oggetto che viene codificato deve essere conforme al protocollo Encodable per essere codificabile in una plist o in un json
        do {
            let data = try encoder.encode(self.lista)
            try data.write(to: self.datafilePath!)
        } catch {
            print("Errore nella codifica del file. Non è possibile salvare gli items della to do list . \(error)")
        }
        // aggiorno la table view
        self.tableView.reloadData()
    }
    
    // Test if textField empty ; note that it was created disabled
    @objc func textChanged(_ sender: UITextField) {
          
        // _  = sender // sender is a tetxtField
        myalert.actions[1].isEnabled = true
        // to log print(myalert)
        //print(type(of: tf))
       
        
        }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("EDITING")
       
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("END EDITING")
    }
 
    // MARK - Device machine name
        
        // https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model
        func machineName() -> String {
          var systemInfo = utsname()
          uname(&systemInfo)
          let machineMirror = Mirror(reflecting: systemInfo.machine)
          return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
          }
        }
        
    
}


