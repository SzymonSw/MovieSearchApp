//
//  MovieListViewController.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import UIKit
import Bond

class MovieListViewController: UIViewController {
    
    var viewModel: MovieListViewModel!

    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Search"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search GitHub"
        navigationItem.searchController = searchController

    }

    
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.serachTextChanged(newText: searchController.searchBar.text)
        
    }
}
