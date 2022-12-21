//
//  ContentView.swift
//  SearchTattoo
//
//  Created by Hertz on 12/18/22.
//

import SwiftUI

struct OnBoardingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var isStartButtonTapped: Bool = false
    
    
    var body: some View {
        ZStack {
            Image("img_bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack(alignment: .leading) {
                headerTextView
                
                Text("내지역\n타투전문가")
                    .foregroundColor(.white)
//                    .foregroundColor(colorScheme != .dark ? .white : .black)
                    .font(.custom("NanumGothicExtraBold", size: 30))
                    .padding(.horizontal, 16)
                
                Button {
                    // 버튼 클릭시 액션
                    self.isStartButtonTapped = true
                } label: {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(ColorManager.customPink)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .overlay(
                            Text("시작하기")
                                .foregroundColor(.white)
//                                .foregroundColor(colorScheme != .dark ? .white : .black)
                                .font(.custom("NanumGothicBold", size: 16))
                        )
                        .padding(.horizontal, 16)
                        .padding(.bottom, 48)
                        
                }
                .fullScreenCover(isPresented: $isStartButtonTapped) {
                    HomeView()
                }
                
                
                
            }
        }
    }
}

extension OnBoardingView {
    
    var headerTextView: some View {
        Text("서치타투")
            .foregroundColor(colorScheme != .dark ? Color.white : Color.black )
            .font(.custom("NanumGothicBold", size: 20))
            .frame(maxWidth: .infinity, alignment: .leading)
            .vAlign(.top)
            .padding(.top, 70.5)
            .padding(.horizontal, 16)

    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}

