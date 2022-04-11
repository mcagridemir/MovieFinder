//
//  MovieDetailViewController.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import SDWebImage
import SkeletonView
import UIKit

class MovieDetailViewController: BaseViewController {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var imdbImageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    private let viewModel = DetailViewModel()
    
    func setId(id: String) {
        viewModel.id = id
        viewModel.getMovie()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setHeaderNativeBackTitleWhite(title: LocalizationKeys.detailTitle.localized)
        initObservers()
    }
    
    private func initViews(movie: Movie?) {
        self.movieImageView.isSkeletonable = true
        self.movieImageView.showAnimatedGradientSkeleton()
        self.movieImageView.sd_setImage(with: URL(string: movie?.posterX600 ?? "")) { [weak self] _, _, _, _ in
            guard let self = self else { return }
            self.movieImageView.hideSkeleton()
            self.movieImageView.isSkeletonable = false
        }
        self.rateLabel.text = movie?.imdbRating
        self.titleLabel.text = movie?.title
        self.dateLabel.text = movie?.releasedDate
        self.imdbImageView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didImdbImageViewTapped))
        self.imdbImageView.addGestureRecognizer(gesture)
    }
    
    private func initObservers() {
        viewModel.movie.bind { movie in
            self.initViews(movie: movie)
            self.trackScreen()
        }
    }
    
    /// User can display the movie on browser with IMDb url.
    @objc private func didImdbImageViewTapped() {
        if let movie = viewModel.movie.value, let url = URL(string: Globals.shared.imdbBaseUrl + (movie.imdbID ?? "")) {
            Utilities.openUrl(url: url)
        }
    }
    
    private func trackScreen() {
        guard let params = viewModel.movie.value?.modelToDict() as? [String: Any] else { return }
        FirebaseManager.shared.trackScreen(viewController: "MovieDetailViewController", params: params)
    }
}
