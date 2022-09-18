//
//  FavoritesTableViewController.swift
//  NewsApp
//
//  Created by Mert Gaygusuz on 6.09.2022.
//

import UIKit
import Kingfisher
import SafariServices

final class FavoritesTableViewController: UIViewController {

//MARK: - Properties
    var tableView = UITableView()
    let viewModel = FavoritesTableViewModel()
    
//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavoritedNews()
        isEmpty()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        title = "Favorites"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.cellId)
        tableView.rowHeight = 140
    }
    
    private func isEmpty() {
        if viewModel.favoritedNews.count == 0 {
            tableView.isHidden = true
            showEmptyStateView(title: "Your Favorite News.", message: "News you add to favorites appear here.", imageString: NewsImages.circleHeartImageSF, in: view)
        } else {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.isHidden = false
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}

//MARK: - Extension UITableViewDelegate & UITableViewDataSource

extension FavoritesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoritedNews.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: viewModel.favoritedNews[indexPath.row].urlLink!) else { return }
        let destinationVC = SFSafariViewController(url: url)
        destinationVC.delegate = self
        present(destinationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellId, for: indexPath) as! NewsCell
        let cellItem = viewModel.favoritedNews[indexPath.row]
        let url = URL(string: cellItem.image ?? "")
        cell.selectionStyle = .none
        cell.title.text = cellItem.title
        cell.newsDescription.text = cellItem.newsDescription
        cell.newsImage.kf.setImage(with: url, placeholder: NewsImages.placeholder)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.viewModel.deleteFavoriteNews(item: self.viewModel.favoritedNews[indexPath.row])
            viewModel.getFavoritedNews()
            tableView.deleteRows(at: [indexPath], with: .fade)
            isEmpty()
        }
    }
}

//MARK: - SFSafariViewControllerDelegate
extension FavoritesTableViewController: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
