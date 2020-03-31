// Utils.swift

import UIKit

// https://stackoverflow.com/a/56496669/279890
extension UIApplication {
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
}
