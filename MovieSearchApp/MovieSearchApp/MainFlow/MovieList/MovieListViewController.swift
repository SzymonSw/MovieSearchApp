//
//  MovieListViewController.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import UIKit

class MovieListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Movie Search"

    }
 
    @IBAction func nextButtonTapped(_ sender: Any) {
        let detailsVC = MovieDetailsViewController.controllerFromStoryboard("Main")
        self.navigationController?.show(detailsVC, sender: nil)
    }
    
}
