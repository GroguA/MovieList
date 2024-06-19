//
//  StackViewsFactory.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import UIKit

final class StackViewsFactory {
    static func createStackView(with arrangedSubviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }
}
