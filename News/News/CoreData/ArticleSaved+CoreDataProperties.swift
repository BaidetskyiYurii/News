//
//  ArticleSaved+CoreDataProperties.swift
//  News
//
//  Created by Baidetskyi Jurii on 04.02.2023.
//
//

import Foundation
import CoreData


extension ArticleSaved {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleSaved> {
        return NSFetchRequest<ArticleSaved>(entityName: "ArticleSaved")
    }

    @NSManaged public var sourceID: String?
    @NSManaged public var sourceName: String?
    @NSManaged public var author: String?
    @NSManaged public var title: String?
    @NSManaged public var image: Data?
    @NSManaged public var url: String?

}

extension ArticleSaved : Identifiable {

}
