//
//  ComicData.swift
//  ComicBangScroll
//
//  Created by nakandakari on 2020/08/24.
//  Copyright © 2020 nakandakari. All rights reserved.
//

import Foundation
import UIKit

struct ComicData {

    let title: String
    let description: String
    
    init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

final class ComicDataCreator {
    
    static func DummyComicData(volumeCount: Int, createCount: Int) -> [ComicData] {
        var comicData = [ComicData]()
        for num in 1...createCount {
            comicData.append(self.DummyComicData(volumeCount: volumeCount, chapterNum: num))
        }
        return comicData
    }
    
    private static func DummyComicData(volumeCount: Int, chapterNum: Int) -> ComicData {
        return ComicData(title: "第\(volumeCount)巻", description: "DummyTitle \(chapterNum)話")
    }
}

final class ComicCoverCreator {
    
    static let dummyPlaceholdUrl: String = "https://placehold.jp/80x80.png"
    
    static func DummyComicCoverImage() -> UIImage {
        let url = URL(string: dummyPlaceholdUrl)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
}
