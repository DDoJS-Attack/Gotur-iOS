# gotur-backend-app

iOS web client made wtih Swift3 and Xcode.

### Team Members
* [Burak Bilge Yalçınkaya](https://github.com/bbyalcinkaya)
* [İsmail Namdar](https://github.com/ismailnamdar)
* [Uğur Uysal](https://github.com/uguruysal0)
* [Sadık Ekin Özbay](https://github.com/sadikekin)
* [Şahin Olut](https://github.com/norveclibalikci)

### Used Pods and Technologies
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)
* [GoogleMaps](https://developers.google.com/maps/documentation/ios-sdk/)
* [IQKeyboardManager](https://github.com/hackiftekhar/IQKeyboardManager)
* [Socket.IO-Client-Swift](https://github.com/socketio/socket.io-client-swift)
* [Firebase](https://firebase.google.com)
* [Omise](https://github.com/omise/omise-ios)

### What is götür?
Götür is a mobile application that allows people to be freelance courier. People can use it for transporting of their belongings.

### Screens
![Entrance](/Images/Entrance.png)
This view comes up when the user first enters the app. S/he can decide whether s/he is courier or normal user

![Entrance](/Images/UserView.png)
This view shows up when user is clicked sign in as user

![Entrance](/Images/UserVieiw_MyPackets.png)
This is an alert view with the table view. It shows users' current packages.

![Entrance](/Images/UserView_CreatePackage.png)
This view is for creating a package. We used Google Locations for taking source and destination address.

![Entrance](/Images/UserView_Payment.png)
When the user clicked save, we redirect the user to this page for payment.

![Entrance](/Images/PackageVeiw.png)
This view shows up when user is clicked sign in as courier

![Entrance](/Images/PackageVeiw_MyPackages.png)
This is an alert view with the table view. It shows couriers' current packages.

### Features
* It allows user to track theiri package. We implemented this with socket IO. 🛵
* We can send notifications to user by using Firebase. 🎯
* If the user is decided to take the package by their self, they can delete the package from our App. 🤗
* If the user is close to the destination location, they can drop the package. If they are not close, our app does not allow them to drop. 👊
