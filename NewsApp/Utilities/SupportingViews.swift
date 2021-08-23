//
//  SupportingViews.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 23.08.21.
//

import Foundation
import SwiftUI

struct ArticleImage: View {
    @Binding var image: UIImage?
    
    var body: some View {
        if image == nil {
            Image(systemName: "photo")
                .articleImageStyle()
        }
        if let uiImage = image {
            Image(uiImage: uiImage)
                .articleImageStyle()
        }
    }
}

struct NewsRefreshButton: View {
    var refreshAction: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: { refreshAction() }) {
                Label(
                    title: { Text("Refresh").font(.callout.bold()) },
                    icon: { Image(systemName: "arrow.clockwise") }
                )
                
            }
            .padding(8)
            .foregroundColor(.white)
            .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.purple))
            .padding(.horizontal)
        }
    }
}

struct LoadingMoreCell: View {
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            Text("Loading more...")
                .foregroundColor(.blue)
            Spacer()
        }
    }
}

struct LoadingOverlay: View {
    @Binding var show: Bool
    
    var body: some View {
        if show {
            Color(.gray)
                .opacity(0.5)
                .ignoresSafeArea()
        }
    }
}
