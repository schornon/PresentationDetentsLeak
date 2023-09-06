//
//  ContentView.swift
//  PresentationDetentsLeak
//
//  Created by mbp2 hilfy on 06.09.2023.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var detailsPresented: Bool = false
    var detailsVM: DetailsViewModel?
    
    func showDetails() {
        detailsVM = .init()
        detailsPresented.toggle()
    }
}

struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    var body: some View {
        Color.blue
            .onTapGesture {
                vm.showDetails()
            }
            .sheet(isPresented: $vm.detailsPresented) {
                DetailsView()
                    .environmentObject(vm.detailsVM!)
                    .edgesIgnoringSafeArea(.bottom)
                    .onDisappear {
                        vm.detailsVM = nil
                    }
                    .presentationDetents([.medium, .large]) // DetailsViewModel won't deinit
//                    .presentationDetents([.medium]) // DetailsViewModel will deinit as expected
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class DetailsViewModel: ObservableObject {
    init() {
        print("DetailsVM init")
    }
    deinit {
        print("DetailsVM deinit")
    }
}

struct DetailsView: View {
    @EnvironmentObject var vm: DetailsViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Color.yellow
            .onTapGesture {
                dismiss()
            }
    }
}
