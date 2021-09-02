//
//  Extensions.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import SwiftUI

extension UIImage {
    static func from(_ urlString: String, _ imageContent: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let url = URL(string: urlString),
               let imageData = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    imageContent(UIImage(data: imageData))
                }
            }
        }
    }
}

extension Image {
    func articleImageStyle() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color(.lightGray))
    }
}

extension String: Identifiable {
    public var id: String { return self }
}
