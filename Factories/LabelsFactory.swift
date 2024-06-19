//
//  LabelsFactory.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import UIKit

final class LabelsFactory {
    static func createLabel(with text: String? = nil, isTextBold: Bool = false) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 19, weight: isTextBold ? .semibold : .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        return label
    }
    
}
