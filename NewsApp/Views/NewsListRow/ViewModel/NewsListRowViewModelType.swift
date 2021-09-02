//
//  NewsListRowViewModelType.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 02.09.21.
//

import Foundation
import SwiftUI

protocol NewsListRowViewModelType: ObservableObject {
    var article: Article { get }
    var articleImage: UIImage? { get set }
    
    func getImage()
}
