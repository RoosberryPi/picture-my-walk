//
//  FeedRowView.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 03/07/2023.
//

import SwiftUI

struct FeedRowView: View {
    let photo: Photo
    
    var body: some View {
        ZStack {
            column
        }
    }
}

extension FeedRowView {
    private var column: some View {
        FeedImageView(photo: photo)
    }
}

struct FeedRowView_Previews: PreviewProvider {
    static var previews: some View {
        FeedRowView(photo: dev.photo)
    }
}
