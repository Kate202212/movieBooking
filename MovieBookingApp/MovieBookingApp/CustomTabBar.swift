//
//  CustomTabBar.swift
//  MovieBookingApp
//
//  Created by Prakai Prajit on 5/5/2024.
//
import SwiftUI

struct CustomTabBar: View {
    @Binding var currentTab: Tab
    
    var backgroundColors = [Color("Colorpurp"), Color("lightBlue"), Color("Colorpnk")]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        currentTab = .location
                    }
                }) {
                    Image("location")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(currentTab == .location ? .white : .gray)
                        .padding(.leading, 20)
                }

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut) {
                        currentTab = .home
                    }
                }) {
                    Image("home")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(currentTab == .home ? .white : .gray)
                }

                Spacer()

                Button(action: {
                    withAnimation(.easeInOut) {
                        currentTab = .ticket
                    }
                }) {
                    Image("ticket")
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(currentTab == .ticket ? .white : .gray)
                        .padding(.trailing, 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(LinearGradient(colors: backgroundColors, startPoint: .leading, endPoint: .trailing))
        .frame(height: 50)
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    MovieListView()
}
