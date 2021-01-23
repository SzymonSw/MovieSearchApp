//
//  AppCoordinator.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import UIKit

class AppCoordinator: Coordinator {

    private let router: Router

    private let requestManager:RequestManager
    
    init(requestManager: RequestManager) {
        router = Router(rootController: AppCoordinator.makeRootViewControllerWithKeyAndVisible())
        self.requestManager = requestManager

    }
    
    override func start() {
        setMovieListScreenRoot()
    }
    
    private func setMovieListScreenRoot() {
        let movieListVC = MovieListViewController.controllerFromStoryboard("Main")
        let movieListVM = MovieListViewModel(requestManager: requestManager, delegate: self)
        movieListVC.viewModel = movieListVM
        
        router.setRootModule(movieListVC)
    }
    
    private func showMovieDetails(movieData: MovieData) {
        let detailsVC = MovieDetailsViewController.controllerFromStoryboard("Main")
        let detailsVM = MovieDetailsViewModel(requestManager: requestManager, movieData: movieData)
        detailsVC.viewModel = detailsVM
        
        router.push(detailsVC)
    }
    
    private static func makeRootViewControllerWithKeyAndVisible() -> UINavigationController {
        let rootNavigationController = UINavigationController()
        
        if let window = UIApplication.shared.delegate?.window {
            window?.rootViewController = rootNavigationController
            window?.makeKeyAndVisible()
        }
        
        return rootNavigationController
    }
    
}

extension AppCoordinator: MovieListDelegate {
    func wantsToShowMovieDetails(movieData: MovieData) {
        self.showMovieDetails(movieData: movieData)
    }
    
}

