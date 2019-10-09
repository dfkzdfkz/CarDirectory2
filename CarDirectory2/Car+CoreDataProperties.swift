//
//  Car+CoreDataProperties.swift
//  CarDirectory2
//
//  Created by Valentina Abramova on 09.10.2019.
//  Copyright © 2019 Valentina Abramova. All rights reserved.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var year: Int16
    @NSManaged public var manufacturer: String?
    @NSManaged public var model: String?
    @NSManaged public var bodyType: String?
    @NSManaged public var image: Data?
    

}
