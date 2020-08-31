//
//  SecondViewController.swift
//  ComicBangScroll
//
//  Created by nakandakari on 2020/08/25.
//  Copyright © 2020 nakandakari. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var comicData: ComicData!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
}

// MARK: Setup
extension SecondViewController {
    
    func setup(data: ComicData) {
        self.comicData = data
    }
    
    func setupUI() {
        self.titleLabel.text = self.comicData.title
        self.descriptionLabel.text = self.comicData.description
    }
}

extension SecondViewController {
    
    @IBAction private func didTapBackButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
