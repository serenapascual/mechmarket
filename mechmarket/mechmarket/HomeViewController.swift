//
//  ViewController.swift
//  mechmarket
//
//  Created by Serena Pascual on 11/4/20.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {
	let semaphore = DispatchSemaphore(value: 0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		initHomeView()
		
		if let receivedData: Data = KeyChainService.load(key: "UserlessToken") {
			let result = String(data: receivedData, encoding: .utf8)!
			print("hey, token exists!: \(result)")
		}
		else {
			print("no existing token. initiating request")
			obtainUserlessToken()
		}
	}
	
	func obtainUserlessToken() {
		let request = createTokenRequest()
		handleTokenRequest(request: request)
	}
	
	func createTokenRequest() -> URLRequest {
		let parameters = "grant_type=https://oauth.reddit.com/grants/installed_client&device_id=DO_NOT_TRACK_THIS_DEVICE"
		let postData =  parameters.data(using: .utf8)

		let credentialsString = "Z4ERZ6j03yINfA:".data(using: .utf8)!
		let credentialsBase64 = Data(credentialsString).base64EncodedString()
		
		var request = URLRequest(url: URL(string: "https://www.reddit.com/api/v1/access_token/?response_type=code")!,timeoutInterval: Double.infinity)
		request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.addValue("Basic \(credentialsBase64.string)", forHTTPHeaderField: "Authorization")

		request.httpMethod = "POST"
		request.httpBody = postData
		
		return request
	}
	
	func handleTokenRequest(request: URLRequest) {
		let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
			guard let data = data else {
				print(String(describing: error))
				return
			}
			print(String(data: data, encoding: .utf8)!)
			
			// Check for access token in HTTP response and store in keychain if found
			do {
				guard let dataTaskJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
					print("ERROR: Could not serialize json object")
					return
				}
				guard let token = dataTaskJson["access_token"] as? String else {
					print("ERROR: Could not find value in json object for key \"access_token\"")
					return
				}
				let status = KeyChainService.store(key: "UserlessToken", value: token)
				guard status == 0 else {
					print("ERROR: Token could not be added to keychain (status \(status))")
					return
				}
				print("SUCCESS: Token added to keychain")
			}
			catch {
				print(error.localizedDescription)
			}
			
			semaphore.signal()
		}
		task.resume()
		semaphore.wait()
	}
	
	func initHomeView() {
		let searchBarTitle = UILabel()
		searchBarTitle.text = "What would you like to find?"
		searchBarTitle.textColor = UIColor.black
		searchBarTitle.translatesAutoresizingMaskIntoConstraints = false

		let searchBar = UISearchBar()
		searchBar.placeholder = "KAT Milkshake"
		searchBar.backgroundImage = UIImage()
		searchBar.compatibleSearchTextField.leftView?.tintColor = UIColor.gray
		searchBar.compatibleSearchTextField.backgroundColor = UIColor.white
		
		searchBar.searchTextField.layer.shadowColor = UIColor.black.cgColor
		searchBar.searchTextField.layer.shadowOpacity = 0.25
		searchBar.searchTextField.layer.shadowOffset = CGSize(width: 2, height: 2)
		searchBar.searchTextField.layer.shadowRadius = 3

		searchBar.translatesAutoresizingMaskIntoConstraints = false
		searchBar.delegate = self
		
		view.addSubview(searchBarTitle)
		view.addSubview(searchBar)
		
		let defaultPadding = CGFloat(20)
		let searchBarPadding = defaultPadding - 5
		
		searchBarTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: defaultPadding / 2).isActive = true
		searchBarTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultPadding).isActive = true
		searchBarTitle.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(defaultPadding * 2)).isActive = true
		searchBarTitle.heightAnchor.constraint(equalToConstant: 40).isActive = true
		
		searchBar.topAnchor.constraint(equalTo: searchBarTitle.bottomAnchor, constant: -5).isActive = true
		searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: searchBarPadding).isActive = true
		searchBar.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -(searchBarPadding * 2)).isActive = true
		searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
				
		searchBar.layoutIfNeeded()
	}
	
	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(true, animated: true)
	}
	
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		searchBar.setShowsCancelButton(false, animated: true)
		searchBar.resignFirstResponder()
	}
}

// Below code authored by Joshpy from StackOverflow ca. Sept 2019
// https://stackoverflow.com/a/58067550/7786888
extension UISearchBar {

	// Due to searchTextField property who available iOS 13 only, extend this property for iOS 13 previous version compatibility
	var compatibleSearchTextField: UITextField {
		guard #available(iOS 13.0, *) else { return legacySearchField }
		return self.searchTextField
	}

	private var legacySearchField: UITextField {
		if let textField = self.subviews.first?.subviews.last as? UITextField {
			// Xcode 11 previous environment
			return textField
		} else if let textField = self.value(forKey: "searchField") as? UITextField {
			// Xcode 11 run in iOS 13 previous devices
			return textField
		} else {
			// exception condition or error handler in here
			return UITextField()
		}
	}
}
