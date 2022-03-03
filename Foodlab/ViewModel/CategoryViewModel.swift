//
//  CategoryViewModel.swift
//  Foodlab
//
//  Created by m1 on 03/03/2022.
//

import Combine
import Foundation

class CategoryViewModel : ObservableObject, CategoryObserver {
    
    var model: Category
    @Published var name: String {
        didSet {
            print("modification en cours")
            if self.name != self.model.name {
                self.model.name = self.name
                if self.name != self.model.name {
                    self.name = self.model.name
                }
            }
        }
    }
    
    @Published var categories: [Category]
    @Published var error: String?
    var type: CategoryType
    
    init(categories: [Category] = [], type: CategoryType) {
        self.type = type
        self.categories = categories
        self.model = Category(name: "")
        self.name = ""
        self.model.observer = self
    }
    
    func changed(name: String) {
        
    }
    
    func create() async {
        if self.model.name.count != 0 {
            // TODO: create in database
            switch await CategoryDAO.createCategory(type: self.type, category: self.model) {
            case .failure(let error):
                print(error)
            case .success(let category):
                print(category.name)
                self.categories.append(category)
            }
        }
    }
    
    func delete() {
        
    }
    
}
