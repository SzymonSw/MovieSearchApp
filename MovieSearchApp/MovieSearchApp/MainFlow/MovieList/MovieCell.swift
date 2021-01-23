//
//  MovieCell.swift
//  MovieSearchApp
//
//  Created by Szymon Świętek on 23/01/2021.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    var lastImageFetchTask: URLSessionDataTask?
        
    var movieData: MovieData! {
        didSet {
            setupCell()
        }
    }
    
    func setupCell() {
        movieTitleLabel.text = movieData.title
        fetchImage()
    }
    
    func fetchImage() {
        lastImageFetchTask = RequestManager.fetchImage(imageUrlString: movieData.poster, completion: { (imageData) in
            guard let imageData = imageData, let image = UIImage(data: imageData) else {
                self.movieImageView.image = UIImage(named: "image_placeholder")
                return
            }
            self.movieImageView.image = image
            
        })
        
    }
    
    override func prepareForReuse() {
        lastImageFetchTask?.cancel()
        movieImageView.image = UIImage(named: "image_placeholder")
    }
}
