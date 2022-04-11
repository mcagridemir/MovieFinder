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
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initObservers()
        initViews()
    }
    
    private func initViews() {
        hideNavbar = true
        warningLabel.text = LocalizationKeys.searchWarningEmpty.localized
        initSearchField()
        initTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    private func initObservers() {
        viewModel.movies.bind { [weak self] _ in
            guard let self = self else { return }
            self.reloadData()
            self.countLabel.isHidden = self.viewModel.currentMovieCount == 0
        }
        viewModel.totalMovieCount.bind { [weak self] countText in
            guard let self = self, let count = Int(countText ?? "0") else { return }
            self.countLabel.text = LocalizationKeys.moviesFound(countText ?? "0")
            self.warningLabel.isHidden = !(count == 0 || self.viewModel.movies.value == nil)
            self.tableView.isHidden = count == 0 || self.viewModel.movies.value == nil
            self.warningLabel.text = (count == 0 || self.viewModel.movies.value == nil) ? LocalizationKeys.searchNoResult.localized : LocalizationKeys.searchWarningEmpty.localized
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
            warningLabel.text = LocalizationKeys.searchWarningEmpty.localized
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
    
    @IBAction func didCancelButtonTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillAppear() {
        cancelButton.isUserInteractionEnabled = true
    }

    @objc private func keyboardWillDisappear() {
        cancelButton.isUserInteractionEnabled = false
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
        guard let movie = viewModel.movies.value?[indexPath.row], let id = movie.imdbID else { return }
        HomeRouter.showDetail(id: id, nav: self.navigationController)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == (viewModel.movies.value?.count ?? 0) - 1) && viewModel.hasMore && !viewModel.shouldDisplayLoading {
            viewModel.shouldDisplayLoading = true
            getMovies(searchText: searchTextField.text ?? "", noLoading: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
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
