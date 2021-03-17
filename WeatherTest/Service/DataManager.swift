//
//  DataManager.swift
//  WeatherTest
//
//  Created by Гурген on 03.03.2021.
//

import UIKit
import CoreData

//class DataManager {
//    
//    var cities: [Weather] = []
//    
//    func fetchData(){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let fetchRequest: NSFetchRequest<City> = City.fetchRequest()
//        
//        do {
//            cities = try context.fetch(fetchRequest)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func addDataBase(city: String) {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        
//        let entity = NSEntityDescription.entity(forEntityName: "City", in: context)
//        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! City
//        taskObject.name = city
//        
//        do {
//            try context.save()
//            cities.append(taskObject)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    func deleteDatBase(city: City){
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        
//        context.delete(city)
//        
//        do {
//            try context.save()
//            print("delete")
//        } catch let error as NSError {
//            print(error.localizedDescription)
//        }
//        self.fetchData()
//    }
//}
