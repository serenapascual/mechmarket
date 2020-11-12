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
	
	var oauthswift: OAuth2Swift!
	
	var log: ((Result<OAuthSwift.TokenSuccess, OAuthSwiftError>) -> Void) = { result in
		switch result {
		 case .success(let (credential, _, _)):
			 print(credential.oauthToken)
		 case .failure(let error):
			 print(error.localizedDescription)
		}
	}
	
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
					for: UIControl.Event.touchUpInside)
			
			return button
		}()
	 
		view.addSubview(loginButton)
		self.view = view
	}
	
	@objc func loginButtonAction(_ sender:UIButton!) {
		print("Login tapped")

		doOAuthReddit()
	}
}

extension AccountViewController {
	func doOAuthReddit() {
		self.oauthswift = OAuth2Swift(
			consumerKey: "Z4ERZ6j03yINfA",
			consumerSecret: "",
			authorizeUrl: "https://www.reddit.com/api/v1/authorize.compact",
			accessTokenUrl: "https://www.reddit.com/api/v1/access_token",
			responseType: "code")
		
		oauthswift.accessTokenBasicAuthentification = true
		oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)

		let _ = oauthswift.authorize(
			withCallbackURL: "mechmarket://oauth-callback",
			scope: "read",
			state: "aStateOfFearAndConfusionOhDear") { result in
			self.log(result)
		}
	}

}
