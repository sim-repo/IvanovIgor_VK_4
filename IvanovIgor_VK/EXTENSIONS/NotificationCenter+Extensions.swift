import Foundation

 // Задание 5: рефакторинг >>>
enum Model2PresenterNotification: String {
    case needDownload
    case needUpload
    case didModelChanged
}

extension NotificationCenter {
    func add(observer: Any, selector: Selector,
             notification: Model2PresenterNotification, object: Any? = nil) {
        addObserver(observer, selector: selector,
                    name: Notification.Name(notification.rawValue),
                    object: object)
    }
    func post(notification: Model2PresenterNotification,
              object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        post(name: NSNotification.Name(rawValue: notification.rawValue),
             object: object, userInfo: userInfo)
    }
}
 // Задание 5: рефакторинг <<<
