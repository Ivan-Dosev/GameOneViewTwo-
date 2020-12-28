//
//  OblackView.swift
//  GameOneViewTwo
//
//  Created by Ivan Dimitrov on 27.12.20.
//

import SwiftUI

struct Png1: UIViewRepresentable {
    
  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Png1>) {
  }

    var png1 = ArtboardBk3View()
    

  func makeUIView(context: Context) -> UIView {
    
    return png1
  }
}
struct Oblack: View {
    
    var png1 = Png1()
    
    var body: some View {
        png1
            .frame(minWidth: ArtboardBk3View.Defaults.size.width, idealWidth: ArtboardBk3View.Defaults.size.width, maxWidth: ArtboardBk3View.Defaults.size.width, minHeight: ArtboardBk3View.Defaults.size.height, idealHeight: ArtboardBk3View.Defaults.size.height, maxHeight: ArtboardBk3View.Defaults.size.height, alignment: .center)
            .onAppear(){
                let timelinePNG19 : Timeline = Timeline_1(view: png1.png1, duration: 5, repeatCount: 1)
                    timelinePNG19.play()

            }
    }
}
