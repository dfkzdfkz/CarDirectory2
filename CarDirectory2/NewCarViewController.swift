//
//  NewCarViewController.swift
//  CarDirectory2
//
//  Created by Valentina Abramova on 10.10.2019.
//  Copyright © 2019 Valentina Abramova. All rights reserved.
//

import UIKit
import CoreData

class NewCarViewController: UITableViewController {
    
//    var newCar: Car?
    var currentCar: Car?
    var index = 0
    var isNewCar = true
    var imageIsChange = false
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var carImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var carManufacturer: UITextField!
    @IBOutlet weak var carModel: UITextField!
    @IBOutlet weak var carBodyType: UITextField!
    @IBOutlet weak var carYear: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        
        carManufacturer.addTarget(self, action: #selector(textFieldChanched), for: .editingChanged)
        carBodyType.addTarget(self, action: #selector(textFieldChanched), for: .editingChanged)
        carYear.addTarget(self, action: #selector(textFieldChanched), for: .editingChanged)
        carModel.addTarget(self, action: #selector(textFieldChanched), for: .editingChanged)
        
        saveButton.isEnabled = false
        setupEditScreen()
        
    }
    
    private func setupEditScreen() {
        if isNewCar == false {
            
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
                   
            do {
                let results = try context.fetch(fetchRequest)
                currentCar = results[index]
                } catch {
                    print(error.localizedDescription)
                }
            
            guard let data = currentCar?.image, let image = UIImage(data: data) else { return }
            
            carImage.image = image
            carImage.contentMode = .scaleAspectFill
            carManufacturer.text = currentCar?.manufacturer
            carModel.text = currentCar?.model
            carBodyType.text = currentCar?.bodyType
            carYear.text = "\(currentCar!.year)"
            
            setupNavigationBar()
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentCar?.manufacturer
        saveButton.isEnabled = true
    }
    
    func saveCar() {
        
        if isNewCar == true {
            
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Car", in: context)
            let newCar = NSManagedObject(entity: entity!, insertInto: context) as! Car
            
            let image = imageIsChange ? carImage.image : #imageLiteral(resourceName: "Default")
                   
            guard let newCarImageData = image?.pngData() else { return }
            guard let intYear = Int16(carYear.text!) else { return }
                   
            newCar.manufacturer = carManufacturer.text
            newCar.model = carModel.text
            newCar.bodyType = carBodyType.text
            newCar.year = intYear
            newCar.image = newCarImageData
                   
//            self.newCar = newCar
                   
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        } else {
//            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            guard let newManufacturer = carManufacturer.text,
                let newModel = carModel.text,
                let newBodyType = carBodyType.text,
                let newYear = Int16(carYear.text!),
                let newImage = carImage.image?.pngData()
                else { return }
            
            currentCar?.manufacturer = newManufacturer
            currentCar?.model = newModel
            currentCar?.bodyType = newBodyType
            currentCar?.year = newYear
            currentCar?.image = newImage
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    //    MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(sourse: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(sourse: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }

}

// MARK: - Textfield delegate

extension NewCarViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanched() {
        if carManufacturer.text?.isEmpty == false && carBodyType.text?.isEmpty == false && carYear.text?.isEmpty == false && carModel.text?.isEmpty == false  {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
}

// MARK: - Work with image

extension NewCarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(sourse: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(sourse) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = sourse
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        carImage.image = info[.editedImage] as? UIImage
        carImage.contentMode = .scaleAspectFill
        carImage.clipsToBounds = true
        imageIsChange = true
        dismiss(animated: true)
    }
    
}
