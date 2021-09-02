//
//  PreviewViewModel.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 02.09.21.
//

import Foundation

class PreviewViewModel: NewsListViewModelType, ObservableObject {
    var articles: [Article] = [
        Article(title: "Mock Article",
                description: "Mock Article Description",
                publishedAt: Date(),
                urlString: "",
                imageUrlString: "https://images.unsplash.com/photo-1593642634367-d91a135587b5?ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80"
        ),
        Article(title: "Mock Article 2",
                                  description: "Mock Article Description 2",
                                  publishedAt: Date(),
                                  urlString: "",
                                  imageUrlString: "https://images.unsplash.com/photo-1630560264774-167d0ae1180b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80"
        )
    ]
    var state: NewsViewModelState = .complete
    var hasMorePages: Bool = true
    
    func fetchArticles() {}
    func fetchNextPage() {}
    func refresh() {}
}
