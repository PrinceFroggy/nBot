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
    
    var settingsViewController: NSViewController?
    
    let browserDelay = DispatchQueue(label: "browswerBackground", qos: .userInitiated)
    
    var delay = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //let urlReq = URLRequest(url: URL(string: "https://store.nike.com/ca/en_gb/pw/mens-jordan-shoes/7puZofqZoi3")!)
        
        //self.nikeWKWebView.load(urlReq)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func botButtonPressed(_ sender: NSButton)
    {
        AI_FirstStep_LoadWebsite_LoadPage()
        //AI_SecondStep_LoadCategory_FindItem()
    }
    
    @IBAction func settingsButtonPressed(_ sender: NSButton)
    {
        if (self.settingsViewController == nil)
        {
            let storyBoard = NSStoryboard(name: "Main", bundle: nil) as NSStoryboard
            settingsViewController = storyBoard.instantiateController(withIdentifier: "settings") as? NSViewController
        }
        
        self.presentAsModalWindow(settingsViewController!)
    }
    
    func AI_FirstStep_LoadWebsite_LoadPage()
    {
        DispatchQueue.main.async
        {
            var urlReq: URLRequest?
                
            urlReq = URLRequest(url: URL(string: "https://www.nike.com/language_tunnel")!)
            
            self.nikeWKWebView.load(urlReq!)
            
            self.browserDelay.asyncAfter(deadline: .now() + self.delay)
            {
                DispatchQueue.main.async
                {
                    self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"button[class='lang-tunnel__region is--n-america js-regionBtn']\").click();", completionHandler: nil)
                    
                    self.browserDelay.asyncAfter(deadline: .now() + self.delay)
                    {
                        DispatchQueue.main.async
                        {
                            self.nikeWKWebView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html: Any?, error: Error?) in
                                
                                let htmlText = html as! String
                                
                                if let doc = try? Kanna.HTML(html: htmlText, encoding: .utf8)
                                {
                                    for item in doc.css("div[class^='lang-tunnel__country-container js-countryContainer lang-tunnel--is-visible lang-tunnel--is-current']")
                                    {
                                        var itemCountryName: XPathObject?
                                        
                                        if  SharingManager.sharedInstance.country == "CA"
                                        {
                                            itemCountryName = item.css("a[class^='lang-tunnel__language-link js-languageLink']")
                                            
                                            print(itemCountryName!.first!.text!)
                                            
                                            print("CANADA HREF =\(itemCountryName!.first!["href"]!)")
                                        }
                                        else
                                        {
                                            itemCountryName = item.css(("a[class^='lang-tunnel__country-link js-countryLink']"))
                                            
                                            print(itemCountryName!.first!.text!)
                                            
                                            print("USA HREF =\(itemCountryName!.first!["href"]!)")
                                        }
                                        
                                        urlReq = URLRequest(url: URL(string: itemCountryName!.first!["href"]!)!)
                                        
                                        self.nikeWKWebView.load(urlReq!)
                                        
                                        self.browserDelay.asyncAfter(deadline: .now() + self.delay)
                                        {
                                            DispatchQueue.main.async
                                            {
                                                self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"a[class='gnav-bar--section-tab has--sub-nav js-navItemWithSubNav js-rootItem js-navItem']\").click();", completionHandler: nil)
                                                
                                                self.nikeWKWebView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html: Any?, error: Error?) in
                                                    
                                                    let htmlText = html as! String
                                                    
                                                    if let doc = try? Kanna.HTML(html: htmlText, encoding: .utf8)
                                                    {
                                                        for item in doc.css("a[data-subnav-label^='Jordan']")
                                                        {
                                                            urlReq = URLRequest(url: URL(string: "\(item["href"]!)")!)
                                                            
                                                            break
                                                        }
                                                        
                                                        self.nikeWKWebView.load(urlReq!)
                                                        
                                                        self.AI_SecondStep_LoadCategory_FindItem()
                                                    }
                                                })
                                            }
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    func AI_SecondStep_LoadCategory_FindItem()
    {
        DispatchQueue.main.async
            {
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
                                        print("item: \(count)")
                                        
                                        let itemName = item.css("p[class^='product-display-name nsg-font-family--base edf-font-size--regular nsg-text--dark-grey']")
                                        
                                        /*
                                        for itemName in item.css(("p[class^='product-display-name nsg-font-family--base edf-font-size--regular nsg-text--dark-grey']"))
                                        {
                                            print(itemName.text!)
                                        }
                                        */
                                            
                                        print("item Name: \(itemName.first!.text!)")
                                        
                                        let itemType = item.css("p[class^='product-subtitle nsg-font-family--base edf-font-size--regular nsg-text--medium-grey']")
                                        
                                        print("item Type: \(itemType.first!.text!)")
                                        
                                        //CHECK IF CHECKLIST ITEM NAME MATCHES CURRENT ITEM
                                        
                                        let itemUrl = item.css("a")
                                        
                                        print("item Url: \(itemUrl.first!["href"]!)")
                                            
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
