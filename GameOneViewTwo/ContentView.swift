//
//  ContentView.swift
//  GameOneViewTwo
//
//  Created by Ivan Dimitrov on 29.09.20.
//

import SwiftUI
import CoreData
import UserNotifications

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: GameLock.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \GameLock.idG, ascending: true)]) var gameLock: FetchedResults<GameLock>
    @EnvironmentObject var timeOnOff : TimeOnOff
    @State var ppValue : Int = 0
    @State var ttValue : Int = 0
    @State var doubleTime : Double = 0
    
  
    var body: some View {

        FirstNewView()
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
                print("Moving to the background")
                // Вика нотификацията като излезеш от приложението след 5 секунди
                if timeOnOff.pauseValue != 0 {
                    createNotification()
                }
              
                
                let toDay = Date()
                self.timeOnOff.isNotification = true
                let diffComponents = Calendar.current.dateComponents([.second, .minute], from: toDay)
                let sec = diffComponents.second
                let min = diffComponents.minute
                print("...\(Int(sec!) + (Int(min!) * 60))")
                
                timeOnOff.offApp = Int(sec!) + (Int(min!) * 60)
                UserDefaults.standard.set(false, forKey: "ShowEnemy")
            })
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
                print("Moving to App")
                let toDay = Date()
                self.timeOnOff.isNotification = false
                let diffComponents = Calendar.current.dateComponents([.second, .minute], from: toDay)
                let sec = diffComponents.second
                let min = diffComponents.minute
                print("...\(Int(sec!) + (Int(min!) * 60))")
                
                timeOnOff.onApp = Int(sec!) + (Int(min!) * 60)
                
                print("\(timeOnOff.onApp - timeOnOff.offApp)!!!")
                
                self.ttValue  = timeOnOff.onApp - timeOnOff.offApp
                self.ppValue  = timeOnOff.pauseValue
                print("\(ppValue)...\(ttValue)...")
//                if ppValue > ttValue {
//                                     timeOnOff.pauseValue = ppValue - ttValue
//                }else{
//                                     timeOnOff.pauseValue = 10
//                }
                
                if timeOnOff.onApp - timeOnOff.offApp > 30 + timeOnOff.pauseValue {
                    timeOnOff.start = 0
                    timeOnOff.pauseTimer()
                    print("Out from App")
                }
                UserDefaults.standard.set(true, forKey: "ShowEnemy")
                readDate()
                saveDate()
            })
            .onAppear() {
                // Иска разрешение да изпраща нотификации като зареди ContentView
                notificationPermission()
              
                //
            }
//        ProbaView()
    }
    
    func saveDate() {

            gameLock[UserDefaults.standard.integer(forKey: "Arda")].timeDateG = Date()
            do {
                try  self.moc.save()
                     print(" ok totall")
            }catch{
                     print(" no totall")
            }
    }
    
    func readDate(){
        var to = 0
        var ho = 0


        guard       let hoDay = gameLock[UserDefaults.standard.integer(forKey: "Arda")].timeDateG else {
            print("return............rerurn")
            return}
                    let hoComponents = Calendar.current.dateComponents([.day, .hour, .minute ], from: hoDay)
                    let hoday    = hoComponents.day
                    let hohour   = hoComponents.hour
                    let hominute = hoComponents.minute

                    let toDay = Date()
                    let toComponent = Calendar.current.dateComponents([.day, .hour, .minute], from: toDay)
                    let today     = toComponent.day
                    let tohour    = toComponent.hour
                    let tominute  = toComponent.minute

                    to = (Int(tohour!) * 60 ) + Int(tominute!) + (Int(today!) * 1440)
                    ho = (Int(hohour!) * 60 ) + Int(hominute!) + (Int(hoday!) * 1440)
                    print("\(Int(to - ho ))....>>>>")
                    print("\(hoDay)....>>>>")
                    print("\(toDay)....>>>>")

        if Int(to - ho ) > 3 {
//            3 minute and tree dead
                             UserDefaults.standard.set(true, forKey: "TreeDead")
                             UserDefaults.standard.set(false, forKey: "Polivane")
                             UserDefaults.standard.set(false, forKey: "ViewEnemy")
        }else{
                             UserDefaults.standard.set(false, forKey: "TreeDead")
            if Int(to - ho ) > 2 {
//                2 minute and tree nead of Polivane
                             UserDefaults.standard.set(true, forKey: "Polivane")
                             UserDefaults.standard.set(false, forKey: "ViewEnemy")
            }else{
                             UserDefaults.standard.set(false, forKey: "Polivane")
                          
                if Int(to - ho ) > 1 {
//                    2 minute and you view Enemy
                             UserDefaults.standard.set(true, forKey: "ViewEnemy")
                }else{
                             UserDefaults.standard.set(false, forKey: "ViewEnemy")
                }
            }
        }

    }
    
    func notificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
               
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func createNotification () {
        let content = UNMutableNotificationContent()
        content.title = "Go back to the app"
        content.subtitle = "You will lose your points in 30 sec"
        content.sound = UNNotificationSound.default
        doubleTime = Double(timeOnOff.pauseValue) - 30
        if doubleTime <= 0 {
            doubleTime = 10
        }
//        if timeOnOff.pauseValue == 10 {
//                     doubleTime = 10
//        }else{
//                     doubleTime = Double(timeOnOff.pauseValue) - 20
//            if doubleTime <= 0 {
//                     doubleTime = 1
//            }
//
//        }
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: doubleTime  , repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
//        ContentView()
        Text("alo")
    }
}
