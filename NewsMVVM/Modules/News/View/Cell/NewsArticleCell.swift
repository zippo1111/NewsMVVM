//
//  NewsArticleCell.swift
//  NewsMVVM
//
//  Created by Mangust on 25.08.2024.
//

import UIKit

import SnapKit

final class NewsArticleCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewModel: NewsArticleViewModel?, defaultItemHeight: CGFloat = Constants.defaultItemHeight) {
        guard let viewModel = viewModel else {
            return
        }

        self.defaultItemHeight = defaultItemHeight

        setupData(viewModel)
        configureConstraints()
    }

    private func setupView() {
        addSubview(stack)
    }

    private func configureConstraints() {
        leftImageView.snp.makeConstraints {
            $0.height.equalTo(defaultItemHeight)
            $0.width.lessThanOrEqualTo(defaultItemHeight * 2.4)
        }

        stack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.bottom.right.equalToSuperview().inset(Constants.offset)
        }
    }

    private func setupData(_ viewModel: NewsArticleViewModel) {
        rightLabel.text = viewModel.title
        leftImageView.image = viewModel.titleImage
    }

    private var defaultItemHeight: CGFloat = .zero

    private let leftImageView: UIImageView = {
        let image = UIImage()
        let imageView = UIImageView(image: image)
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true

        return imageView
    }()

    private let rightLabel: UILabel = {
        let label = UILabel(frame: .zero)
        let fontSize: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 30 : 14
        label.font = UIFont(name: "Times-Italic", size: fontSize)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        label.textAlignment = .right

        return label
    }()

    private lazy var stack: UIStackView = { [weak self] in
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = Constants.offset * 2

        guard let imageStack = self?.imageStack, let labelStack = self?.labelStack else {
            return stack
        }

        stack.addArrangedSubview(imageStack)
        stack.addArrangedSubview(labelStack)

        return stack
    }()

    private lazy var imageStack: UIStackView = { [weak self] in
        let stack = UIStackView()
        stack.axis = .horizontal

        guard let imageView = self?.leftImageView else {
            return stack
        }

        stack.addArrangedSubview(imageView)

        return stack
    }()

    private lazy var labelStack: UIStackView = { [weak self] in
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .top

        guard let label = self?.rightLabel else {
            return stack
        }

        stack.addArrangedSubview(label)

        return stack
    }()

    private let containerView: UIView = {
        let view = UIView()
        let hexEEE = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 0.4).cgColor

        view.backgroundColor = .white
        view.layer.borderColor = hexEEE
        view.layer.borderWidth = 1
        return view
    }()
}

fileprivate extension NewsArticleCell {
    enum Constants {
        static let offset: CGFloat = 10
        static let imageLabelOffset: CGFloat = 40
        static let defaultItemHeight: CGFloat = 80
    }
}
