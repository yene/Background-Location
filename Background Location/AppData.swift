// AppData.swift

import Foundation
import Combine

final class AppData: ObservableObject  {
	
	@Published var serverAddress: String = UserDefaults.standard.string(forKey: "serverAddress") ?? "http://localhost:3000" {
		didSet {
			// TODO: debounce or every keyboard input calls set
			UserDefaults.standard.set(self.serverAddress, forKey: "firstToggle")
		}
	}

}
