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
            if article.imageURL != nil {
                ArticleImage(image: $image)
            }
            Text(article.title)
                .titleStyle()
            
            if let description = article.description {
                Text(description)
                    .descriptionStyle()
            }
            
            if let url = article.url {
                Link(destination: url, label: {
                    Text("Tap to open details...")
                        .font(.footnote)
                        .italic()
                        .foregroundColor(.secondary)
                })
            }
            
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
}
