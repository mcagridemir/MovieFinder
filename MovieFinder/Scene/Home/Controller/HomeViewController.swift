//
//  HomeViewController.swift
//  MovieFinder
//
//  Created by Çağrı Demir on 9.04.2022.
//

import UIKit

class HomeViewController: BaseViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        initViews()
    }
    
    private func initViews() {
        hideNavbar = true
        initSearchField()
        initTableView()
    }
    
    private func initObservers() {
        viewModel.movies.bind { [weak self] _ in
            guard let self = self else { return }
            self.reloadData()
        }
        viewModel.totalMovieCount.bind { [weak self] count in
            guard let self = self else { return }
            self.countLabel.text = LocalizationKeys.moviesFound(count ?? "0")
        }
        viewModel.isLoading.bind { isLoading in
            isLoading ?? false ? Loader.show() : Loader.hide()
        }
        viewModel.error.bind { error in
            DispatchQueue.main.async {
                Alert.error(title: "", text: error?.rawValue ?? "")
            }
        }
    }
    
    private func initTableView() {
        tableView.registerNib(MovieTableViewCell.self)
    }
    
    private func initSearchField() {
        searchTextField.delegate = self
        searchTextField.returnKeyType = .search
        searchTextField.becomeFirstResponder()
        searchTextField.attributedPlaceholder = NSAttributedString(string: LocalizationKeys.searchPlaceholder.localized, attributes: [.foregroundColor: Assets.Colors.MainColors.mainGray.color])
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    
    private func getMovies(searchText: String, noLoading: Bool = false, shouldRefresh: Bool = false ) {
        viewModel.getMovies(query: searchText, noLoading: noLoading, shouldRefresh: shouldRefresh)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.isEmpty {
            self.viewModel.removeMovies()
            reloadData()
        }
        
        guard Utilities.hasAtLeast1Character(text: text), text.count >= 3 else { return }
        getMovies(searchText: text, shouldRefresh: true)
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentMovieCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath) else { return UITableViewCell() }
        let movie = viewModel.movies.value?[indexPath.row]
        cell.initCell(movie: movie)
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.shouldDisplayLoading {
            let view = UIView()
            let spinner = UIActivityIndicatorView()
            spinner.startAnimating()
            spinner.color = .black
            spinner.frame = CGRect(x: (tableView.frame.width / 2) - 25, y: 0, width: 50, height: 50)
            view.removeFromSuperview()
            view.addSubview(spinner)
            return view
        }
        return UICollectionReusableView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let movie = viewModel.movies.value?[indexPath.row] else { return }
        HomeRouter.showDetail(id: movie.imdbID, nav: self.navigationController)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1 == viewModel.movies.value?.count ?? 0) && viewModel.isMore && !viewModel.shouldDisplayLoading {
            viewModel.shouldDisplayLoading = true
            getMovies(searchText: searchTextField.text ?? "", noLoading: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.shouldDisplayLoading ? 60 : 0
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
