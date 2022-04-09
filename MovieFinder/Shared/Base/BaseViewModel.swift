//
//  BaseViewModel.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import Foundation

class BaseViewModel {
    func getDataCount<T>(from data: [T?]?) -> Int {
        return data?.isEmpty == false ? data?.count ?? 0 : 0
    }

    func getCellData<T>(at indexPath: IndexPath, from data: [T?]?) -> T? {
        return data?.isEmpty == true ? nil : data?[indexPath.row]
    }
    
    func getCellDataSection<T>(at indexPath: IndexPath, from data: [T?]) -> T? {
        return data.isEmpty == true ? nil : data[indexPath.section]
    }
}
