//
//  MySQLWrapperGBL.swift
//  3APL_GBL
//
//  Created by Marin Godart  on 17/11/2018.
//  Copyright © 2018 GBL. All rights reserved.
//

import Foundation
import SQLite3

class MysqlWrapperGBL{
    
    var db:OpaquePointer? = nil
    var openDbError:Bool = false
    
    let createUserTableData:String! = """
CREATE TABLE User(
userId INTEGER PRIMARY KEY AUTOINCREMENT,
lastName TEXT NOT NULL,
firstName TEXT NOT NULL,
latitude DOUBLE NOT NULL,
longitude DOUBLE NOT NULL,
family TEXT DEFAULT NULL);
"""
    let addUserStatementString:String = "INSERT INTO User (lastName,firstName,latitude,longitude,family) VALUES (?,?,?,?,?);"
    let selectAllUserStatementString:String = "SELECT * FROM User;"
    let selectUserByUserIdStatementString:String = "SELECT * FROM User WHERE userId = ?;"
    let getUserIdStatementString:String = "SELECT userId FROM User WHERE lastName = ? AND firstName = ?;"
    let updateUserLocationStatementString:String = "UPDATE User SET latitude = ? AND longitude = ? where userId = ?;"
    let deleteUserStatementString:String = "DELETE FROM User WHERE userId = ?;"
    
    init(fileURL:URL?) {
        
        self.openDatabase(fileUrl: fileURL)
        
        if(self.openDbError == false){
         //todo imp
        }
    }
    
    
    /**
    * Méthode qui ouvre la base de donnée et la stock dans la variable self.db
    */
    func openDatabase(fileUrl:URL?){
        if (sqlite3_open(fileUrl?.path, &self.db) == SQLITE_OK) {
            print("La bdd sqlite a été ouverte sans erreur.")
        }else{
            print("erreur lors de l'open de la bdd")
            self.openDbError = true
        }
    }
    
    /*
    *
    * Méhode qui permet de crée la table user.
    * Retourne un boolean false si une erreur ce produit et true si la table a été.
    *
    **/
    func createUserTable() -> Bool {
        
        var statement:OpaquePointer? = nil
        
        //Prepare la requete
        if (sqlite3_prepare_v2(self.db!, self.createUserTableData, -1, &statement, nil) == SQLITE_OK){
            //Execute la requete
            if(sqlite3_step(statement) == SQLITE_DONE){
                sqlite3_finalize(statement)
                return true
            }else{
                print("Une erreur est survenue lors de la création de la table.")
                sqlite3_finalize(statement)
                return false
            }
        }else{
            print("Une erreur est survenue lors de la preparation de la requete de création de la table User.")
            sqlite3_finalize(statement)
            return false
        }
    }
    
    /**
    *
    *Permet d'inserer un utilisateur dans la database sqlite.
    *
    */
    func insertUser(user:User) -> Bool {
        
        var addUserStatement:OpaquePointer? = nil
        if (sqlite3_prepare_v2(self.db!, self.addUserStatementString, -1, &addUserStatement, nil) == SQLITE_OK){
            
                let lastName: NSString = user.lasName as NSString
                let firstName: NSString = user.firstName as NSString
                let latitude: Double = user.latitude!
                let longitude: Double = user.longitude!
                let famille: NSString = "user" as NSString
            
            if sqlite3_bind_text(addUserStatement, 1, lastName.utf8String, -1 , nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                
            }
            if sqlite3_bind_text(addUserStatement, 2, firstName.utf8String, -1 , nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                
            }
            if sqlite3_bind_double(addUserStatement, 3, latitude) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                
            }
            if sqlite3_bind_double(addUserStatement, 4, longitude) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                
            }
            if sqlite3_bind_text(addUserStatement, 5, famille.utf8String, -1 , nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                
            }

            print("\(lastName) ll \(firstName) ll \(latitude) ll \(famille) ll \(longitude)")
            print("-----------")
            
