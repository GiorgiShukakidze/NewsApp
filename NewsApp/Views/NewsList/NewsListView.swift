//
//  NewsListView.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import SwiftUI

struct NewsListView<ViewModel: NewsListViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    @State var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.state != .loading {
                    NewsRefreshButton(refreshAction: viewModel.refresh)
                }
                List {
                    ForEach(viewModel.articles, id: \.id) { article in
                        NewsListRow(article: article)
                    }
                    
                    if viewModel.hasMorePages {
                        LoadingMoreCell()
                            .onAppear { viewModel.fetchNextPage() }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            
            if viewModel.state == .loading {
                ProgressView().scaleEffect(2)
            }
            
            if viewModel.state == .empty {
                Text("No items to show...")
            }
        }
        .onChange(of: viewModel.state) { isLoading = $0 == .loading }
        .overlay(LoadingOverlay(show: $isLoading))
        .onAppear { viewModel.fetchArticles() }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Fetching articles failed"), message: Text(viewModel.errorMessage))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView(viewModel: NewsListViewModel())
    }
}
