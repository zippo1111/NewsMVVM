//
//  NewsController.swift
//  NewsMVVM
//
//  Created by Mangust on 25.08.2024.
//

import UIKit

import SnapKit


final class NewsController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(collectionView)
        view.addSubview(spinner)
        spinner.startAnimating()

        Task {
            articlesPageViewModel = await viewModel.fetchNextNews(page: .zero)

            await MainActor.run {
                collectionView.reloadData()
                spinner.stopAnimating()
            }
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        configureConstraints()
    }


    func configureConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }

        spinner.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func animate(_ cell: UICollectionViewCell, callback: ((Bool) -> Void)?) {
        let transform = CGAffineTransform.identity.scaledBy(x: 0.98, y: 0.98)
        UIView.animate(withDuration: 0.2,
                       delay: .zero,
                       usingSpringWithDamping: 0.4,
                       initialSpringVelocity: .zero,
                       options: [.curveEaseIn],
                       animations: {
            cell.transform = transform
        }, completion: callback)
    }

    private func deAnimate(_ cell: UICollectionViewCell) {
        UIView.animate(withDuration: 0.2, delay: .zero) {
            cell.transform = CGAffineTransform.identity
        }
    }

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
                frame: .zero,
                collectionViewLayout: CustomLayout(
                    interItemSpacing: Constants.interItemSpacing,
                    scrollDirection: .vertical,
                    itemHeight: Constants.defaultItemHeight
                )
            )

            collectionView.backgroundColor = .white
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.scrollsToTop = true
        

            collectionView.register(
                NewsArticleCell.self,
                forCellWithReuseIdentifier: String(describing: NewsArticleCell.self)
            )

        return collectionView
    }()

    private var articlesPageViewModel: NewsArticlesPageViewModel?
    private var scrolledToTop = false
    private var scrolledToBottom = false

    private let viewModel = NewsViewModel()
    private let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
}

extension NewsController: UICollectionViewDelegate {

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.scrolledToTop {
            scrolledToTop = true
            scrolledToBottom = false

            if scrolledToTop == true,
               let currentPage = articlesPageViewModel?.currentPage,
               currentPage > 1,
               !spinner.isAnimating {
                spinner.startAnimating()

                Task {
                    guard let data = await viewModel.fetchPrevNews(page: currentPage) else {
                        return
                    }

                    articlesPageViewModel = data

                    await MainActor.run {
                        collectionView.reloadData()
                        spinner.stopAnimating()
                    }
                }
            }
            
        } else if scrollView.scrolledToBottom {
            scrolledToBottom = true
            scrolledToTop = false

            if scrolledToBottom == true,
               let currentPage = articlesPageViewModel?.currentPage,
               !spinner.isAnimating {
                spinner.startAnimating()

                Task {
                    guard let data = await viewModel.fetchNextNews(page: currentPage) else {
                        return
                    }

                    articlesPageViewModel = data

                    await MainActor.run {
                        collectionView.reloadData()
                        spinner.stopAnimating()
                    }
                }

            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        animate(cell) { [weak self] _ in
            self?.goToDetails()
            self?.deAnimate(cell)
        }
    }
}

extension NewsController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        articlesPageViewModel?.articles.count ?? .zero
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: NewsArticleCell.self),
            for: indexPath
        ) as? NewsArticleCell {
            cell.selectedBackgroundView?.backgroundColor = .cyan
            cell.isUserInteractionEnabled = true
            cell.configure(
                viewModel: articlesPageViewModel?.articles[safeIndex: indexPath.row],
                defaultItemHeight: Constants.defaultItemHeight
            )

            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

fileprivate extension NewsController {

    func goToDetails() {
        navigationController?.pushViewController(DetailsController(), animated: true)
    }

    enum Constants {
        static let interItemSpacing: CGFloat = 2
        static let defaultItemHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 320 : 120
    }
}
