//
//  TableViewControllerFixedAdd.swift
//  3APL_GBL
//
//  Created by Aiman Bahouala on 16/11/2018.
//  Copyright © 2018 GBL. All rights reserved.
//

import UIKit

class TableViewControllerFixedAdd: UITableViewController {

    @IBOutlet weak var NameLabel: UITextField!
    @IBOutlet weak var SurnameLabel: UITextField!
    
    var test: String?
    
    // var utilisateur: Utilisateur?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source
    
    @IBAction func OnclickSauvegarder(_ sender: Any) {
        /*
         guard let title = titleTextField.text,
         let author = authorTextField.text,
         let genre = genreTextField.text,
         let length = lengthTextField.text else {return}
         */
        
        //book = Book(title: title, author: author, genre: genre, length: length)
        //performSegue(withIdentifier: PropertyKeys.unwind, sender: self)
    }
    
    

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
    
    
    /*
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
