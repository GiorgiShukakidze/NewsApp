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
        Button(action: { refreshAction() }) {
            Image(systemName: "arrow.clockwise")
        }
        .padding(6)
        .foregroundColor(.white)
        .background(Circle().foregroundColor(.purple))
        .padding(.horizontal)
    }
}

struct LoadingMoreCell: View {
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .purple))
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

struct IdentifiableAlert: Identifiable {
    var id: String
    var alert: () -> Alert
    
    init(title: String, message: String) {
        self.id = title + message
        alert = { Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK"))) }
    }
}
