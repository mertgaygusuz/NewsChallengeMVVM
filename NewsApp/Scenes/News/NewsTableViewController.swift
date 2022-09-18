//
//  NewsTableViewController.swift
//  NewsApp
//
//  Created by Mert Gaygusuz on 6.09.2022.
//

import UIKit
import Kingfisher

final class NewsTableViewController: UIViewController {
    
//MARK: - Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.cellId)
        tableView.rowHeight = 140
        return tableView
    }()
    
    var viewModel = NewsViewModel()
    var searchedText: String = ""
    var page = 1

//MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContents()
        addSubViews()
        showLoadingView()

        viewModel.delegate = self
        viewModel.loadNews(key: nil, type: .listHeadlines, page: 1)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

}

//MARK: - AddSubView

extension NewsTableViewController {
    
    private func addSubViews() {
        addTableViewController()
    }
    
    private func addTableViewController() {
        view.addSubview(tableView)
    }
}

//MARK: - ConfigureContents

extension NewsTableViewController {
    
    private func configureContents() {
        configureSearchController()
        configureNavigationController()
    }
    
    private func configureNavigationController() {
        navigationItem.title = "News"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.black
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search the news"
        navigationItem.searchController = searchController
    }
}

//MARK: - NewsModelDelegate
extension NewsTableViewController: NewsViewModelDelegate {
    
    func apiRequestCompleted() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.dismissLoadingView()
        }
    }
}

//MARK: - UITableViewDelegate & UITableViewDataSource
extension NewsTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.cellId,for: indexPath) as! NewsCell
        let cellItem = viewModel.news[indexPath.row]
        cell.selectionStyle = .none
        cell.title.text = cellItem.title
        cell.newsDescription.text = cellItem.description

        let url = URL(string: viewModel.news[indexPath.row].image ?? "")
        cell.newsImage.kf.setImage(with: url, placeholder: NewsImages.placeholder)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destinationVc = NewsDetailViewController()
        destinationVc.viewModel.news = viewModel.news[indexPath.row]
        navigationController?.pushViewController(destinationVc, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            page += 1
            viewModel.loadNews(key: searchedText, type: .search, page: page)
        }
    }
}

//MARK: - UISearchBarDelegate
extension NewsTableViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchedText = searchText
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchNewText), object: nil)
        perform(#selector(self.searchNewText), with: nil, afterDelay: 0.5)
    }
    
    @objc private func searchNewText(text: String) {
        if self.searchedText.count > 3 {
            viewModel.news = []
            viewModel.loadNews(key: searchedText, type: .search, page: page)
        }
    }
}
