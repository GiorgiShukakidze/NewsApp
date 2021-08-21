//
//  NewsListView.swift
//  NewsApp
//
//  Created by Giorgi Shukakidze on 17.08.21.
//

import SwiftUI

struct NewsListView<ViewModel: NewsListViewModelType>: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if viewModel.state != .loading {
                    refreshButton
                }
                List {
                    ForEach(viewModel.articles, id: \.id) { article in
                        NewsListRow(article: article)
                    }
                    
                    if viewModel.hasMorePages {
                        loadingMoreCell
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
        .overlay(loadingOverlay)
        .onAppear { viewModel.fetchArticles() }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Fetching articles failed"), message: Text(viewModel.errorMessage))
        }
    }
    
    @ViewBuilder
    var loadingOverlay: some View {
        if viewModel.state == .loading {
            Color(.gray)
                .opacity(0.2)
                .ignoresSafeArea()
        }
    }
    
    var loadingMoreCell: some View {
        HStack(alignment: .center) {
            Spacer()
            Text("Loading more...")
                .foregroundColor(.blue)
            Spacer()
        }
    }
    
    var refreshButton: some View {
        HStack {
            Spacer()
            Button(action: { viewModel.refresh() }, label: {
                Label(
                    title: { Text("Refresh").font(.callout.bold()) },
                    icon: { Image(systemName: "arrow.clockwise") }
                )
                
            })
            .padding(8)
            .foregroundColor(.white)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.purple)
            )
            .padding(.horizontal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NewsListView(viewModel: NewsListViewModel())
    }
}
