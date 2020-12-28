//
//  DataSetting.swift
//  GameOneViewTwo
//
//  Created by Ivan Dimitrov on 19.10.20.
//

import SwiftUI

struct DataSetting: View {
    
    
    @ObservedObject var subscriptionManager: SubscriptionManager = .shared
    var isActive : Bool { subscriptionManager.paymentCompleted }
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: GameLock.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \GameLock.idG, ascending: true)]) var gameLock: FetchedResults<GameLock>
    
    @Environment(\.presentationMode) private var pMode
    @State var colorShadow : Color = Color(red: 163 / 255, green: 177 / 255, blue: 198 / 255)
    @State var isExit      : Bool = false
    @ObservedObject var  chose              = SetBranchNew()
    @State          var showingAlert : Bool = false
    @State          var showingSheet : Bool = false
    
    var width : CGFloat { let a = UIScreen.main.bounds.width
        if a < 700 { return a }else{ return 700 }}
    
    var height : CGFloat {
        let b = UIScreen.main.bounds.width
        if b < 700 { return UIScreen.main.bounds.height }else{ return 1000 }}
    
    var body: some View {
        
        ZStack {
            
            Color.init(hex: "F0F0F3")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack {
                    Button(action: {
                        self.isExit.toggle()
                        self.pMode.wrappedValue.dismiss()
//                        UserDefaults.standard.set(number, forKey: "Arda")
                    }) {
                        Text("⏎")
                            .padding()
                            .frame(width: width / 5 , height: width / 5, alignment: .center)

                    }
                    .modifier(PrimaryButton())
                    .foregroundColor(self.isExit ? .gray : .primary)
                    .offset(y: self.width < 700 ? 10 : 10)
                    
                    Spacer()
                }
                .offset(x:self.width < 700 ? 15 : 15 , y: self.width < 700 ? 10 : 10)

//                Text(isActive ? "true" : "false")
                Spacer()
                VStack{
                    ScrollView(.vertical, showsIndicators: false){
                        /*
                         ForEach(Array(zip(chose.choseBranchNew , chose.choseBranchNew.indices)), id:\.0) { ( br , index ) in
                         */
                        
                        ForEach(Array(zip(gameLock , gameLock.indices)), id:\.0) { (br , index ) in
                            Group {
                                HStack {
                                    Spacer()
                                    VStack{
                                        Button(action: {
                                            self.showingAlert = checkButon(index: index)
                                     
                                            
                                        }) {
                                            ZStack{
                                                HStack {
                                                    Spacer()
                                                    Text(br.textG!)
                                                }
                                                Image(br.imageG!)
                                                    .resizable()
                                                    .frame(width: 30,height: 30)
                                                    .offset(x: -40)
                                           }
                                                .frame(width: 140  , height: 50 , alignment: .center)
                                                .modifier(PrimaryButton())
                                        }
                                    } .frame(width: 140  , height: 50 , alignment: .center)

                                    Spacer()

                                    Text( br.isOnOffG ? "🟢" : "◉")
                                            .frame(width: 50 , height: 50 , alignment: .center)
                                            .modifier(PrimaryButton())

                                    Spacer()
                                    
                                    Button(action: {
                                        
                                    }) {
                                        
                                        Text(( br.isLockG || isActive ) ? "🔓" : "🔐")
                                            .frame(width: 50 , height: 50 , alignment: .center)
                                            .modifier(PrimaryButton())
                                    }

                                       


                                    Spacer()

         
                                    
                                }.frame( height: 70  )
                            }
                        }
                  
                    }
                }
                .frame(width: width / 1.1 , height: height / 1.4 , alignment: .center)
                .modifier(PrimaryButton())
            }
        }
        .onAppear(){
            subscriptionManager.checkSubscribtionStatus()
        }
        .alert(isPresented: $showingAlert, content: {

            Alert(title: Text("Title"), message: Text("Message"), primaryButton: Alert.Button.default(Text("ok"), action: { self.showingSheet = true  }), secondaryButton: Alert.Button.cancel() )
                
                
            
        })
        .sheet(isPresented: $showingSheet, content: { ShowPurchases() })
    }
    
    
    func checkButon(index: Int) -> Bool{
        var alo : Bool = false
      
        if gameLock[index].isLockG || isActive {
            
            for num in 0..<gameLock.count {

                if num == index {
                    gameLock[num].isOnOffG = true
                    gameLock[num].timeDateG = Date()

                    UserDefaults.standard.set(num, forKey: "Arda")
                    UserDefaults.standard.set(false, forKey: "TreeDead")
                    UserDefaults.standard.set(false, forKey: "Polivane")
                    UserDefaults.standard.set(false, forKey: "ViewEnemy")
                    UserDefaults.standard.set(true, forKey: "ShowEnemy")
                }else{
                    gameLock[num].isOnOffG = false
                }
                                    do {
                                        try  self.moc.save()
                                        print(".... ok ....")
                                    }catch{
                                        print(".... no ....")
                                    }
            }
        }else {
            alo = true
        }

        return alo
    }
    
    
}

struct DataSetting_Previews: PreviewProvider {
    static var previews: some View {
        DataSetting()
    }
}


