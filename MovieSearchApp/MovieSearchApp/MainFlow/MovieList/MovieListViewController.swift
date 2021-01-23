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
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let cellIndentifier = "movieCell"

    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Search"
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumLineSpacing = 20
            layout.minimumInteritemSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            let cellWidth = (UIScreen.main.bounds.width - 60)/2
            let size = CGSize(width: cellWidth, height: cellWidth * 4.0/3.0)
            layout.itemSize = size
        }
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search GitHub"
        navigationItem.searchController = searchController
        
        bindViewModel()

    }
    
    func bindViewModel() {
        viewModel.moviesList.bind(to: self) { (me, value) in
            me.collectionView.reloadData()
        }
    }

    
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.serachTextChanged(newText: searchController.searchBar.text)
        
    }
}

extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.moviesList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIndentifier, for: indexPath) as! MovieCell
        cell.movieData = viewModel.moviesList.value[indexPath.row]
        return cell
        
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    
}

