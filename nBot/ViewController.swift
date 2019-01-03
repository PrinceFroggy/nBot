//
//  ViewController.swift
//  nBot
//
//  Created by Andrew Solesa on 2019-01-02.
//  Copyright © 2019 KSG. All rights reserved.
//

import Cocoa
import WebKit
import Kanna

class ViewController: NSViewController {

    @IBOutlet weak var nikeWKWebView: WKWebView!
    
    let browserDelay = DispatchQueue(label: "browswerBackground", qos: .userInitiated)
    
    var delay = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let urlReq = URLRequest(url: URL(string: "https://store.nike.com/ca/en_gb/pw/mens-jordan-shoes/7puZofqZoi3")!)
        
        self.nikeWKWebView.load(urlReq)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func buttonPressed(_ sender: NSButton)
    {
        AI_FirstStep_LoadCategory_FindItem()
    }
    
    func AI_FirstStep_LoadCategory_FindItem()
    {
        DispatchQueue.main.async
            {
                let urlReq = URLRequest(url: URL(string: "https://store.nike.com/ca/en_gb/pw/mens-jordan-shoes/7puZofqZoi3")!)
                
                self.nikeWKWebView.load(urlReq)
                
                self.browserDelay.asyncAfter(deadline: .now() + self.delay)
                {
                    DispatchQueue.main.async
                        {
                            self.nikeWKWebView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html: Any?, error: Error?) in
                                
                                let htmlText = html as! String
                                
                                var count = 0
                                
                                if let doc = try? Kanna.HTML(html: htmlText, encoding: .utf8)
                                {
                                    for item in doc.css("div[class^='grid-item fullSize']")
                                    {
                                        for itemName in item.css(("p[class^='product-display-name nsg-font-family--base edf-font-size--regular nsg-text--dark-grey']"))
                                        {
                                            print(itemName.text!)
                                        }
                                        count += 1
                                    }
                                    
                                    print("There are \(count) items!")
                                }
                                
                                })
                        }
                }
            }
    }
}
