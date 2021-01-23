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
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    
    private let cellIndentifier = "movieCell"
    private let searchController = UISearchController(searchResultsController: nil)
    private var scrolling = false
    private let bottomOffsetToStartScrolling: CGFloat = 20.0
    
    var loadingFooterView: UIView?
    var tooManyRequestsHeaderView: UIView?

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
        
        viewModel.isLoading.bind(to: self) { (me, value) in
            self.loadingFooterView?.isHidden = !value
            
        }
        
        viewModel.error.bind(to: self) { (me, value) in
            if let error = value, let errorMessage = error.message {
                self.errorView.isHidden = false
                self.errorLabel.text = errorMessage
            } else {
                self.errorView.isHidden = true
            }
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingFooter", for: indexPath)
            loadingFooterView = footer
            footer.isHidden = !viewModel.isLoading.value
            return footer
            
            
        default:
            print("anything")
        }
        return UICollectionReusableView()
    }
}

extension MovieListViewController: UICollectionViewDelegate {
    
}

extension MovieListViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > 0 {
            self.scrolling = true
        } else {
            self.scrolling = false
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if maximumOffset - currentOffset <= bottomOffsetToStartScrolling {
            if scrolling {
                scrolling = false
                viewModel.scrolledToEndOfList()
            }
        }
        
    }
}
