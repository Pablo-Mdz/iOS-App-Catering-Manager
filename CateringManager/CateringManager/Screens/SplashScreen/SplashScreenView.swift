//
//  SplashScreenView.swift
//  CateringManager
//
//  Created by Pablo Cigoy on 06/08/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State var isActive: Bool = false
    @State private var size: CGFloat = 0.5
    @State private var opacity: Double = 0.3

    var body: some View {
            VStack {
                VStack {
                    Image("logo2")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(15)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.1
                        self.opacity = 1.0
                    }
                    withAnimation(.interpolatingSpring(stiffness: 5, damping: 1).delay(0.9)) {
                        self.size = 1.0
                    }
                }
            }
            .background(Color.white)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
