//
//  KeychainService.swift
//  mechmarket
//
//  Created by Serena Pascual on 11/18/20.
//

import Foundation
import Security

public class KeyChainService: NSObject {
	class func store(key: String, value: String) -> OSStatus {
		let query = [
			kSecAttrAccount: key,
			kSecValueData: value.data(using: .utf8)!,
			kSecClass: kSecClassGenericPassword,
			kSecReturnAttributes: true,
			kSecReturnData: true
		] as CFDictionary
		
		SecItemDelete(query)
		return SecItemAdd(query, nil)
	}
	
	class func load(key: String) -> Data? {
		let query = [
			kSecAttrAccount: key,
			kSecClass: kSecClassGenericPassword,
			kSecReturnAttributes: true,
			kSecReturnData: true
		  ] as CFDictionary
		
		var resultReference: AnyObject?
		let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &resultReference)
		
		if status == noErr {
			let resultDictionary = resultReference as! NSDictionary
			return resultDictionary[kSecValueData] as? Data
		} else {
			return nil
		}
	}
}
