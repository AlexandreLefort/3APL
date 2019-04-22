//
//  ViewController.swift
//  3APL_GBL
//
//  Created by Aiman Bahouala on 11/11/2018.
//  Copyright © 2018 GBL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var gradientLayer: CAGradientLayer!
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginErrorLabel: UILabel!
    var firstStart:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
            let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("database.sqlite")
            let wrapperSql:MysqlWrapperGBL = MysqlWrapperGBL(fileURL: fileURL)
            if(wrapperSql.createUserTable()){
                print("La table user a été crée sans problème")
            }else{
                print("une erreur est survenue lors de la création de la table user")
            }
        
        loginErrorLabel.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    //Fonction executée lorsqu'on clique sur "Se connecter"
    @IBAction func OnSeConnecter(_ sender: Any) {
        
      self.loginErrorLabel.isHidden = true
        
        var connectionChecker:Connectivity = Connectivity()
        connectionChecker.checkConnectivity()
        if(connectionChecker.online){
            
            var data:Dictionary<String,Any> = ["action":"login"]
            data["username"] = usernameTextField.text
            data["password"] = passwordTextField.text
            let apiManager = ApiManager(postMethod: data)
            
            apiManager.process(){ jsonData in
                
                // Si le mot de passe ne retourne pas un clé success = 0
                if let val = jsonData["success"] {
                    
                    self.loginErrorLabel.text = "Identifiant ou mot de passe incorrect !"
                    self.loginErrorLabel.isHidden = false
                }else{
                    
                    // Recuperation des valeurs de l'utilisateur
                    let temporaire = jsonData["user"] as! NSDictionary
                    let temporaire2 = jsonData["family"] as! NSDictionary
                    let lname: String = temporaire.allValues[0] as! String
                    let fname: String = temporaire.allValues[2] as! String
                    let idname: Int32 = temporaire.allValues[1] as! Int32
                    let family: String = temporaire2.allValues[1] as! String
                    // Stockage de l'utilisateur
                    ApiManager.ActualSession = User(lastname:  lname, firstName: fname, latitude: nil, longitude: nil, famille: family, id: idname)
        
                    // Redirection de l'utilisateur
                    self.performSegue(withIdentifier: "ok", sender: nil)
                    
                }
            }
        }else{
            let username = usernameTextField.text
            let password = passwordTextField.text
            
            if(username == "admin" && password == "admin" ){
                self.performSegue(withIdentifier: "ok", sender: nil)
            }else{
                self.loginErrorLabel.text = "Identifiant ou mot de passe incorrect"
                self.loginErrorLabel.isHidden = false
            }
        }
    }
    
    // Unwind lorsque le bouton se deconnecter est declenché
    @IBAction func Deconnexion(_ sender: UIStoryboardSegue) {
        
        _ = sender.source as? ViewController
        
     
    }

}

