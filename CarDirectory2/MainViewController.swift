//
//  MainViewController.swift
//  CarDirectory2
//
//  Created by Valentina Abramova on 04/10/2019.
//  Copyright © 2019 Valentina Abramova. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UITableViewController {
  
    var cars = [Car]()
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        do {
            cars = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTestCars()
    }
//    MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard editingStyle == .delete else { return }
        
        let carToDelete = cars[indexPath.row]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        context.delete(carToDelete)
        
        do {
            try context.save()
//            tableView.beginUpdates()
            cars.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            tableView.endUpdates()
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.manufacturerLabel.text = cars[indexPath.row].manufacturer
        cell.modelLabel.text = cars[indexPath.row].model
        cell.yearLabel.text = "\(cars[indexPath.row].year)"
        cell.imageViewCustom.image = UIImage(data: cars[indexPath.row].image!)
        return cell
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
        guard let newCarVC = segue.source as? NewCarViewController else { return }
        newCarVC.saveCar()
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
               
               do {
                   cars = try context.fetch(fetchRequest)
               } catch {
                   print(error.localizedDescription)
               }
        
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let vc = segue.destination as? NewCarViewController else { return }
            guard let indexPath = tableView.indexPathsForSelectedRows?.first else { return }
            vc.index = indexPath.row
            vc.isNewCar = false
        }
    }

    
    // MARK: - Core Data
    
    public func saveCarToCoreData(bodyType: String, image: Data, manufacturer: String, model: String, year: Int16) {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
        let carObject = NSManagedObject(entity: entity!, insertInto: context) as! Car
        
        carObject.bodyType = bodyType
        carObject.image = image
        carObject.manufacturer = manufacturer
        carObject.model = model
        carObject.year = year
        
        do {
            try context.save()
            cars.append(carObject)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Test cars
    
    func addTestCars() {
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        
        var records = 0
        
        do {
            let count = try context.count(for: fetchRequest)
            records = count
        } catch {
            print(error.localizedDescription)
        }
        
        if records == 0 {
            let testImage1 = UIImage(named: "Lamborgini")
            let testImage2 = UIImage(named: "Tesla")
            let testImage3 = UIImage(named: "Mazda")
            guard let testImageData1 = testImage1?.pngData(), let testImageData2 = testImage2?.pngData(), let testImageData3 = testImage3?.pngData() else { return }

            saveCarToCoreData(bodyType: "купе", image: testImageData1, manufacturer: "Lamborgini", model: "Aventador", year: 2013)
            saveCarToCoreData(bodyType: "внедорожник", image: testImageData2, manufacturer: "Tesla", model: "Model X", year: 2017)
            saveCarToCoreData(bodyType: "седан", image: testImageData3, manufacturer: "Mazda", model: "3", year: 2019)
        } else {
            return
        }
    }

}
