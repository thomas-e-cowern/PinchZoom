//
//  ContentView.swift
//  PinchZoom
//
//  Created by Thomas Cowern on 2/28/23.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    // MARK: - Reset Function
    func restImageState () {
        withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    func currentPage () -> String {
        return pages[pageIndex - 1].imageName
    }
    
    // MARK: - Body
    var body: some View {
        
        NavigationStack {
            ZStack {
                
                Color.clear
                
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .padding()
                    .shadow(color: .black.opacity(0.7), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .offset(x: imageOffset.width, y: imageOffset.height)
                    .animation(.linear(duration: 1), value: isAnimating)
                    .scaleEffect(imageScale)
                // MARK: Tap Gesture
                    .onTapGesture(count: 2, perform: {
                        if imageScale == 1 {
                            withAnimation(.spring()) {
                                imageScale = 5
                            }
                        } else {
                           restImageState()
                        }
                    })
                // MARK: Drag Gesture
                    .gesture(
                        DragGesture()
                        .onChanged({ value in
                            withAnimation(.linear(duration: 0.5)) {
                                imageOffset = value.translation
                            }
                        })
                        .onEnded({ _ in
                            if imageScale <= 1 {
                                restImageState()
                            }
                        })
                    )
                // MARK: Magnification
                    .gesture(MagnificationGesture().onChanged({ value in
                        withAnimation(.linear(duration: 1)) {
                            if imageScale >= 1 && imageScale <= 5 {
                                imageScale = value
                            } else if imageScale > 5 {
                                imageScale = 5
                            }
                        }
                    })
                        .onEnded({ _ in
                            if imageScale > 5 {
                                imageScale = 5
                            } else if imageScale <= 1 {
                                restImageState()
                            }
                        }))
            } //: End of ZStack
            .navigationTitle("Pinch and Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isAnimating = true
            }
            
            // MARK: Info Panel
            .overlay(InfoPanelView(scale: imageScale, offset: imageOffset).padding(.horizontal).padding(.top, 30), alignment: .top)
            
            // MARK: Controls
            .overlay(
                Group {
                    HStack {
                        // Scale down
                        ControlImageButton(symbolName: "minus.magnifyingglass") {
                            withAnimation(.spring()) {
                                if imageScale > 1 {
                                    imageScale -= 1
                                    
                                    if imageScale <= 1 {
                                        restImageState()
                                    }
                                }
                            }
                        }
                        
                        // Reset
                        ControlImageButton(symbolName: "arrow.up.left.and.down.right.magnifyingglass") {
                            withAnimation(.spring()) {
                                restImageState()
                            }
                        }
                        
                        // Scale up
                        ControlImageButton(symbolName: "plus.magnifyingglass") {
                            withAnimation(.spring()) {
                                if imageScale < 5 {
                                    imageScale += 1
                                    
                                    if imageScale > 5 {
                                        imageScale = 5
                                    }
                                }
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 10, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .opacity(isAnimating ? 1 : 0)
                } // MARK: End of group
                    .padding(.bottom, 30)
                    , alignment: .bottom
                // MARK: Drawer
                    
            )
            // MARK: Drawer
            .overlay(HStack(spacing: 12) {
                Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
                    .padding(8)
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        withAnimation(.easeOut) {
                            isDrawerOpen.toggle()
                        }
                    }
                
                // MARK: Thumbnails
                ForEach(pages) { page in
                    Image(page.thumbnailName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                        .opacity(isDrawerOpen ? 1 : 0)
                        .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                        .onTapGesture {
                            isAnimating = true
                            pageIndex = page.id
                        }
                }
                
                Spacer()
            } // MARK: Drawer
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, UIScreen.main.bounds.height / 12)
                .offset(x: isDrawerOpen ? 20 : 215)
                , alignment: .topTrailing
            )
        }  // MARK: End of Navigation Stack
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
