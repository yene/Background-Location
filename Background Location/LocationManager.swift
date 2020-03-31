// LocationManager.swift
import UIKit
import Foundation
import CoreLocation

final class LocationManager: NSObject {
	static let shared = LocationManager()
	
	private var backgroundTask = UIBackgroundTaskIdentifier.invalid
	private let manager = CLLocationManager()
	var address = "http://localhost:3000"
	
	// TODO: find good balance between accuracy and tracking
	// Saving battery: changing location accuracy to kCLLocationAccuracyThreeKilometers when your app moves to the background. Doing so allows you to continue receiving location updates in a power-friendly manner.
	
	func startMonitoring() {
		manager.delegate = self
		// manager.activityType = .automotiveNavigation
		manager.pausesLocationUpdatesAutomatically = false // After a pause occurs, it is your responsibility to restart location services again
		manager.allowsBackgroundLocationUpdates = true
		manager.showsBackgroundLocationIndicator = true
		manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
		manager.distanceFilter = 100 // distance in meters
		manager.requestAlwaysAuthorization()
		manager.startUpdatingLocation()
	}
	func stopMonitoring() {
		manager.stopUpdatingLocation()
	}
}
extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
		print("LocationManager didStartMonitoringFor")
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("LocationManager \(error)")
	}
	
	func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
		print("LocationManager \(error)")
	}
	
	func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
		print("locationManagerDidPauseLocationUpdates")
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		postLocation(location: locations.first)
	}
}
extension LocationManager {
	private func postLocation(location: CLLocation?) {
		guard let location = location else { return }
		
		if UIApplication.shared.applicationState == .background {
			
			backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "test_Location", expirationHandler: {
				UIApplication.shared.endBackgroundTask(self.backgroundTask)
				self.backgroundTask = UIBackgroundTaskIdentifier.invalid
			})
			
			DispatchQueue.global(qos: .background).async {
				self.postRequest(location: location) { [weak self] in
					guard let self = self else { return }
					UIApplication.shared.endBackgroundTask(self.backgroundTask)
					self.backgroundTask = UIBackgroundTaskIdentifier.invalid
				}
			}
		} else {
			postRequest(location: location)
		}
		
	}
	
	private func postRequest(location: CLLocation, completion: (() -> Void)? = nil) {
		// TODO Send Post
		sendLocation(location: location)
	}
	
	struct JSONCoordinates : Codable {
		let lat : Double
		let lng : Double
	}
	
	private func sendLocation(location: CLLocation) {
		do {
			let cords = JSONCoordinates(lat: location.coordinate.latitude, lng: location.coordinate.longitude)
			let jsonData = try JSONEncoder().encode(cords)
			
			// let jsonString = String(data: jsonData, encoding: .utf8)!
			// print("sending: \(jsonString)")
			
			let url = URL(string: "\(address)/update/22")!
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			// do I have to do the length?
			request.setValue("\(String(describing: jsonData.count))", forHTTPHeaderField: "Content-Length")
			request.httpBody = jsonData // string or data?

			let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
				if let error = error {
					// self.handleClientError(error)
					print("error: \(error)")
					return
				}
				guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
					// self.handleServerError(response)
					return
				}
				/* if let data = data, let string = String(data: data, encoding: .utf8) {
					print("response", string)
				}*/
			}
			task.resume()
		} catch { print(error) }
	}
	
}

