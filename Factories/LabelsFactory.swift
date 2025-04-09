//
//  LabelsFactory.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import UIKit

enum LabelsFactory {
    static func createLabel(with text: String? = nil, isTextBold: Bool = false, isCenterAlignment: Bool = false) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 19, weight: isTextBold ? .semibold : .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.textAlignment = isCenterAlignment ? .center : .natural
        return label
    }
}
