//
//  ViewController.swift
//  Local Notifications
//
//  Created by unthinkable-mac-0025 on 08/06/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController , UNUserNotificationCenterDelegate {

    //1)create notification center
    let notificationCenter = UNUserNotificationCenter.current()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationCenter.delegate = self
        
        //getting permisssion via alert to show notification
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
        }
    }

    @IBAction func testButtonPressed(_ sender: UIButton) {
        
        //2)content of notification
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "myCategoryID"
        content.title = "Test Local Notification"
        content.body = "This is the body of the Local Notification"
        //content.badge = 0
        content.sound = .default
        content.userInfo = ["name" : "Dhanajit"]
        
        //3)trigger time of notification
//        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        //method 2
        let date = Date().addingTimeInterval(5)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //4)request notification
        let identifier = "mainID"
        let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: trigger)
        
        //5)add request to notoficationCenter
        notificationCenter.add(request, withCompletionHandler: { error in
            if error != nil {
                print("something went wrong")
            }
        })
        
        //add action to notification
        let like = UNNotificationAction.init(identifier: "Like", title: "Like", options: .foreground)
        let delete = UNNotificationAction.init(identifier: "Delete", title: "Delete", options: .destructive)
        let category = UNNotificationCategory.init(identifier: content.categoryIdentifier, actions: [like, delete], intentIdentifiers: [], options: [])
        notificationCenter.setNotificationCategories([category])
    }
    
    //to manage notifcation when the app running in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("app in foregorund, initiating local notification")
        completionHandler([.banner, .badge, .sound])
    }
    
    //to manage the clicks on the notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("notification clicked, jumping to second VC")
        let destinationVC = self.storyboard?.instantiateViewController(identifier: "secondVCID") as! SecondViewController
        if let dict = response.notification.request.content.userInfo as? [AnyHashable : Any]{
            destinationVC.str = dict["name"] as! String
        }
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
        completionHandler()
    }
    
}

