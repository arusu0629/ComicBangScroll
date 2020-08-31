//
//  ViewController.swift
//  ComicBangScroll
//
//  Created by nakandakari on 2020/08/24.
//  Copyright © 2020 nakandakari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let volumeCount: Int = 10 // 単行本数
    private let chapterCountPerVolume: Int = 5 // 1巻当たりの話数
    private var comicData: [[ComicData]] = [[ComicData]]()
    private var volumeCellHeightList: [IndexPath: CGFloat] = [:]
    
    @IBOutlet private weak var chapterTableView: UITableView! {
        willSet {
            newValue.register(UINib(nibName: String(describing: ChapterTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ChapterTableViewCell.self))
            newValue.delaysContentTouches = false
        }
    }
    @IBOutlet private weak var volumeTableView: UITableView! {
        willSet {
            newValue.register(UINib(nibName: String(describing: VolumeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: VolumeTableViewCell.self))
            newValue.delaysContentTouches = false
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.volumeTableViewTapped(_:)))
            newValue.addGestureRecognizer(tapGesture)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadComicData()
    }
    
    private func loadComicData() {
        for volume in 1...self.volumeCount {
            let volumeComicData = ComicDataCreator.DummyComicData(volumeCount: volume, createCount: self.chapterCountPerVolume)
            self.comicData.append(volumeComicData)
        }
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // ChapterTableView
        if self.chapterTableView == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChapterTableViewCell.self)) as! ChapterTableViewCell
            let comicData = self.comicData[indexPath.section][indexPath.row]
            cell.setup(title: comicData.title, description: comicData.description)
            return cell
        }
        // VolumeTableView
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: VolumeTableViewCell.self)) as! VolumeTableViewCell
        cell.setup(data: self.comicData[indexPath.section][indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // ChapterTableView
        if self.chapterTableView == tableView {
            return self.comicData.count
        }
        // VolumeTableView
        return self.volumeCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // ChapterTableView
        if self.chapterTableView == tableView {
            return self.comicData[section].count
        }
        // VolumeTableView
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // ChapterTableViewCell
        if self.chapterTableView == tableView {
            return ChapterTableViewCell.CellHeight
        }
        // VolumeTableViewCell
        return self.calculateChapterSectionHeight(indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 単行本のセルの高さをキャッシュしておく
        if self.volumeTableView == tableView {
            self.volumeCellHeightList[indexPath] = cell.frame.height
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // ChapterTableViewCell
        if self.chapterTableView == tableView {
            return UITableView.automaticDimension
        }
        // VolumeTableViewCell
        guard let cellHeight = self.volumeCellHeightList[indexPath] else {
            return UITableView.automaticDimension
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.chapterTableView == tableView {
            let comicData = self.comicData[indexPath.section][indexPath.row]
            self.presentDetailViewController(data: comicData)
            return
        }
    }

    // 左側のセルをタップした場合はそのタップ領域の高さに相当する ComicData を取得してそのVCに遷移させる
    @objc func volumeTableViewTapped(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self.volumeTableView)
        
        guard let indexPathForTapped = self.chapterTableView.indexPathForRow(at: tapPoint) else {
            return
        }
        
        let comicData = self.comicData[indexPathForTapped.section][indexPathForTapped.row]
        self.presentDetailViewController(data: comicData)
    }
    
    private func presentDetailViewController(data: ComicData) {
        let bundle = Bundle(for: SecondViewController.self)
        let name = String(describing: SecondViewController.self)
        guard let vc = UIStoryboard(name: name, bundle: bundle).instantiateInitialViewController() as? SecondViewController else {
            fatalError("UIViewController.instantiate() failed: \(name)")
        }
        vc.setup(data: data)
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.chapterTableView == scrollView {
            self.volumeTableView.contentOffset.y = scrollView.contentOffset.y
        } else if self.volumeTableView == scrollView {
            self.chapterTableView.contentOffset.y = scrollView.contentOffset.y
        }
        
        self.move(offset: self.volumeTableView.contentOffset.y)
    }
}

// MARK: Volume Section Height
extension ViewController {
    
    private func calculateChapterSectionHeight(_ section: Int) -> CGFloat {
        let chapterCountInSection = self.comicData[section].count
        return ChapterTableViewCell.CellHeight * CGFloat(chapterCountInSection)
    }
}

// MARK: Move Volume Cell
extension ViewController {
    
    func move(offset: CGFloat) {
        for visibleCell in self.volumeTableView.visibleCells {
            guard let indexPath = self.volumeTableView.indexPath(for: visibleCell) else {
                continue
            }
            guard let cell = visibleCell as? VolumeTableViewCell else {
                continue
            }
            
            // セクションに合わせてスクロール量を再計算する
            var totalSectionHeight: CGFloat = 0.0
            if indexPath.section > 0 {
                totalSectionHeight = (0..<indexPath.section)
                .map { self.calculateChapterSectionHeight($0) }
                .reduce(0) { $0 + $1 }
            }
            let scrollOffsetInSection = offset - totalSectionHeight
            cell.addContentOffset(scrollOffsetInSection)
        }
    }
}
