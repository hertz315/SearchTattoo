//
//  HomeView.swift
//  SearchTattoo
//
//  Created by Hertz on 12/19/22.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct HomeView: View {
    
    @StateObject var viewModel = ViewModel()
    
    //서울 좌표
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                // 맵
                Map(coordinateRegion: $viewModel.region,
                    showsUserLocation: true,
                    userTrackingMode: $viewModel.trackingMode,
                    annotationItems: viewModel.tattooShops) { aTattooShop in
                    
                    MapAnnotation(coordinate: aTattooShop.coordinate) {
                        
                        NavigationLink {
                            DetailTattooistView(viewModel: viewModel, tattooShop: aTattooShop)
                        } label: {
                            Image(aTattooShop.profileImageString)
                                        .resizable()
                                        .frame(width: 44, height: 44)
                                        .background(.white)
                                        .clipShape(Circle())
                                        .padding(3)
                                        .background(Color.black)
                                        .clipShape(Circle())
                                        .shadow(radius: 10)
                        }
                            
                    }
                    
                }
                
                bottomSection
            }
            
            .navigationTitle("내지역 타투전문가")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.updateCurrentLocation()
        }
        
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

extension HomeView {
    // MARK: - 바텀 섹션
    var bottomSection: some View {
        VStack(spacing: 10) {
            HStack {
                Text("근처에 있어요👍🏻")
                    .font(.custom("NanumGothicExtraBold", size: 18))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    viewModel.updateCurrentLocation()
                } label: {
                    Image(systemName: "location.fill.viewfinder")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .padding()
                }
                .background(ColorManager.customPink)
                .foregroundColor(.white)
                .clipShape(Circle())
                
                
                
            }
            .padding(.horizontal, 17)
            
            ScrollView(.horizontal) {
                LazyHStack(alignment: .center, spacing: 16) {
                    ForEach(viewModel.tattooShops, id: \.id) { aTattooShop in
                        NavigationLink {
                            DetailTattooistView(viewModel: viewModel, tattooShop: aTattooShop)
                        } label: {
                            TattooistCardView(viewModel: viewModel, tattooShop: aTattooShop)
                                .padding(.leading, viewModel.isFirstItem(aTattooShop) ? 17 : 0)
                                .padding(.trailing, viewModel.isLastItem(aTattooShop) ? 17 : 0)
                        }
                        
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 161)
            .padding(.bottom, 42)
            
        }
        
    }
}
