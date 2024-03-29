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
        if self.model.name != "" {
            switch await CategoryDAO.shared.createCategory(type: self.type, category: self.model) {
            case .failure(let error):
                print(error)
            case .success(let category):
                print(category.name)
                self.categories.append(category)
            }
        } else {
            self.error = "You cannot add category with an empty name"
        }
    }
    
    func delete(categoryId: Int, categoryIndex: Int) async {
        switch await CategoryDAO.shared.deleteCategoryById(type: self.type, id: categoryId) {
        case .failure(let error):
            self.error = "Error : this category correspond to several \(self.type == CategoryType.recipe ? "recipes" : "ingredients") , you cannot delete it"
            print(error)
        case .success(let isDeleted):
            if isDeleted {
                self.categories.remove(at: categoryIndex)
            }
        }
        
        
    }
    
}
