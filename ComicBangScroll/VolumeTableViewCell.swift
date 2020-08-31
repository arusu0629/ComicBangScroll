//
//  VolumeTableViewCell.swift
//  ComicBangScroll
//
//  Created by nakandakari on 2020/08/25.
//  Copyright © 2020 nakandakari. All rights reserved.
//

import UIKit

class VolumeTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var comicCoverView: UIImageView!
    @IBOutlet private weak var volumeLabel: UILabel!
    @IBOutlet private weak var viewTopConstraint: NSLayoutConstraint!
    private let defaultTopConstraint: CGFloat = 20
    private let imageAndLabelViewHeight: CGFloat = 150
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}

// MARK: Setup
extension VolumeTableViewCell {
    
    func setup(data: ComicData) {
        self.volumeLabel.text = data.title
        self.comicCoverView.image = ComicCoverCreator.DummyComicCoverImage()
    }
}

// MARK: Move
extension VolumeTableViewCell {
    
    func canAddContentOffset(_ offset: CGFloat) -> Bool {
        return self.frame.height >= offset + self.imageAndLabelViewHeight
    }
    
    func addContentOffset(_ offset: CGFloat) {
        if self.canAddContentOffset(offset) {
            self.viewTopConstraint.constant = max(defaultTopConstraint + offset, defaultTopConstraint)
            self.layoutIfNeeded()
        } else {
            self.viewTopConstraint.constant = self.frame.height - self.imageAndLabelViewHeight + defaultTopConstraint
        }
    }
}
