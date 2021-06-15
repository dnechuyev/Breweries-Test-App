//
//  ContentView.swift
//  Breweries Test App
//
//  Created by Dmytro Nechuyev on 07.06.2021.
//

import SwiftUI
import SafariServices
import MapKit

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    @State var textfield = ""
    @State var page = 2
    @State var showSafari = false
    
    init() {
        UINavigationBar.appearance().barTintColor = UIColor(named: "CustomGreen")
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    var body: some View {
        NavigationView {
            
            ZStack(alignment: .bottomTrailing) {
                VStack(spacing: 20) {
                    
                    HStack(alignment: .top) {
                        TextField(
                            "\(Image(systemName: "magnifyingglass")) Search",
                            text: $textfield,
                            onCommit: {
                                viewModel.search = true
                                viewModel.searchBrewery(query: self.textfield)
                            }
                        )
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    }.frame(maxHeight: 50)
                    .background(Color("CustomGreen"))
                    
                    if viewModel.search != true {
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.breveriesRes , id: \.self) { brewery in
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 10){
                                            
                                            Text(brewery.name ?? "none" )
                                                .font(.title)
                                            if brewery.country != nil && brewery.country != "" {
                                                HStack{
                                                    Text("Country:")
                                                        .foregroundColor(.secondary)
                                                    Text("\(brewery.country ?? "")")
                                                }
                                            }
                                            if brewery.state != nil && brewery.state != "" {
                                                HStack{
                                                    Text("State:")
                                                        .foregroundColor(.secondary)
                                                    Text("\(brewery.state ?? "")")
                                                }
                                            }
                                            if brewery.city != nil && brewery.city != "" {
                                                HStack{
                                                    Text("City:")
                                                        .foregroundColor(.secondary)
                                                    Text("\(brewery.city ?? "")")
                                                }
                                            }
                                            if brewery.street != nil && brewery.street != "" {
                                                HStack{
                                                    Text("Street:")
                                                        .foregroundColor(.secondary)
                                                    Text("\(brewery.street ?? "")")
                                                }
                                            }
                                            if brewery.phone != nil && brewery.phone != "" {
                                                HStack{
                                                    Text("Phone:")
                                                        .foregroundColor(.secondary)
                                                    Text("\(brewery.phone ?? "")")
                                                }
                                            }
                                            if brewery.website_url != nil && brewery.website_url != "" {
                                                HStack{
                                                    Text("Website:")
                                                        .foregroundColor(.secondary)
                                                    Button(action: {
                                                        self.showSafari = true
                                                    }) {
                                                        Text("\(brewery.website_url ?? "")")
                                                            .foregroundColor(.black)
                                                            .underline()
                                                    }
                                                    .sheet(isPresented: $showSafari) {
                                                        SafariView(url:URL(string: brewery.website_url ?? "https://www.google.ru/?client=safari&channel=mac_bm")!)
                                                    }
                                                }
                                            }
                                            
                                            if (brewery.latitude != nil && brewery.latitude != "" && brewery.longitude != nil && brewery.longitude != "") {
                                                
                                                let coordinates = CLLocationCoordinate2D(latitude: Double(brewery.latitude ?? "0.0") ?? 0, longitude: Double(brewery.longitude ?? "0.0") ?? 0)
                                                MapButton(coordinates: coordinates)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .frame(width: 340)
                                    .padding(20)
                                    .overlay(RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.green, lineWidth: 2)
                                    )
                                    .background(Color("CardBackground"))
                                    .padding(10)
                                    .onAppear{
                                        if viewModel.breveriesRes.firstIndex(of: brewery) == viewModel.breveriesRes.count - 2 && viewModel.endOfData != true {
                                            viewModel.appStart(page: page)
                                            page += 1
                                        }
                                    }
                                }
                            }
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack {
                                ForEach(viewModel.searchRes , id: \.self) { brewery in
                                    
                                    HStack {
                                        VStack(alignment: .leading, spacing: 10){
                                            
                                            Text(brewery.name ?? "none" )
                                                .font(.title)
                                            if brewery.country != nil && brewery.country != "" {
                                                HStack{
                                                    Text("Country:")
                                                        .foregroundColor(.secondary)
                                                    Text("\(brewery.country ?? "")")
                                                }
                                            }
                                            if brewery.state != nil && brewery.state != "" {
                                                HStack{
                                                    Text("State:")
                                                        .foregroundColor(.secondary)
                                                    Text("\(brewery.state ?? "")")
                                                }
                                            }
                                            if brewery.city != nil && brewery.city != "" {
                                                HStack{
                                                    Text("City:")
                                                        .foregroundColor(.secondary)
                                                    Text("\(brewery.city ?? "")")
                                                }
                                            }
                                            if brewery.street != nil && brewery.street != "" {
                                                HStack{
                                                    Text("Street:")
                                                        .foregroundColor(.secondary)
                                                    Text("\(brewery.street ?? "")")
                                                }
                                            }
                                            if brewery.phone != nil && brewery.phone != "" {
                                                HStack{
                                                    Text("Phone:")
                                                        .foregroundColor(.secondary)
                                                    Text("\(brewery.phone ?? "")")
                                                }
                                            }
                                            if brewery.website_url != nil && brewery.website_url != "" {
                                                HStack{
                                                    Text("Website:")
                                                        .foregroundColor(.secondary)
                                                    Button(action: {
                                                        self.showSafari = true
                                                    }) {
                                                        Text("\(brewery.website_url ?? "")")
                                                            .foregroundColor(.black)
                                                            .underline()
                                                    }
                                                    .sheet(isPresented: $showSafari) {
                                                        SafariView(url:URL(string: brewery.website_url ?? "https://www.google.ru/?client=safari&channel=mac_bm")!)
                                                    }
                                                }
                                            }
                                            if (brewery.latitude != nil && brewery.latitude != "" && brewery.longitude != nil && brewery.longitude != "") {
                                                
                                                let coordinates = CLLocationCoordinate2D(latitude: Double(brewery.latitude ?? "0.0") ?? 0, longitude: Double(brewery.longitude ?? "0.0") ?? 0)
                                                MapButton(coordinates: coordinates)
                                            }
                                        }
                                        Spacer()
                                    }
                                    .frame(width: 340)
                                    .padding(20)
                                    .overlay(RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.green, lineWidth: 2)
                                    )
                                    .background(Color("CardBackground"))
                                    .padding(10)
                                }
                            }
                            Spacer()
                        }
                        
                    }
                }
                Image("Leprikon")
                    .resizable()
                    .frame(width: 224, height: 342)
                    .padding(.bottom, -47)
                    .padding(.trailing, -24)
            }
            .navigationBarTitle("Breweries", displayMode: .inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
    
}

struct MapButton: View {
    var coordinates: CLLocationCoordinate2D
    
    var body: some View {
        NavigationLink(destination: MapView(coordinate: coordinates)){
            Text("Show on map")
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
        }
    }
}


