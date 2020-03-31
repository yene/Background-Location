// ContentView.swift

import SwiftUI

struct ContentView: View {
	
	let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
	let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
	@EnvironmentObject var appData: AppData
	@State var addressTextField: String = ""
	@State var isMonitoring = false
	let lm = LocationManager()
	
	
	var body: some View {
		NavigationView {
			Form {
				Section(header: Text("Server")) {
					HStack{
						Text("Address")
						Spacer()
						// Note(yw): we don't bind directly to the environment, to prevent every keyboard tap triggering a save.
						TextField("http://server:port", text: $addressTextField, onCommit: {
							self.appData.serverAddress = self.addressTextField
						}).multilineTextAlignment(.trailing).keyboardType(.URL).textContentType(.URL).autocapitalization(.none).disableAutocorrection(true)
					}
					
					HStack{
						Spacer()
						if (appData.isUpdatingLocation == true) {
							Button(action: {
								UIApplication.shared.endEditing()
								self.lm.stopMonitoring()
								self.appData.isUpdatingLocation = false
							}){
								Text("Stop").foregroundColor(.red).fontWeight(.bold)
							}
						} else {
							Button(action: {
								UIApplication.shared.endEditing()
								self.lm.address = self.addressTextField
								self.lm.startMonitoring()
								self.appData.isUpdatingLocation = true
							}){
								Text("Start").fontWeight(.bold)
							}
						}
						Spacer()
					}}
				
				Section(header: Text("About")) {
					HStack {
						Text("Software Version")
						Spacer()
						Text("\(appVersion) (\(buildNumber))")
					}
				}
			}
			.navigationBarTitle(Text("Background Location"))
		}
		.onAppear(perform: didAppear)
	}
	private func didAppear() {
		self.addressTextField = self.appData.serverAddress
		
		if (appData.isUpdatingLocation) {
			// Monitoring was turned on, could be that it paused for some reason. There is no harm in starting it again.
			self.lm.address = appData.serverAddress
			self.lm.startMonitoring()
		}
		
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
