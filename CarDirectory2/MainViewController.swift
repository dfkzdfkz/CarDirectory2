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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carManufacturer.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(carManufacturer[indexPath.row]) \(carModel[indexPath.row])"
        cell.imageView?.image = UIImage(named: carManufacturer[indexPath.row])
        return cell
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
