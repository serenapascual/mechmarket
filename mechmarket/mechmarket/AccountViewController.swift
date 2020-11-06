//
//  AccountViewController.swift
//  mechmarket
//
//  Created by Serena Pascual on 11/4/20.
//

import UIKit
import OAuthSwift
import SafariServices

class AccountViewController: UIViewController {
	
	let oauthswift = OAuth2Swift(consumerKey: "Z4ERZ6j03yINfA", consumerSecret: "", authorizeUrl: "https://www.reddit.com/api/v1/authorize", accessTokenUrl: "https://www.reddit.com/api/v1/access_token", responseType: "code")
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let view = UIView()
		let loginButton: UIButton = {
			let button = UIButton(type: .system)
			
			button.setTitle("Login with Reddit", for: .normal)
			button.tintColor = UIColor.white
			button.backgroundColor = UIColor.init(named: "AccentColor")
			
			button.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
			button.center = self.view.center
			
			button.addTarget(
				self,
					action: #selector(loginButtonAction),
					for: UIControl.Event.touchUpInside
			)
			
			return button
		}()
	 
		view.addSubview(loginButton)
		self.view = view
	}
    
	@objc func loginButtonAction(_ sender:UIButton!) {
		
//		oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
		oauthswift.accessTokenBasicAuthentification = true

		let _ = oauthswift.authorize(withCallbackURL: "mechmarket://oauth-callback", scope: "read", state: "stateOfFearAndConfusionOhGod") { result in
				switch result {
				case .success(let (credential, response, parameters)):
					print("--- SUCCESS ---\nCredential: \(credential.oauthToken)\nResponse: \(String(describing: response))\nParameters: \(parameters)")
				case .failure(let error):
					print("--- FAILURE ---\nError: \(error.description)")
				}
		}
	}

}
