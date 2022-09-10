//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Mert Gaygusuz on 9.09.2022.
//

import UIKit
import SnapKit
import Kingfisher
import SafariServices

final class NewsDetailViewController: UIViewController {
    
//MARK: - Properties
    var viewModel = NewsDetailViewModel()
    
// MARK: - UI Properties
    private lazy var newsImage: UIImageView = {
        let image = UIImageView()
        image.sizeToFit()
        image.image = NewsImages.placeholder
        return image
    }()
    
    private lazy var newsTitle: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.numberOfLines = 0 // 2
        return titleLabel
    }()
    
    private lazy var newsDescription: UILabel = {
        let newsLabel = UILabel()
        newsLabel.font = UIFont.systemFont(ofSize: 16)
        newsLabel.numberOfLines = 0
        return newsLabel
    }()
    
    private lazy var contentView = UIView()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private lazy var authorView = NewsAdditionalInfoView(text: viewModel.news?.author ?? "Unknown", contentType: .authorInfoView)
    
    private lazy var dateView = NewsAdditionalInfoView(text: viewModel.news?.publishDate ?? "Unknown", contentType: .dateView)
    
    private lazy var additionalInfoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorView, dateView])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var newsPageButton: UIButton = {
        let button = UIButton()
        button.setTitle("Keep Reading", for: .normal)
        button.addTarget(self, action: #selector(newsPageButtonClicked), for: .touchUpInside)
        button.setTitleColor(.black, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 15.0
        button.backgroundColor = .systemGray4
        return button
    }()
    
// MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureNavigationTabBar()
        configureNavigationController()
        
        scrollView.backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBackground

        let url = URL(string: viewModel.news?.image ?? "")
        newsImage.kf.setImage(with: url, placeholder: NewsImages.placeholder)
        newsTitle.text = viewModel.news?.title
        newsDescription.text = viewModel.news?.description
    }
    
    private func configureNavigationController() {
        title = "News Detail"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func configureNavigationTabBar() {
        let favoriteButtonImage = UIImage(systemName: NewsImages.favoritesImageSF)?.withTintColor(UIColor.black, renderingMode: .alwaysOriginal)
        let favoriteButton = UIBarButtonItem(image: favoriteButtonImage, style: .plain, target: self, action: #selector(favoriteButtonClicked))
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareButtonClicked))
        shareButton.tintColor = .black
        navigationItem.rightBarButtonItems = [favoriteButton, shareButton]
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(newsImage)
        contentView.addSubview(newsTitle)
        contentView.addSubview(additionalInfoStackView)
        contentView.addSubview(newsDescription)
        view.addSubview(newsPageButton)
    }
    
//MARK: - Configure UI
    override func viewDidLayoutSubviews() {
        
        newsImage.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.height.equalTo(view.snp.height).multipliedBy(0.30)
        }

        newsTitle.snp.makeConstraints { (make) in
            make.top.equalTo(newsImage.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.height.equalTo(view.snp.height).multipliedBy(0.05)
        }

        additionalInfoStackView.snp.makeConstraints { (make) in
            make.top.equalTo(newsTitle.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(18)
            make.right.equalToSuperview().offset(-18)
            make.height.equalTo(view.snp.height).multipliedBy(0.05)
        }

        newsDescription.snp.makeConstraints { (make) in
            make.top.equalTo(additionalInfoStackView.snp.bottom).offset(22)
            make.left.equalTo(contentView.snp.left).offset(12)
            make.right.equalTo(contentView.snp.right).offset(-12)
            make.bottom.equalTo(contentView.snp.bottom)
        }

        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(view.snp.bottom)
        }

        contentView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        newsPageButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-4)
            make.height.equalTo(view.snp.height).multipliedBy(0.05)
        }
    }
    
//MARK: - Button Actions
    @objc func newsPageButtonClicked() {
        guard let url = URL(string: (viewModel.news?.urlLink)!) else { return }
            let destinationVC = SFSafariViewController(url: url)
            print(url)
            destinationVC.delegate = self
            present(destinationVC, animated: true)
    }
    
    @objc func favoriteButtonClicked() {
        self.presentAlert(title: "Added Favorites", message: "This news added favorites for you!")
        viewModel.favoriteNews()
    }
    
    @objc func shareButtonClicked() {
        if let title = viewModel.news?.title, let newsWebsiteURL = NSURL(string: (viewModel.news?.urlLink)!) {
            let shareObjects = [title, newsWebsiteURL] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareObjects, applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
}

//MARK: - SFSafariViewControllerDelegate
extension NewsDetailViewController: SFSafariViewControllerDelegate {

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
