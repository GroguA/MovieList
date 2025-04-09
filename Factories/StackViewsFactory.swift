//
//  StackViewsFactory.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import UIKit

enum StackViewsFactory {
    static func createStackView(with arrangedSubviews: [UIView], isVertical: Bool = true) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.alignment = .fill
        stackView.axis = isVertical ? .vertical : .horizontal
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
