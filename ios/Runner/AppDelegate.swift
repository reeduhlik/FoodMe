import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
     //GMSServices.provideAPIKey("AIzaSyC0IIiLl6i89dT9IiieDhayF1xcWRJgHs4Y")
     GMSServices.provideAPIKey(" AIzaSyAvfDPm_k6b_xjUGUpwXgFZ1yuuQ0ywQO8")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
