//
//  DrinkCD+CoreDataProperties.swift
//  
//
//  Created by Tobias Ruano on 16/11/2019.
//
//

import Foundation
import CoreData


extension DrinkCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DrinkCD> {
        return NSFetchRequest<DrinkCD>(entityName: "DrinkCD")
    }

    @NSManaged public var caffeine: Double
    @NSManaged public var date: Date?
    @NSManaged public var icon: String?
    @NSManaged public var mililiters: Double
    @NSManaged public var type: String?

}
