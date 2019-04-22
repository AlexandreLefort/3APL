//
//  TableViewControllerMoreOptions.swift
//  3APL_GBL
//
//  Created by Aiman Bahouala on 18/11/2018.
//  Copyright © 2018 GBL. All rights reserved.
//

import UIKit

class TableViewControllerMoreOptions: UITableViewController {

    @IBOutlet weak var DeconnexionLabel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let url = URL(string: "http://supinfo.steve-colinet.fr/supfamily/?action=login&username=admin&password=admin")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let report = try? jsonDecoder.decode([String: String].self, from: data) {
                print(report)
            } else {
                print("Either no data was returned, or data was not serialized.")
                
                return
            }
        }
        task.resume()
        
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation
    */
     @IBAction func OnSeDeconnecter(_ sender: Any) {
        
        self.DeconnexionLabel.isHidden = true
        
        var connectionChecker:Connectivity = Connectivity()
        connectionChecker.checkConnectivity()
        if(connectionChecker.online){
            
            var data:Dictionary<String,Any> = ["action":"logout"]
            data["username"] = "admin"
            data["password"] = "admin"
            var apiManager = ApiManager(postMethod: data)
            
            apiManager.process(){ jsonData in
                
                // Si la deconnexion s'est correctement déroulée
                if let _: Bool = jsonData["success"] as! Int == 1 {
                    
                    // Redirection vers la page de connexion
                    self.performSegue(withIdentifier: "Deconnexion", sender: self)
                }else{
                    
                    // afficher label message derreur il est deja dedans le label
                    self.DeconnexionLabel.isHidden = false
                }
                
            }
        }else{
            
            self.performSegue(withIdentifier: "Deconnexion", sender: self)

        }

        
     }
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
