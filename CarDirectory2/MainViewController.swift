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
    
    var testadded = false
    
    var cars = [Car]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTestCars()
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
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Core Data
    
    func saveCar(bodyType: String, image: Data, manufacturer: String, model: String, year: Int16) {
        
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
        if testadded == false {
            let testImage1 = UIImage(named: "Lamborgini")
            let testImage2 = UIImage(named: "Tesla")
            let testImage3 = UIImage(named: "Mazda")
            guard let testImageData1 = testImage1?.pngData(), let testImageData2 = testImage2?.pngData(), let testImageData3 = testImage3?.pngData() else { return }

            saveCar(bodyType: "купе", image: testImageData1, manufacturer: "Lamborgini", model: "Aventador", year: 2013)
            saveCar(bodyType: "внедорожник", image: testImageData2, manufacturer: "Tesla", model: "Model X", year: 2017)
            saveCar(bodyType: "седан", image: testImageData3, manufacturer: "Mazda", model: "3", year: 2019)
            
            testadded = true
        } else {
            return
        }
    }

}
