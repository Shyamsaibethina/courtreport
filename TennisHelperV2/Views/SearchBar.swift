//
//  SearchBar.swift
//  TennisHelperV2
//
//  Created by Shyamsai Bethina on 5/8/22.
//

import SwiftUI

struct SearchBar: View {
    @State var search = ""
    @State var inputtedAddress = false
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .fill(.gray)
                .frame(width: 370, height: 40)
                .opacity(0.3)
                .shadow(color: .gray, radius: 10)
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search Address", text: $search, onCommit: {
                    if !search.isEmpty{
                            inputtedAddress = true
                    }
                    else{
                        inputtedAddress = false
                    }
                })
            }
            .padding()
        }
        
        
//        .overlay(RoundedRectangle(cornerRadius: 15, style: .continuous)
//            .fill(.gray)
//            .frame(width: 370, height: 40)
//            .opacity(0.3))
        
            
            
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
