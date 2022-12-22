//
//  ContactButton.swift
//  SearchTattoo
//
//  Created by Hertz on 12/22/22.
//

import SwiftUI

struct ContactButton: View {
    let buttonImage: String
    let textString: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 70)
            .overlay (
                HStack(alignment: .center) {
                    Image(buttonImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 45, height: 45)
                    Spacer()
                    Text(textString)
                        .font(.largeTitle).bold()
                        .foregroundColor(.black)
                }
                    .padding()
            )
    }
}

//struct ContactButton_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactButton()
//    }
//}
