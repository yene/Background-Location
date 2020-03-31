// ContentView.swift

import SwiftUI

struct ContentView: View {
	let lm = LocationManager()
	let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
	let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
	@EnvironmentObject var appData: AppData
	
	var body: some View {
		VStack {
			Form {
				Section(header: Text("Server")) {
					Text("Address")
					Spacer() // test group
					TextField("Server Address", text: $appData.serverAddress)
				}
				
				Section(header: Text("About")) {
					HStack {
						Text("Software Version")
						Spacer()
						Text("\(appVersion) (\(buildNumber))")
					}
				}
			}
		}
		.navigationBarTitle(Text("Settings"))
		.listStyle(GroupedListStyle())
	}

}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
