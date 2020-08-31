//
//  ComicTableViewCell.swift
//  ComicBangScroll
//
//  Created by nakandakari on 2020/08/24.
//  Copyright © 2020 nakandakari. All rights reserved.
//

import UIKit

class ChapterTableViewCell: UITableViewCell {
    
    static let CellHeight: CGFloat = 80.0
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// MARK: Setup
extension ChapterTableViewCell {
    
    func setup(title: String, description: String) {
        self.titleLabel.text = title
        self.descriptionLabel.text = description
    }
}
