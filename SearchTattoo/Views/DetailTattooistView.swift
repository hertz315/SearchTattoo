//
//  DetailTattooistView.swift
//  SearchTattoo
//
//  Created by Hertz on 12/20/22.
//

import SwiftUI
import HalfASheet

struct DetailTattooistView: View {
    
    @StateObject var viewModel: ViewModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let tattooShop: TattooShop

    
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ZStack {
                VStack(spacing: 0) {
                    Text(tattooShop.shopName)
                        .font(.custom("Roboto-Black", size: 28))
                        .hAlign(.leading)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 28)
                        .padding(.top, 28.5)
                    
                    Image(tattooShop.profileImageString)
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .frame(height: 315)
                        .padding(.horizontal, 25)
                        .padding(.bottom, 24)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .foregroundColor(.gray)
                        .overlay (
                            VStack(alignment: .leading, spacing: 8) {
                                Text("연락처")
                                    .font(.custom("NanumGothicExtraBold", size: 16))
                                Text(tattooShop.phoneNumber)
                                    .font(.custom("NanumGothicRegular", size: 14))
                            }
                                .hAlign(.leading)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        )
                        .padding(.horizontal, 27.5)
                        .padding(.bottom, 10)
                    
                    RoundedRectangle(cornerRadius: 15)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .foregroundColor(.gray)
                        .overlay (
                            VStack(alignment: .leading, spacing: 8) {
                                Text("주소")
                                    .font(.custom("NanumGothicExtraBold", size: 16))
                                Text(tattooShop.address)
                                    .font(.custom("NanumGothicRegular", size: 14))
                            }
                                .hAlign(.leading)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                        )
                        .padding(.horizontal, 27.5)
                        .padding(.bottom, 29)
                    
                    Button {
                        print("상담 신청하기 버튼 탭...")
                        viewModel.isShowContactView = true
                    } label: {
                        Capsule()
                            .foregroundColor(ColorManager.customPink)
                            .frame(maxWidth: .infinity)
                            .frame(height: 55)
                            .overlay (
                                HStack(spacing: 15) {
                                    Image(systemName: "book")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 20, height: 20)
                                    Text("상담 신청하기")
                                        .font(.custom("NanumGothicExtraBold", size: 18))
                                        .foregroundColor(.white)
                                }
                            )
                            .padding(.bottom, 65)
                            .padding(.horizontal, 77)
                    }
                }

                HalfASheet(isPresented: $viewModel.isShowContactView, title: "연락하기") {
                    ContactView(viewModel: viewModel, tattooShop: tattooShop)
                }
                .height(.proportional(0.7))
            }
            
            .navigationTitle("전문가정보")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: btnBack)
        }
    }
    
}


extension DetailTattooistView {
   
    // MARK: - 커스텀 BackButton
    var btnBack: some View {
        Button {
            self.presentationMode.wrappedValue.dismiss()
        } label: {
            Image(systemName: "chevron.backward")
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
        }
        
    }
    
    
    
}

//struct DetailTattooistView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailTattooistView()
//    }
//}
