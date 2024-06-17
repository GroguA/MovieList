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
        return filter { unique.insert($0).inserted }
    }
}
