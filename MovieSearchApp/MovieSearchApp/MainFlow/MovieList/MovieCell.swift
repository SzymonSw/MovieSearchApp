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
        movieImageView.image = UIImage(named: "image_placeholder")
        
        RequestManager.fetchImage(imageUrlString: movieData.poster, completion: { (imageData) in
            guard let imageData = imageData, let image = UIImage(data: imageData) else {
                return
            }
            self.movieImageView.image = image
            
        })
        
//        if let url = URL(string: movieData.poster), let data = try? Data(contentsOf: url) {
//            let image = UIImage(data: data)
//            movieImageView.image = image
//        }
    }
}
