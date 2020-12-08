//
//  ViewController.swift
//  mechmarket
//
//  Created by Serena Pascual on 11/4/20.
//

import UIKit

class HomeViewController: UIViewController, UISearchBarDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
		
		obtainUserlessGrant()
	}
	
	func obtainUserlessGrant() {
		let semaphore = DispatchSemaphore (value: 0)
		
		let parameters = "grant_type=https://oauth.reddit.com/grants/installed_client&device_id=DO_NOT_TRACK_THIS_DEVICE"
		let postData =  parameters.data(using: .utf8)

		let credentialsString = "Z4ERZ6j03yINfA:".data(using: .utf8)!
		let credentialsBase64 = Data(credentialsString).base64EncodedString()
		
		var request = URLRequest(url: URL(string: "https://www.reddit.com/api/v1/access_token/?response_type=code")!,timeoutInterval: Double.infinity)
		request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.addValue("Basic \(credentialsBase64.string)", forHTTPHeaderField: "Authorization")

		request.httpMethod = "POST"
		request.httpBody = postData

		let task = URLSession.shared.dataTask(with: request) { data, response, error in
			guard let data = data else {
				print(String(describing: error))
				return
			}
			print(String(data: data, encoding: .utf8)!)
			do {
				if let dataTaskJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
					if let token = dataTaskJson["access_token"] as? String {
						print(token)
					}
					else {
						print("ERROR: Could not find value for key \"access_token\"")
					}
				}
				else {
					print("ERROR: Could not serialize json object")
				}
			}
			catch {
				print(error.localizedDescription)
			}
			
			semaphore.signal()
		}
		task.resume()
		semaphore.wait()
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
