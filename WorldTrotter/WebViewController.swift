//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by Viswanath Subramani S S on 12/10/17.
//  Copyright © 2017 ViswanathSubramaniSS. All rights reserved.
//

import UIKit
import WebKit
class WebViewController: UIViewController {
	
	var webView: WKWebView!
	
	override func loadView() {
		webView = WKWebView()
		view = webView
		
		
	}
	
	override func viewDidLoad() {
		
	let url = URL(string: "https://www.bignerdranch.com/books/")
	let request = URLRequest(url: url!)
	webView.load(request)
	}
}
		

