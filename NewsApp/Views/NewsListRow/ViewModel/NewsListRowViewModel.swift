//
//  NewsListRowViewModel.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 02.09.21.
//

import Foundation
import SwiftUI
import Combine

class NewsListRowViewModel: NewsListRowViewModelType, ObservableObject {
    @Published var article: Article
    @Published var articleImage: UIImage?
    
    private let imageDownloader = ImageDownloader()
    
    init(_ article: Article) {
        self.article = article
    }
    
    func getImage() {
        imageDownloader.imagePublisher(for: article.imageUrlString ?? "")
            .assign(to: &$articleImage)
    }
}
