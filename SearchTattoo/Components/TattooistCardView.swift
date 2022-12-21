//
//  TattooistCardView.swift
//  SearchTattoo
//
//  Created by Hertz on 12/20/22.
//

import SwiftUI
import Combine

struct TattooistCardView: View {
    
    @StateObject var viewModel: ViewModel
    let tattooShop: TattooShop
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(tattooShop.profileImageString)
                .resizable()
                .scaledToFit()
                .frame(width: 145, height: 114)
            Rectangle()
                .overlay {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(tattooShop.shopName)
                            .font(.custom("NanumGothicExtraBold", size: 14))
                            .foregroundColor(.black)
                            .hAlign(.leading)
                        HStack(spacing: 3) {
                            Image("imozy")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                            Text(tattooShop.address)
                                .font(.custom("Roboto-Regular", size: 10.0))
                                .foregroundColor(.black)
                        }
                    
                    }
                    .padding(.leading, 4)
                    
                }
                .foregroundColor(.white)
                .frame(width: 145, height: 47)
            
            
        }
        .frame(width: 145, height: 161)
        .cornerRadius(8)
        
    }
}

//struct TattooistCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        TattooistCardView()
//    }
//}
