//
//  ViewController.swift
//  mechmarket
//
//  Created by Serena Pascual on 11/4/20.
//

import UIKit

class HomeViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
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
		  semaphore.signal()
		}

		task.resume()
		semaphore.wait()
	}
	
}

