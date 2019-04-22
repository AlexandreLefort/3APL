//
//  ApiManager.swift
//  3APL_GBL
//
//  Created by godartm on 15/11/2018.
//  Copyright © 2018 GBL. All rights reserved.
//

import Foundation
import Darwin
class ApiManager{
    
    //Url de l'api
    var request:URLRequest = URLRequest(url: URL(string :"http://supinfo.steve-colinet.fr/supfamily/")!)
    var dataReturn:NSDictionary!
    
    static var ActualSession: User?;

    init(postMethod data:Dictionary<String,Any>) {
        
        self.request.httpMethod = "POST"
        let postString = self.parameterGenerator(data: data) //Chaine de caractère qui contient les parametees
        self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        self.request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        self.request.httpBody = postString.data(using: .utf8)
    }
    
    /**
     *
     * WIP
     *
     */
    init(getMethod data:Dictionary<String,Any>) {
        /*
        self.request.httpMethod = "GET"
        let postString = self.parameterGenerator(data: data)
        self.request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        self.request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        self.request.httpBody = postString.data(using: .utf8)
         */
        
    }
    
    func process(completion: @escaping (NSDictionary) -> ()){
    
        
        
        let task = URLSession.shared.dataTask(with: self.request){ data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print(error! as NSError)
                    return
                }
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, AnyObject>
                   
                    completion(jsonData! as NSDictionary)
 
                } catch {
                    print("catch")
                    print(error as NSError)
                }
            }
        }
        task.resume()
       
       
    }
    
    /**
     *
     *   Méthode qui génère un tableau d'utilisateur avec leurs latitude/longitude
     *
     **/
    func returnUserPosition(completion: @escaping ([User]) -> ()){
        
        let task = URLSession.shared.dataTask(with: self.request){ data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print(error! as NSError)
                    return
                }
                do {
                    var jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, AnyObject>
                    
                    jsonData = (jsonData!["family"] as! Dictionary<String, AnyObject>);
                    var jsoneData = jsonData!["members"] as! NSArray
                    
                    var UserTableReturn: [User] = []
                    
                    for i in jsoneData{
                        
                        //Ligne du tableau contenant les données d'un utilisateur
                        let table = i as! NSDictionary
                        
                        // Recuperation des valeurs de l'utilisateur
                        let lname: String = table.value(forKey: "firstName") as! String
                        let fname: String = table.value(forKey: "lasName") as! String
                        let idname: Int32 = table.value(forKey: "userId") as! Int32
                        let latitude: Double = table.value(forKey: "latitude") as! Double
                        let longitude: Double = table.value(forKey:"longitude") as! Double
                        
                        // Ajout de l'utilisateur au tableau (datasource)
                        UserTableReturn.append(User(lastname: lname, firstName: fname, latitude: latitude, longitude: longitude, famille: nil, id: idname))
                        
                    }
                    
                    completion(UserTableReturn as [User])
                    
                } catch {
                    print("catch")
                    print(error as NSError)
                }
            }
        }
        task.resume()
        
        
    }
    
    /**
    *
    * UTILISATION
 
     var data:Dictionary<String,Any> = ["action":"getPosition"]
     data["username"] = "admin"
     data["password"] = "admin"
 
     let apiManager = ApiManager(postMethod: data)
     apiManager.returnUserPosition(){ UserTableReturn in
 
     // ici votre code de traitement
 
     }
     *
     */
    
    /**
    *
    *   Méthode qui génère les parametres a passer en post pour du x-www-url-encoded
    *  Cela retourne une chaine de caractère et prend en entée un dictionnaire.
    */
    func parameterGenerator(data:Dictionary<String,Any>)-> String{
        
        var stringRequest:String?
        
        for(key, value) in data {
            
            if (stringRequest == nil){
                stringRequest = "\(key)=\(value)"
            }else{
                stringRequest = stringRequest! + "&\(key)=\(value)"
            }
            
        }
        return stringRequest!
        
    }
    
}


