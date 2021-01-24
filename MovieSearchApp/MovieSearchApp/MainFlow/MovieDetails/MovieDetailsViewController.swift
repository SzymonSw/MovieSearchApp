//
//  MovieDetailsViewController.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 21/01/2021.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    var viewModel: MovieDetailsViewModel!
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var generesLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var plotLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var boxOfficeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    lazy var loadingView: UIView = {
        let background = UIView()
        background.backgroundColor = .white
        background.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(background)
        background.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        background.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        background.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        background.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        let loader = LoadingFooterView()
        loader.translatesAutoresizingMaskIntoConstraints = false

        background.addSubview(loader)
        loader.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        loader.centerYAnchor.constraint(equalTo:background.centerYAnchor).isActive = true
        loader.activityIndicator.startAnimating()
        return background
    }()
    
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
            guard let value = value else {
                return
            }
            me.titleLabel.text = value.title
            me.yearLabel.text = value.year
            me.generesLabel.text = value.genre
            me.durationLabel.text = value.runtime
            me.ratingLabel.text = value.imdbRating
            me.plotLabel.text = value.plot
            me.scoreLabel.text = value.metascore
            me.reviewsLabel.text = value.imdbVotes
            me.boxOfficeLabel.text = value.boxOffice
            me.directorLabel.text = value.director
            me.writerLabel.text = value.writer
            me.actorsLabel.text = value.actors
            
            me.posterImageView.image = UIImage(named: "image_placeholder")

            RequestManager.fetchImage(imageUrlString: value.poster, completion: { (imageData) in
                guard let imageData = imageData, let image = UIImage(data: imageData) else {
                    me.posterImageView.image = UIImage(named: "image_placeholder")
                    return
                }
                me.posterImageView.image = image
                
            })
        }
        
        self.viewModel.isLoading.bind(to: self) { (me, value) in
            me.loadingView.isHidden = !value
        }
    }

}