                if(sqlite3_step(addUserStatement) == SQLITE_DONE){
                    sqlite3_finalize(addUserStatement)
                    print("l'ajout de l'utilisateur c'est passer sans problème")
                    return true
                }else{
                    print("Une erreur est survenue lors de l'ajout d'utilisateur")
                    sqlite3_finalize(addUserStatement)
                    return false
                }
            }else{
            print("Une erreur est survenue lors de la preparation de la requete d'ajout d'utilisateur")
            sqlite3_finalize(addUserStatement)
            return false
        }
    }
    
    /**
    *
    * Retourne tous les utilisateurs dans un array d'user
    *
    */
    func selectAllUser() -> [User]? {
        
        var selectAllStatement: OpaquePointer? = nil
        if (sqlite3_prepare_v2(self.db!, self.selectAllUserStatementString, -1, &selectAllStatement, nil) == SQLITE_OK){
            
            var userArray: [User] = []
            
            while(sqlite3_step(selectAllStatement) == SQLITE_ROW){
                
                let idResultCol = sqlite3_column_int(selectAllStatement, 0)
                let lastNameResultCol = sqlite3_column_text(selectAllStatement, 1) //0 est théoriquement le champ id
                let firstNameResultCol = sqlite3_column_text(selectAllStatement, 2)
                let latitude = sqlite3_column_double(selectAllStatement,3)
                let longitude = sqlite3_column_double(selectAllStatement!, 4)
                let familleResultCol = sqlite3_column_text(selectAllStatement!, 5)
                
                let lastName = String(cString: lastNameResultCol!)
                let firstName = String(cString: firstNameResultCol!)
                let famille = String(cString: familleResultCol!)

                print("\(lastName) ll \(firstName) ll \(latitude) ll \(famille) ll \(longitude)")
                
                let userAdd = User(lastname: lastName,firstName: firstName,latitude: latitude,longitude: longitude, famille: famille, id: idResultCol)

                userArray.append(userAdd)
                print(sqlite3_column_count(selectAllStatement))
                
            }
            print("-------------------")
            return userArray
            
        }else{
            print("Une erreur est survenue lors de la preparation de la requete de selection de tous les utilisateurs")
            sqlite3_finalize(selectAllStatement)
            return nil
        }
    }
    
    /**
    *
    * Retourne un utilisateur a partir de son id (int32)
    *
    */
    func selectUserByUserId(userId:Int32) -> User? {
        
        var selectUserByUserIdStatement:OpaquePointer? = nil
        
        if (sqlite3_prepare_v2(self.db!, self.selectUserByUserIdStatementString, -1, &selectUserByUserIdStatement, nil) == SQLITE_OK){

            sqlite3_bind_int(selectUserByUserIdStatement, 1, userId) //id

            //Execution de la requete
            if(sqlite3_step(selectUserByUserIdStatement) == SQLITE_ROW){
                
                let idResultCol = sqlite3_column_int(selectUserByUserIdStatement, 0)
                let lastNameResultCol = sqlite3_column_text(selectUserByUserIdStatement, 1) //0 est théoriquement le champ id
                let firstNameResultCol = sqlite3_column_text(selectUserByUserIdStatement, 2)
                let latitude = sqlite3_column_double(selectUserByUserIdStatement,3)
                let longitude = sqlite3_column_double(selectUserByUserIdStatement!, 4)
                let familleResultCol = sqlite3_column_text(selectUserByUserIdStatement!, 5)
                
                let lastName = String(cString: lastNameResultCol!)
                let firstName = String(cString: firstNameResultCol!)
                let famille = String(cString:familleResultCol!)
                
                let selectUser:User = User(lastname: lastName,firstName: firstName,latitude: latitude,longitude: longitude, famille: famille, id: idResultCol)
                
                return selectUser

            }else{
    
                print("Une erreur c'est produite lors de l'execution de la requete")
                sqlite3_finalize(selectUserByUserIdStatement)
                return nil
            }
            }else{
            print("Une erreur est survenue lors de la preparation de la requete de selection d'un utilisateur'")
            sqlite3_finalize(selectUserByUserIdStatement)
            return nil
            
        }
    }
    
    /**
    * Permet de récuperer un userId as partir du firstname et du lastName
    */
    func getUserIdbyName(firstName:String,lastName:String) -> Int32? {
        
        var getUserIdStatement:OpaquePointer? = nil
        
        if (sqlite3_prepare_v2(self.db!, self.getUserIdStatementString, -1, &getUserIdStatement, nil) == SQLITE_OK){
            
            sqlite3_bind_text(getUserIdStatement, 1, firstName,-1,nil)
            sqlite3_bind_text(getUserIdStatement, 2, lastName,-1,nil)
            
            //Execution de la requete
            if(sqlite3_step(getUserIdStatement) == SQLITE_ROW){
                
                let idResultCol = sqlite3_column_int(getUserIdStatement, 0)
          
                return idResultCol
                
            }else{
                print("Une erreur c'est produite lors de l'execution de la requete de récupèration d'id")
                sqlite3_finalize(getUserIdStatement)
                return nil
            }
        }else{
            print("Une erreur est survenue lors de la preparation de la requete de recuperation de l'userid")
            sqlite3_finalize(getUserIdStatement)
            return nil
            
        }
    }
    
    
    /**
    *
    * Update la localisation d'un utilisateur a partir de sont ID, retourne un boolean
    *
    */
    func updateUserLocation(id:Int32,longitude:Double!,latitude:Double!) -> Bool{
        
        var updateUserLocationStatement:OpaquePointer? = nil
        
        if (sqlite3_prepare_v2(self.db!, self.updateUserLocationStatementString, -1, &updateUserLocationStatement, nil) == SQLITE_OK)
        {
            
            sqlite3_bind_double(updateUserLocationStatement, 1, latitude) //latitude
            sqlite3_bind_double(updateUserLocationStatement, 2, longitude) //longitude
            sqlite3_bind_int(updateUserLocationStatement, 3, id) //id
            
            if(sqlite3_step(updateUserLocationStatement) == SQLITE_DONE){
                sqlite3_finalize(updateUserLocationStatement)
                return true
            }else{
                print("Une erreur est survenue lors de la mise a jours de la position de l'utilisateur")
                sqlite3_finalize(updateUserLocationStatement)
                return false
            }
        }else{
            print("Une erreur est survenue lors de la preparation de la requete de mise a jour de la position de l'utilisateur")
            sqlite3_finalize(updateUserLocationStatement)
            return false
        }
    }
    
    /**
    *
    * Delete un utilisateur a partir de son id, retourne un boolean
    *
    */
    func deleteUser(userId:Int32)-> Bool{
    
        var deleteUserStatement:OpaquePointer? = nil
        
        if (sqlite3_prepare_v2(self.db!, self.deleteUserStatementString, -1, &deleteUserStatement, nil) == SQLITE_OK)
        {

            sqlite3_bind_int(deleteUserStatement, 1, userId) //id
            
            if(sqlite3_step(deleteUserStatement) == SQLITE_DONE){
                sqlite3_finalize(deleteUserStatement)
                return true
            }else{
                print("Une erreur est survenue lors de la suppression de l'utilisateur")
                sqlite3_finalize(deleteUserStatement)
                return false
            }
        }else{
            print("Une erreur est survenue lors de la preparation de la requete de suppression d'utilisateur")
            sqlite3_finalize(deleteUserStatement)
            return false
        }
        
    }
    
    /**
    *
    * Permet De fermer la database
    *
    */
    func closeDatabase() -> Bool {
        sqlite3_close(self.db)
        return true
    }
    
    
}

