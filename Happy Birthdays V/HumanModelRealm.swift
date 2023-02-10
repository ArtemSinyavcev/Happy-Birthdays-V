//
//  Realm.swift
//  Birthdays_1
//
//  Created by Артём Синявцев on 02.01.2023.
//

import RealmSwift
import UIKit

class HumanModel: Object {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var birthdaysDate: String = ""
    @Persisted var surnameName: String = ""
    @Persisted var humanFoto: Data?
    
    
    convenience init (birthdaysDate: String, surnameName: String, humanFoto: Data? ) {
        
        self.init()
        self.birthdaysDate = birthdaysDate
        self.surnameName = surnameName
        self.humanFoto = humanFoto
    }
    
}





