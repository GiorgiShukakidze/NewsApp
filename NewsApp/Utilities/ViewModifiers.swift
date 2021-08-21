//
//  ViewModifiers.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 18.08.21.
//

import SwiftUI

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .font(.callout.bold())
            .foregroundColor(Color(.purple))
    }
}

struct DescriptionStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundColor(Color(.darkGray))
    }
}

struct DateStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote.italic())
            .foregroundColor(.gray)
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(TitleStyle())
    }
    
    func descriptionStyle() -> some View {
        self.modifier(DescriptionStyle())
    }
    
    func dateStyle() -> some View {
        self.modifier(DateStyle())
    }
}
