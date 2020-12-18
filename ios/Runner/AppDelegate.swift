import UIKit
import Flutter
import GoogleMaps //Add

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

  // Add
       GMSServices.provideAPIKey("AIzaSyD9UUOuySpi7LWtzWwEAOdCdpNAeqmEa2A")


    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
