//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 02.09.21.
//

import Foundation
import SwiftUI
import Combine

class NewsViewModel: NewsViewModelType, ObservableObject {
    @Published var article: Article
    @Published var articleImage: UIImage?
    var articleContent: String?
    
    private let imageDownloader = ImageDownloader()
    private var cancellables = Set<AnyCancellable>()
    
    init(_ article: Article) {
        self.article = article
        bindOutputs()
    }
    
    func fetchImageIfNeeded() {
        imageDownloader.imagePublisher(for: article.imageUrlString ?? "")
            .assign(to: &$articleImage)
    }
    
    private func bindOutputs() {
        $article
            .sink { [weak self] article in
                self?.articleContent = self?.formatArticleContent(article.content)
            }
            .store(in: &cancellables)
    }
    
    private func formatArticleContent(_ content: String?) -> String? {
        guard content?.count ?? 0 > 200 else { return content }
        
        return content?
            .components(separatedBy: "[")
            .dropLast()
            .joined()
    }
}
