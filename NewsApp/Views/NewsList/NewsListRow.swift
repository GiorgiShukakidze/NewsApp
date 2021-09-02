//
//  NewsListRow.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import SwiftUI

struct NewsListRow: View {
    @State var article: Article
    @State private var image: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            articleImage
            Text(article.title)
                .titleStyle()
            description
            linkToURL
            HStack {
                Spacer()
                Text(article.publishedDateString)
                    .dateStyle()
            }
        }
        .onAppear {
            UIImage.from(article.imageUrlString ?? "") { uiImage in
                image = uiImage
            }
        }
    }
    
    @ViewBuilder
    var articleImage: some View {
        if article.imageURL != nil {
            ArticleImage(image: $image)
        }
    }
    
    @ViewBuilder
    var description: some View {
        if let description = article.description {
            Text(description)
                .descriptionStyle()
        }
    }
    
    @ViewBuilder
    var linkToURL: some View {
        if let url = article.url {
            Link(destination: url, label: {
                Text("Tap to open details...")
                    .font(.footnote)
                    .italic()
                    .foregroundColor(.secondary)
            })
        }
    }
}
