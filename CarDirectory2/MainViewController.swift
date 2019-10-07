//
//  MainViewController.swift
//  CarDirectory2
//
//  Created by Valentina Abramova on 04/10/2019.
//  Copyright © 2019 Valentina Abramova. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    
    let carManufacturer = ["Lamborgini", "Tesla", "Mazda"]
    let carModel = ["Aventador", "Model X", "3"]
    let year = ["2013", "2017", "2019"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carManufacturer.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        cell.manufacturerLabel.text = carManufacturer[indexPath.row]
        cell.modelLabel.text = carModel[indexPath.row]
        cell.yearLabel.text = year[indexPath.row]
        cell.imageViewCustom.image = UIImage(named: carManufacturer[indexPath.row])
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

}
