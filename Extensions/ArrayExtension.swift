//
//  ArrayExtension.swift
//  MovieList
//
//  Created by Александра Сергеева on 15.06.2024.
//

import Foundation

extension Array where Element: Hashable {
    func unique() -> [Element] {
        var unique = Set<Element>()
        var filtered = [Element]()
        
        for item in self {
            if let movieItem = item as? MovieModel {
                if unique.contains(where: { existingItem in
                    if let existingMovie = existingItem as? MovieModel {
                        return existingMovie == movieItem
                    } else {
                        return false
                    }
                }) {
                    continue
                }
            }
            filtered.append(item)
            unique.insert(item)
        }
        return filtered
    }
}
