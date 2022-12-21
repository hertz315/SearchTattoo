//
//  ContactView.swift
//  SearchTattoo
//
//  Created by Hertz on 12/22/22.
//

import SwiftUI
import Combine
import HalfASheet

struct ContactView: View {
    @StateObject var viewModel: ViewModel
    let tattooShop: TattooShop
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Button {
                viewModel.isInstaSafariView = true
            } label: {
                ContactButton(buttonImage: "인스타", textString: "인스타그램")
            }
            .sheet(isPresented: $viewModel.isInstaSafariView) {
                let instaUrl = tattooShop.instaURL
                let url = URL(string: instaUrl)
                SafariView(url: url)
            }
            
            
            Button {
                viewModel.isShowKakaSafariView = true
            } label: {
                ContactButton(buttonImage: "카카오", textString: "카카오톡")
            }
            .sheet(isPresented: $viewModel.isShowKakaSafariView) {
                let kakaoUrl = tattooShop.kakaoURL
                let url = URL(string: kakaoUrl)
                SafariView(url: url)
            }
            
            
            Button {
                let telephone = "tel://"
                let numberString = tattooShop.phoneNumber
                let formattedString = "\(telephone)\(numberString)"
                guard let url = URL(string: formattedString) else { return }
                UIApplication.shared.open(url)
            } label: {
                ContactButton(buttonImage: "전화", textString: "전화하기")
            }
            
            Button {
                let latitude = tattooShop.latitude
                let longitude = tattooShop.longitude
                guard let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)") else { return }
                if UIApplication.shared.canOpenURL(url) {
                      UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } label: {
                ContactButton(buttonImage: "지도", textString: "길찾기")
            }
        }
        .padding()
        
        
    }
}

//struct ContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactView(viewModel: ViewModel(), tattooShop: TattooShop)
//    }
//}
