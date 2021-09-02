//
//  NewsView.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 02.09.21.
//

import SwiftUI

struct NewsView<ViewModel: NewsViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            articleImage
            Text(viewModel.article.title)
                .titleStyle()
            HStack {
                Spacer()
                Text(viewModel.article.publishedDateString)
                    .dateStyle()
            }
            articleContent
            linkToURL
            Spacer()
        }
        .padding()
        .onAppear { viewModel.fetchImageIfNeeded() }
    }
    
    @ViewBuilder
    var articleContent: some View {
        if let content = viewModel.articleContent {
            HStack {
                Text(content)
                    .descriptionStyle()
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    var articleImage: some View {
        if viewModel.article.imageURL != nil {
            ArticleImage(image: $viewModel.articleImage)
        }
    }
    
    @ViewBuilder
    var linkToURL: some View {
        if let url = viewModel.article.url {
            HStack {
                Spacer()
                Link(destination: url) {
                    Group {
                        Text("Open in browser")
                        Image(systemName: "arrowshape.turn.up.right.fill")
                    }
                    .foregroundColor(Color(.systemBlue))
                }
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(viewModel: NewsViewModel(.mockArticle1))
    }
}
