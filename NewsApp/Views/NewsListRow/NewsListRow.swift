//
//  NewsListRow.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import SwiftUI
import Combine

struct NewsListRow<ViewModel: NewsListRowViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        NavigationLink(
            destination: NewsView(viewModel: NewsViewModel(viewModel.article))
        ) {
            VStack(alignment: .leading, spacing: 15) {
                articleImage
                Text(viewModel.article.title)
                    .titleStyle()
                description
                HStack {
                    Spacer()
                    Text(viewModel.article.publishedDateString)
                        .dateStyle()
                }
            }
        }
        .isDetailLink(false)
        .onAppear { viewModel.getImage() }
    }
    
    @ViewBuilder
    var articleImage: some View {
        if viewModel.article.imageURL != nil {
            ArticleImage(image: $viewModel.articleImage)
        }
    }
    
    @ViewBuilder
    var description: some View {
        if let description = viewModel.article.description {
            Text(description)
                .descriptionStyle()
        }
    }
}

struct NewsListRow_Previews: PreviewProvider {
    static var previews: some View {
        NewsListRow(viewModel: NewsListRowViewModel(.mockArticle1))
    }
}
