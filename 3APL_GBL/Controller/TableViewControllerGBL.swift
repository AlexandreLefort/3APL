//
//  TableViewControllerGBL.swift
//  3APL_GBL
//
//  Created by Aiman Bahouala on 16/11/2018.
//  Copyright © 2018 GBL. All rights reserved.
//

import UIKit

class TableViewControllerGBL: UITableViewController {
    
    // Tableau d'utilisateur generé a chaque fois que l'on liste les membres de la famille
    // La rest API si il y a de la connexion ou Le SQL lite dans le cas écheant irons alimenter ce tableau
    var UserTable: [User] = [];
    
    // Nom de la famille de l'utilisateur connecté generé a chaque fois que l'on liste les membres de la famille
    // La rest API si il y a de la connexion ou Le SQL lite dans le cas écheant irons alimenter ce champ
    var FamillyName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return UserTable.count
    }

    // Avant que la vue n'apparaisent
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        var connectionChecker:Connectivity = Connectivity()
        connectionChecker.checkConnectivity()
        
        //true si l'on ping l'api
        if(connectionChecker.online){
            
            var data:Dictionary<String,Any> = ["action":"list"]
            data["username"] = "admin"
            data["password"] = "admin"
            let apiManager = ApiManager(postMethod: data)
            
            apiManager.process(){ jsonData in
                
                // Recupere les datas, et les "parse & cast" en dictionnaire
                let temp = jsonData.value(forKey: "family") as! NSDictionary
                // Le convertit en Array afin de pouvoir iterer par la suite
                let tempTable = temp.allValues[2] as! NSMutableArray
                // Stock le nom de famille
                self.FamillyName = temp.value(forKey: "name") as! String;
                // Vide le tableau actuel afin d'y regenerer le nouveau
                self.UserTable.removeAll(keepingCapacity: false)
                
                for i in tempTable{
                    
                    //Ligne du tableau contenant les données d'un utilisateur
                    let table = i as! NSDictionary
                    
                    // Recuperation des valeurs de l'utilisateur
                    let lname: String = table.value(forKey: "firstName") as! String
                    let fname: String = table.value(forKey: "lasName") as! String
                    let idname: Int32 = table.value(forKey: "userId") as! Int32
                    let family = self.FamillyName
                    
                    // Ajout de l'utilisateur au tableau (datasource)
                    self.UserTable.append(User(lastname: lname, firstName: fname, latitude: nil, longitude: nil, famille: family, id: idname))
                    
                    //Variable de tests
                    //print(lname + fname + family + "\(idname)")
                    
                }
                // Refresh la datatable
                self.tableView.reloadData()
            }
        }else{
        
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("database.sqlite")
            let sqlWrapper:MysqlWrapperGBL = MysqlWrapperGBL(fileURL: fileURL)
            let temp = sqlWrapper.selectAllUser()
            if(temp != nil){
                // Vide le tableau actuel afin d'y regenerer le nouveau
                self.UserTable.removeAll(keepingCapacity: false)
                
                self.UserTable = temp!
            }else{
                //todo ici mettre un msg pour dire qu'il n'y as pas d'user
            }
            
            // Refresh la datatable
            self.tableView.reloadData()
            
        }

        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell", for: indexPath) as! TableViewCell1

        // Configure the cell...
        let userRow = UserTable[indexPath.row]

        // Attribution
        cell.PrenomLabel?.text = userRow.firstName
        cell.NomLabel?.text = userRow.lasName

        return cell
    }
 
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Membre(s) de la famille : \(self.FamillyName)"
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Fonction qui permet l'edition de la tableView qui liste les contacts
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            var UID: Int32 = UserTable[indexPath.row].id!
            // Supprime la ligne de la dataSource
            UserTable.remove(at:indexPath.row)
            // Supprime la ligne de la tableview
            tableView.deleteRows(at: [indexPath], with: .fade)

            var connectivityChecker:Connectivity = Connectivity()
            connectivityChecker.checkConnectivity()
            if(connectivityChecker.online){
                
                // Ici si vrai API utilisée, condition de supprimer la ligne de la BDD
                var data:Dictionary<String,Any> = ["action":"remove"]
                 data["username"] = "admin"
                 data["password"] = "admin"
                 data["memberId"] = "\(indexPath.row)"
                 
                 var apiManager = ApiManager(postMethod: data)
                 
                 apiManager.process(){ jsonData in
                 print(jsonData)
                 }
                
                
            }else{
                
                //AIMAN ID  de l'user en dessous
                let UserId:Int32 = UID
                
                let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    .appendingPathComponent("database.sqlite")
                let sqlWrapper:MysqlWrapperGBL = MysqlWrapperGBL(fileURL: fileURL)
                if(sqlWrapper.deleteUser(userId: UserId)){
                    print("l'utilisateur avec pour id \(UserId) a été supprimer")
                }else{
                    print("une erreur c'est produit dans l'apelle de deleteUser.")
                }
            }
                
                
            
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // Fonction de recuperation du nouveau contact a ajouter, ici est fait le traitement avec les données vennant de la page d'ajout d'un contact
    @IBAction func ReturnToMyFamilly(_ sender: UIStoryboardSegue) {
        
        // Si L'ont arrive à recuperer les champs de l'autre controller
        guard let myoldviewc = sender.source as? TableViewControllerFixedAdd
        ,let newname = myoldviewc.NameLabel.text,
        let newfname = myoldviewc.SurnameLabel.text else {return}
        
        // Assignation des champs
        let lname: String = newname
        let fname: String = newfname
        let family = self.FamillyName
        
        // Definition du nouvel utilisateur
        let mynewuser: User = User(lastname: lname, firstName: fname, latitude: 0.0, longitude: 0.0, famille: family, id: nil)
        
        // Dans cette exercice, on utilise des données d'une API en dur fournit par supinfo donc l'ajout au tableau ce fait bien mais vu que la liste se regenere a chaque affichage de la table view, les données seront écrasées par celle de l'api.
        
        //Ajout au tableau de la dataSource
        if let indexPath = tableView.indexPathForSelectedRow {
            UserTable.remove(at:indexPath.row)
            UserTable.insert(mynewuser, at: indexPath.row)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            self.UserTable.append(mynewuser)
        }
        
        
        var connectivityChecker:Connectivity = Connectivity()
        connectivityChecker.checkConnectivity()
        if(connectivityChecker.online){
            //online
            
            // ajout en BDD
            
             var data:Dictionary<String,Any> = ["action":"add"]
             data["username"] = "admin"
             data["password"] = "admin"
             data["memberCode"] = "0000"
             
             var apiManager = ApiManager(postMethod: data)
             
             apiManager.process(){ jsonData in
             print(jsonData)
             }
            
            // NOUS LES AJOUTONS QUAND MEME DNAS LE SQLITE !
            
            // Ajout des données via SQL lite
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("database.sqlite")
            let sqlWrapper:MysqlWrapperGBL = MysqlWrapperGBL(fileURL: fileURL)
            if(sqlWrapper.insertUser(user: mynewuser)){
                
            }else{
                print("l'ajout de l'utilisateur as rencontré une erreur")
            }
            
        }else{
            //offline
            
            // Ajout des données via SQL lite
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("database.sqlite")
            let sqlWrapper:MysqlWrapperGBL = MysqlWrapperGBL(fileURL: fileURL)
            if(sqlWrapper.insertUser(user: mynewuser)){

            }else{
                print("l'ajout de l'utilisateur as rencontré une erreur")
            }
        }
    }
}
