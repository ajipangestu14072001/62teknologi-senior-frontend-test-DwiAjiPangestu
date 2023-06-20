import SwiftUI
import Combine

struct ContentView: View {
    @StateObject private var viewModel = BusinessListViewModel()
    
    @State private var searchText = ""
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(searchText: $searchText, isSearching: $isSearching, onSearchTextChange: { text in
                    viewModel.resetPagination()
                    viewModel.fetchBusinesses(with: text)
                }, onCancelButtonClicked: {
                    searchText = ""
                    isSearching = false
                    viewModel.resetPagination()
                    viewModel.fetchBusinesses()
                })
                
                if viewModel.isLoading && viewModel.businesses.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.businesses, id: \.id) { business in
                        NavigationLink(destination: DetailView(businessID: business.id)) {
                            BusinessCell(business: business)
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(currentItem: business)
                                }
                        }
                    }
                }
            }
            .navigationBarTitle("Businesses")
        }
        .onAppear {
            viewModel.fetchBusinesses()
        }
    }
}





