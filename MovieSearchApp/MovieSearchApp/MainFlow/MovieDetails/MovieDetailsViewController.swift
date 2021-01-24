//
//  MovieDetailsViewController.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var viewModel: MovieDetailsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Details"
        self.bindViewModel()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }
    
    func bindViewModel() {
        self.viewModel.movieDetails.bind(to: self) { (me, value) in 
            
        }
    }

}
