//
//  Extensions.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import SwiftUI

extension Image {
    func articleImageStyle() -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color(.lightGray))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension String: Identifiable {
    public var id: String { return self }
}
