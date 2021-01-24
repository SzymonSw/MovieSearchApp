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
            
            RequestManager.fetchImage(imageUrlString: value.poster, completion: { (imageData) in
                guard let imageData = imageData, let image = UIImage(data: imageData) else {
                    me.posterImageView.image = UIImage(named: "image_placeholder")
                    return
                }
                me.posterImageView.image = image
                
            })
        }
    }
    

}
