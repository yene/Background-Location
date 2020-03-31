// AppData.swift

import Foundation
import Combine

final class AppData: ObservableObject  {
	
	@Published var serverAddress: String = UserDefaults.standard.string(forKey: "serverAddress") ?? "http://localhost:3000" {
		didSet {
			UserDefaults.standard.set(self.serverAddress, forKey: "serverAddress")
		}
	}
	@Published var isUpdatingLocation: Bool = UserDefaults.standard.bool(forKey: "isUpdatingLocation") {
		didSet {
			if (oldValue == self.isUpdatingLocation) {return}
			UserDefaults.standard.set(self.isUpdatingLocation, forKey: "isUpdatingLocation")
		}
	}
}
