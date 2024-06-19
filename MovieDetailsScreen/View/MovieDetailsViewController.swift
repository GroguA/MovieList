//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import UIKit

final class MovieDetailsViewController: UIViewController {

    private let contentView = MovieDetailsContentView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        setupView()
    }
}

private extension MovieDetailsViewController {
    func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Movie details"
    }
}
