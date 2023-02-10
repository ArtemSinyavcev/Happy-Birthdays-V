//
//  Singleton.swift
//  Birthdays_1
//
//  Created by Артём Синявцев on 23.12.2022.
//

import RealmSwift


class DataManager{
    
    static var shared = DataManager()
    
    // открытие ОБЛАСТИ в базе данных по умолчанию
    let realm = try! Realm()
    
    // добавление нового Human
    func addModel(model: HumanModel) {
        try! realm.write {
            realm.add(model)
        }
    }
    
    // Функция получает всех "Human"
    func getAllHumans() -> [HumanModel] {
        let humans = realm.objects(HumanModel.self)
        return Array(humans)
    }
    
    // удаление Human
    func removeHuman(model: HumanModel) {
        try! realm.write {
            realm.delete(model)
        }
    }
    
}


