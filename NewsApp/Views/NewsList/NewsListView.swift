//
//  NewsListView.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import SwiftUI

struct NewsListView<ViewModel: NewsListViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    
    @State private var isLoading: Bool = false
    @State private var alertToShow: IdentifiableAlert?

    var body: some View {
        ZStack {
            VStack {
                refreshButton
                List {
                    ForEach(viewModel.articles, id: \.id) { article in
                        NewsListRow(article: article)
                    }
                    
                    loadingMoreView
                }
                .listStyle(InsetGroupedListStyle())
            }
            
            stateView
        }
        .onChange(of: viewModel.state) { handleStateChange($0) }
        .overlay(LoadingOverlay(show: $isLoading))
        .onAppear { viewModel.fetchArticles() }
        .alert(item: $alertToShow) { $0.alert() }
    }
    
    @ViewBuilder
    var stateView: some View {
        switch viewModel.state {
        case .loading:
            ProgressView().scaleEffect(2)
        case .empty:
            Text("No items to show...")
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var refreshButton: some View {
        if viewModel.state != .loading {
            NewsRefreshButton(refreshAction: viewModel.refresh)
        }
    }
    
    @ViewBuilder
    var loadingMoreView: some View {
        if viewModel.hasMorePages {
            LoadingMoreCell()
                .onAppear { viewModel.fetchNextPage() }
        }
    }
    
    private func handleStateChange(_ state: NewsViewModelState) {
        isLoading = state == .loading
        
        switch state {
        case .error(let message):
            alertToShow = .init(title: "Fetching articles failed", message: message)
        default:
            break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView(viewModel: PreviewViewModel())
    }
}
