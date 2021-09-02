//
//  NewsListViewModelType.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import Foundation
import Combine

protocol NewsListViewModelType: ObservableObject {
    var articles: [Article] { get }
    var state: ViewModelState { get }
    var hasMorePages: Bool { get }
    
    func fetchArticles()
    func fetchNextPage()
    func refresh()
}
