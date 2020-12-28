//
//  BackView.swift
//  GameOneViewTwo
//
//  Created by Ivan Dimitrov on 27.12.20.
//

import SwiftUI

struct BackView: View {
    
    var width : CGFloat {
        let a = UIScreen.main.bounds.width
        if a < 700 {
            return a
        }else{
            return 700
        }
    }
    
    var height : CGFloat {
        let b = UIScreen.main.bounds.width
        if b < 700 {
            return UIScreen.main.bounds.height
        }else{
            return 1000
        }
    }
    var body: some View {
        ZStack {
           Image("Treva")
            .resizable()
          
            Image("tree\( UserDefaults.standard.integer(forKey: "Arda"))")

        }
        .frame(width: width / 1.1, height: width / 1.1 , alignment: .center)
        .modifier(PrimaryButton())  .modifier(PrimaryButton())
    }
}

struct BackView_Previews: PreviewProvider {
    static var previews: some View {
        BackView()
    }
}
