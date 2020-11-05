//
//  TabBarController.swift
//  mechmarket
//
//  Created by Serena Pascual on 11/4/20.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
		delegate = self
	}
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let home = HomeViewController()
		let homeIcon = UITabBarItem(title: "Home", image: UIImage(named: "HomeIcon"), selectedImage: UIImage(named: "HomeIcon"))
		home.tabBarItem = homeIcon
		
		let account = AccountViewController()
		let accountIcon = UITabBarItem(title: "Account", image: UIImage(named: "AccountIcon"), selectedImage: UIImage(named: "AccountIcon"))
		account.tabBarItem = accountIcon
		
		let controllers = [home, account]
		self.viewControllers = controllers
	}
	
	// Delegate method
//	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//		print("Should select viewController: \(viewController.title ?? "") ?")
//		return true;
//	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
