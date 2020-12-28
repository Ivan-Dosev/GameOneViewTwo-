//
//  FirstNewView.swift
//  GameOneViewTwo
//
//  Created by Ivan Dimitrov on 1.10.20.
//

import SwiftUI
//import GoogleMobileAds

struct FirstNewView: View {
    

    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: GameLock.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \GameLock.idG, ascending: true)]) var gameLock: FetchedResults<GameLock>
    @ObservedObject var  chose = SetBranchNew()
    
   @State var wid = UIScreen.main.bounds.width
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
    
//    @State var rewardAd:Rewarded = Rewarded()
//   init(){ self.rewardAd = Rewarded() }
    
    @State var isPressed : Bool = false
    
    @State var isTimer     : Bool = false
    @State var isCoreData  : Bool = false
    @State var isSetting   : Bool = false
    
    @State var isPolivane  : Bool = false
    @State var isTorene    : Bool = false
    @State var isTretirane : Bool = true
    @EnvironmentObject var timeOnOff : TimeOnOff
    var toto : Float  {
        if gameLock.count != 0 {
            return gameLock[loadIndexFromCoreData()].totallG ?? 0
        }else{
            return 0.0
        }
         
    }

    var body: some View {
        ZStack {
            Color.init(hex: "F0F0F3")
           
            VStack {
//                Color.black.opacity(0.2)
//                    .edgesIgnoringSafeArea(.all)
                HStack {
                    
                    Spacer()
                    if self.isPolivane {
                        Text("Polivane")
                            .frame(width: width / 4  , height: width / 6)
                            .modifier(PrimaryButton())
//                            .onTapGesture {
//                                self.isTretirane = false
////                                UserDefaults.standard.bool(forKey: "ShowEnemy")
//                                  UserDefaults.standard.set(true, forKey: "ShowEnemy")
//                            }
                            .offset(y: self.width < 700 ? 40 : 40)
                    }else {
                        Button(action: {
                            UserDefaults.standard.set(false, forKey: "ViewEnemy")
                            self.isPolivane = true
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                                            self.isPolivane = false
                                                        }
                        }) {
                            Text("Polivane")
                                .frame(width: width / 4  , height: width / 6)
                                .scaleEffect(UserDefaults.standard.bool(forKey: "Polivane") ? 1.5 : 1)
                                .modifier(PrimaryButton())
                                .offset(y: self.width < 700 ? 40 : 40)
                        }
                    }
                    
                 Spacer()
                    VStack(spacing: 20){
                        Text("TOTALL")
                        Text("\((self.toto), specifier: "%.2f")")
                            
                    }
                    .frame(width: width / 4  , height: width / 4)
                    .modifier(PrimaryButton())
                    .offset(y: self.width < 700 ? 50 : 50)
                    
                    Spacer()
                    ButtonView(width: width / 4  , height: width / 6  ,isPressed: self.$isTretirane, name: "Tretirane")
                   .offset(y: self.width < 700 ? 40 : 40)
                        .onTapGesture {
                            self.isTretirane = true
                        }
                    Spacer()
                }
                .frame(width: width, height: 100, alignment: .center)
//                .offset(y: -20)

                Spacer()
           
//                    FlowContentView()
//                        .frame(height: 340)
                
                
            
                

                    
                Spacer()
                
                HStack {
                    
                    Spacer()
                    ButtonView(width: width / 4  , height: width / 6  ,isPressed: self.$isTimer, name: "Timer")
                        .offset(y: self.width < 700 ? -15 : -15)
                        .sheet(isPresented: self.$isTimer, content: { ContView().environment(\.managedObjectContext , moc) })

                    Spacer()
                    ButtonView(width: width / 4  , height: width / 6  ,isPressed: self.$isSetting, name: "Setting")
                        .offset(x: 10 ,y: self.width < 700 ? -15 : -15)
                        .sheet(isPresented: self.$isSetting, content: { DataSetting().environment(\.managedObjectContext , moc) })
                    Spacer()
                    ButtonView(width: width / 4  , height: width / 6 ,isPressed: self.$isCoreData, name: "CoreData")
                        .offset(y: self.width < 700 ? -15 : -15)
                        .sheet(isPresented: self.$isCoreData, content: { CDView().environment(\.managedObjectContext , moc) })
                    Spacer()


                }
                .frame(width: width, height: 130, alignment: .center)

                
            } .frame(width: self.width  , height: self.height )
            
            
            ZStack {


                if UserDefaults.standard.bool(forKey: "TreeDead") {
                          DeadNewViewTree()
                }else{
                    if UserDefaults.standard.bool(forKey: "ShowEnemy") {
                           loadNewView()
                    }else{
                           BackView()
                    }
                }
            }
            
            
        }
        .onAppear(){
          
            if gameLock.count == 0 {
                UserDefaults.standard.set(false, forKey: "TreeDead")
                UserDefaults.standard.set(true, forKey: "ShowEnemy")
                UserDefaults.standard.set(false, forKey: "Polivane")
                UserDefaults.standard.set(true, forKey: "ViewEnemy")
                print("\(gameLock.count)...ok")
                loadData()

              }
            }
       
    }
    
    func loadIndexFromCoreData() -> Int {
        var index : Int = 0
        
        for num in 0..<gameLock.count {
            if gameLock[num].isOnOffG {
                index = num
            }
        }
        return index
    }
    
    func loadNewView() -> AnyView {
        
        var index = 0
        
        
        for num in 0..<gameLock.count {
            if gameLock[num].isOnOffG {
                index = num
            }
        }
        
        switch index {
        case 0:
            return    AnyView(ArdaView(isPolivane: $isPolivane))
        case 1:
            return    AnyView(ArdaView100(isPolivane: $isPolivane))
        case 2:
            return    AnyView(ArdaView200(isPolivane: $isPolivane))
        case 3:
            return    AnyView(ArdaView300(isPolivane: $isPolivane))
        case 4:
            return    AnyView(ArdaView400(isPolivane: $isPolivane))
        case 5:
            return    AnyView(ArdaView500(isPolivane: $isPolivane))
        case 6:
            return    AnyView(ArdaView600(isPolivane: $isPolivane))
        case 7:
            return    AnyView(ArdaView700(isPolivane: $isPolivane))
        case 8:
            return    AnyView(ArdaView800(isPolivane: $isPolivane))
        case 9:
            return    AnyView(ArdaView900(isPolivane: $isPolivane))
        case 10:
            return    AnyView(ArdaView1000(isPolivane: $isPolivane))
        case 11:
            return    AnyView(ArdaView1100(isPolivane: $isPolivane))
        case 12:
            return    AnyView(ArdaView1200(isPolivane: $isPolivane))
        case 13:
            return    AnyView(ArdaView1300(isPolivane: $isPolivane))
        case 14:
            return    AnyView(ArdaView1400(isPolivane: $isPolivane))
        case 15:
            return    AnyView(ArdaView1500(isPolivane: $isPolivane))
        case 16:
            return    AnyView(ArdaView1600(isPolivane: $isPolivane))

        default:
            return    AnyView(ArdaView1600(isPolivane: $isPolivane))
        }
        
       
    }
    
    
    func loadData(){
        
     for num in 0..<chose.choseBranchNew.count {
            
            let loaddata = GameLock(context: moc)
            
            loaddata.idG        =  Int16(chose.choseBranchNew[num].id)
            loaddata.isLockG    =  chose.choseBranchNew[num].isLock
            loaddata.isOnOffG   =  chose.choseBranchNew[num].isOnOff
            loaddata.textG      =  chose.choseBranchNew[num].text
            loaddata.imageG     =  chose.choseBranchNew[num].image
            loaddata.totallG    =  Float(chose.choseBranchNew[num].totall)
            loaddata.reklamaG   =  chose.choseBranchNew[num].reklama
            loaddata.timeDateG  =  Date()
            
            
            do {
                try  self.moc.save()
                print(".... ok ....")
            }catch{
                print(".... no ....")
            }
        }
        
    }
}

struct FirstNewView_Previews: PreviewProvider {
    static var previews: some View {
        FirstNewView()
    }
}



