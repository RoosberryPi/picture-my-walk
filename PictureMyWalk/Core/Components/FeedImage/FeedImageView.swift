//
//  FeedImageView.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 04/07/2023.
//

import SwiftUI

struct FeedImageView: View {
    @StateObject var vm: FeedImageViewModel
    
    init(photo: Photo) {
        _vm = StateObject(wrappedValue: FeedImageViewModel(photo: photo))
    }
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width - 16, height: 250)
                    .clipped()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundColor(.gray)
            }
        }
    }
}

struct FeedImageView_Previews: PreviewProvider {
    static var previews: some View {
        FeedImageView(photo: dev.photo)
    }
}
