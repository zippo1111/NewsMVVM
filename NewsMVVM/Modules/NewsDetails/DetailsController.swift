//
//  DetailsController.swift
//  NewsMVVM
//
//  Created by Mangust on 27.08.2024.
//

import UIKit

final class DetailsController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
    }
}
