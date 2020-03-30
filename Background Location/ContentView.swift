// ContentView.swift

import SwiftUI

struct ContentView: View {
	let lm = LocationManager()
	var body: some View {
		VStack {
			Text("Hello, World!")
			Button(action: {
				print("hello world")
				self.lm.startMonitoring()
			}){
				Text("Start updating location")
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
