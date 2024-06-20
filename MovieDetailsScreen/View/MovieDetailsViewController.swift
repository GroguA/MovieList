//
//  MovieDetailsViewController.swift
//  MovieList
//
//  Created by Александра Сергеева on 19.06.2024.
//

import UIKit

protocol IMovieDetailsViewController: AnyObject {
    func showMovie(_ movie: MovieDetailsModel)
    func showErorr(_ error: String)
    func showLoadingProccess()
    func hideLoadingProccess()
}

final class MovieDetailsViewController: UIViewController {
    private let presenter: IMovieDetailsPresenter
    private let contentView = MovieDetailsContentView()
    
    init(presenter: IMovieDetailsPresenter) {
        self.presenter = presenter
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
        setupViews()
        presenter.didLoad(ui: self) { title in
            self.callResultOnMain {
                self.navigationItem.title = title
            }
        }
    }
}

extension MovieDetailsViewController: IMovieDetailsViewController {
    func showMovie(_ movie: MovieDetailsModel) {
        callResultOnMain {
            self.contentView.fillMovieInfo(with: movie)
        }
    }
    
    func showErorr(_ error: String) {
        callResultOnMain {
            self.contentView.showErrorText(error)
        }
    }
    
    func showLoadingProccess() {
        callResultOnMain {
            self.contentView.setActivityViewPresentation(true)
        }
    }
    
    func hideLoadingProccess() {
        callResultOnMain {
            self.contentView.setActivityViewPresentation()
        }
    }
}

private extension MovieDetailsViewController {
    func setupViews() {
        contentView.retryButton.addTarget(self, action: #selector(retryLoadingMovie), for: .touchUpInside)
    }
    
    @objc func retryLoadingMovie() {
        presenter.didLoad(ui: self) { title in
            DispatchQueue.main.async {
                self.navigationItem.title = title
            }
        }
    }
    
    func callResultOnMain(result: @escaping () -> Void) {
        DispatchQueue.main.async {
            result()
        }
    }
}
