//
//  FeedView.swift
//  PictureMyWalk
//
//  Created by Rosa Meijers on 30/06/2023.
//

import SwiftUI

struct FeedView: View {
    @EnvironmentObject private var vm: FeedViewModel
    
    @State private var isWalkStarted = false
    @State private var showAlert = false
    @State private var timer: Timer?
    
    var body: some View {
        VStack(spacing: 0) {
            photoHeader
            
            Divider()
            
            if(vm.flickrFeed.isEmpty){
                startView
            } else {
                allPhotosList
                    .transition(.move(edge: .leading))
            }
        }
        .alert("Time out. Your walk has been stopped", isPresented: $showAlert) {
            Button("Got it") {}
        }
    }
}

extension FeedView {
    private var allPhotosList: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            LazyVStack(spacing: 8) {
                ForEach(Array(vm.flickrFeed.reversed().enumerated()), id: \.element.id) { index, photo in
                    FeedRowView(photo: photo)
                        .listRowSeparator(.hidden)
                }
            }
            .padding(.vertical, 8)
        })
    }
    
    private var startView: some View {
        ZStack {
            Color.white
            
            Text(isWalkStarted ? "Keep walking..." : "Press start")
                .font(.headline)
                .foregroundColor(.black)
        }
    }
    
    private var photoHeader: some View {
        HStack {
            Button(action: {
                vm.resetPhotos()
            }, label: {
                Image(systemName: "clear")
                    .font(.headline)
            })
            
            Rectangle()
                .frame(width: 15, height: 0)
            
            Spacer()
            
            if isWalkStarted {
                Text("\((String(Int(vm.walkedDistance)))) meters")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Button(action: {
                isWalkStarted.toggle()
                
                if isWalkStarted {
                    initTimer()
                    vm.walkIsStarted()
                } else {
                    deinitTimer()
                    vm.walkIsEnded()
                }
                
            }, label: {
                Text(isWalkStarted ? "Stop" : "Start")
                    .foregroundColor(isWalkStarted ? .red : .black)
            })
        }
        .padding()
    }
    
    private func deinitTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func initTimer() {
        // Timer will go off after 2 hours (7200 seconds) with an alert that the walk has been stopped
        timer = Timer.scheduledTimer(withTimeInterval: 7200, repeats: false) {
            _ in
            timeOutWalk()
        }
    }
    
    private func timeOutWalk() {
        isWalkStarted = false
        showAlert = true
        vm.walkIsEnded()
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.feedVM)
    }
}
