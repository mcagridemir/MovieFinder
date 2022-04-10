//
//  MovieTableViewCell.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 10.04.2022.
//

import SDWebImage
import SkeletonView
import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func initCell(movie: Movie?) {
        movieImageView.isSkeletonable = true
        movieImageView.showAnimatedGradientSkeleton()
        movieImageView.sd_setImage(with: URL(string: movie?.poster ?? "")) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.movieImageView.hideSkeleton()
            self.movieImageView.isSkeletonable = false
        }
        titleLabel.text = movie?.title
        dateLabel.text = movie?.year
    }
}
