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
    
    var urlMainJordanPageReq: URLRequest?
    
    var shoeType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func testButtonPressed(_ sender: NSButton) {
    }
    
    
    @IBAction func botButtonPressed(_ sender: NSButton)
    {
        AI_FirstStep_LoadWebsite_LoadPage()
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
                                            
                                            print("")
                                            
                                            print("CANADA HREF = \(itemCountryName!.first!["href"]!)")
                                        }
                                        
                                        /*
                                        else
                                        {
                                            itemCountryName = item.css(("a[class^='lang-tunnel__country-link js-countryLink']"))
                                            
                                            print(itemCountryName!.first!.text!)
                                            
                                            print("")
                                            
                                            print("USA HREF = \(itemCountryName!.first!["href"]!)")
                                        }
                                        */
                                        
                                        print("")
                                        
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
                                                            
                                                            self.urlMainJordanPageReq = urlReq
                                                            
                                                            break
                                                        }
                                                        
                                                        self.AI_SecondStep_LoadCategory_FindItem_LoadItem()
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
    
    func AI_SecondStep_LoadCategory_FindItem_LoadItem()
    {
        DispatchQueue.main.async
        {
            var urlReq: URLRequest?
            
            self.nikeWKWebView.load(self.urlMainJordanPageReq!)
            
            var foundItem = false
            
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
                                
                                self.shoeType = itemType.first!.text!
                                
                                print("item Type: \(itemType.first!.text!)")
                                
                                let itemUrl = item.css("a")
                                
                                print("item Url: \(itemUrl.first!["href"]!)")
                                
                                print("")
                                
                                if itemName.first!.text!.range(of:SharingManager.sharedInstance.shoeName) != nil
                                {
                                    foundItem = true
                                    
                                    urlReq = URLRequest(url: URL(string: itemUrl.first!["href"]!)!)
                                    
                                    self.nikeWKWebView.load(urlReq!)
                                    
                                    break
                                }
                                count += 1
                            }
                            
                            print("There are \(count) items!")
                            
                            print("")
                            
                            self.browserDelay.asyncAfter(deadline: .now() + self.delay)
                            {
                                DispatchQueue.main.async
                                {
                                    if (foundItem)
                                    {
                                        if (SharingManager.sharedInstance.shoeColor.isEmpty)
                                        {
                                            self.AI_FourthStep_SelectSize_AddToCart_Checkout()
                                        }
                                        else
                                        {
                                            self.AI_ThirdStep_SelectColor()
                                        }
                                    }
                                    else
                                    {
                                        self.AI_SecondStep_LoadCategory_FindItem_LoadItem()
                                    }
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    func AI_ThirdStep_SelectColor()
    {
        DispatchQueue.main.async
        {
            var urlReq: URLRequest?
            
            self.nikeWKWebView.evaluateJavaScript("document.documentElement.outerHTML.toString()", completionHandler: { (html: Any?, error: Error?) in
                
                let htmlText = html as! String
                
                if let doc = try? Kanna.HTML(html: htmlText, encoding: .utf8)
                {
                    for item in doc.css("div[class^='colorway-container d-sm-ib d-lg-tc pr1-sm css-1eouwf2']")
                    {
                        let itemSelection = item.css("a[role^='option']")
                        
                        let itemColour = item.css("img[alt]")

                        print("item Colour = \(itemColour.first!["alt"]!)")
                        print("item Href: \(itemSelection.first!["href"]!)")
                        print("")
                        
                        if itemColour.first!["alt"]!.range(of:SharingManager.sharedInstance.shoeColor) != nil
                        {
                            urlReq = URLRequest(url: URL(string: itemSelection.first!["href"]!)!)
                                    
                            self.nikeWKWebView.load(urlReq!)
                                    
                            break
                        }
                    }
                }
                
                self.browserDelay.asyncAfter(deadline: .now() + self.delay)
                {
                    DispatchQueue.main.async
                    {
                        self.AI_FourthStep_SelectSize_AddToCart_Checkout()
                    }
                }
            })
        }
    }
    
    func AI_FourthStep_SelectSize_AddToCart_Checkout()
    {
        DispatchQueue.main.async
        {
            let maleStringSize = String(SharingManager.sharedInstance.shoeSize)
            
            let convertStringDoubleSize = Double(maleStringSize)
            
            let femaleDoubleSize = convertStringDoubleSize! + 1.5
            
            let femaleStringSize = String(femaleDoubleSize)
            
            self.browserDelay.asyncAfter(deadline: .now() + 5)
            {
                DispatchQueue.main.async
                {
                    if self.shoeType == "Shoe" || self.shoeType == "Men's Basketball Shoe"
                    {
                        self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"input[aria-label='US M \" + \(maleStringSize) + \" / W \" + \(femaleStringSize) + \"']\").click();", completionHandler: nil)
                    }
                    else
                    {
                        self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"input[aria-label='US \(maleStringSize)']\").click();", completionHandler: nil)
                    }
                    
                    self.nikeWKWebView.scrollToEndOfDocument(self)
                    
                    self.browserDelay.asyncAfter(deadline: .now() + 10)
                    {
                        DispatchQueue.main.async
                        {
                            self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"button[aria-label='Add to Cart']\").click();", completionHandler: nil)
                            
                            self.browserDelay.asyncAfter(deadline: .now() + self.delay)
                            {
                                DispatchQueue.main.async
                                {
                                    self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"button[data-test='qa-cart-checkout']\").click();", completionHandler: nil)
                                    
                                    self.browserDelay.asyncAfter(deadline: .now() + self.delay)
                                    {
                                        DispatchQueue.main.async
                                        {
                                            self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"div[class='js-guestCheckout ch4_btn cartButton ch4_btnOrange']\").click();", completionHandler: nil)
                                            
                                            self.browserDelay.asyncAfter(deadline: .now() + 50)
                                            {
                                                DispatchQueue.main.async
                                                {
                                                    self.AI_FifthStep_Shipping_Billing_Payment()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func AI_FifthStep_Shipping_Billing_Payment()
    {
        DispatchQueue.main.async
        {
            //self.nikeWKWebView.evaluateJavaScript("var e = document.getElementById(\"Shipping_FirstName\"); e.value = \(SharingManager.sharedInstance.firstName); var $e = angular.element(e); $e.triggerHandler('input');", completionHandler: nil)
            
            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"Shipping_FirstName\").value = \(SharingManager.sharedInstance.firstName); document.getElementById(\"Shipping_FirstName\").dispatchEvent(new Event('input'));", completionHandler: nil)
            
            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"Shipping_LastName\").value = \(SharingManager.sharedInstance.lastName); document.getElementById(\"Shipping_LastName\").dispatchEvent(new Event('input'));", completionHandler: nil)
            
            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"Shipping_PostCode\").value = \(SharingManager.sharedInstance.postalCode); document.getElementById(\"Shipping_PostCode\").dispatchEvent(new Event('input'));", completionHandler: nil)
            
            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"Shipping_Address1\").value = \(SharingManager.sharedInstance.address); document.getElementById(\"Shipping_Address1\").dispatchEvent(new Event('input'));", completionHandler: nil)
            
             self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"Shipping_Address3\").value = \(SharingManager.sharedInstance.municipality); document.getElementById(\"Shipping_Address3\").dispatchEvent(new Event('input'));", completionHandler: nil)
            
            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"Shipping_Territory\").value = \(SharingManager.sharedInstance.province); document.getElementById(\"Shipping_Territory\").dispatchEvent(new Event('input'));", completionHandler: nil)
            
            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"Shipping_phonenumber\").value = \(SharingManager.sharedInstance.phone); document.getElementById(\"Shipping_phonenumber\").dispatchEvent(new Event('input'));", completionHandler: nil)
            
            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"shipping_Email\").value = \(SharingManager.sharedInstance.email); document.getElementById(\"shipping_Email\").dispatchEvent(new Event('input'));", completionHandler: nil)
            
            self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"span[class='checkbox-checkmark']\").click();", completionHandler: nil)
            
            self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"button[id='shippingSubmit']\").click();", completionHandler: nil)
            
            self.browserDelay.asyncAfter(deadline: .now() + self.delay)
            {
                DispatchQueue.main.async
                {
                    self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"button[id='billingSubmit']\").click();", completionHandler: nil)
                    
                    self.browserDelay.asyncAfter(deadline: .now() + self.delay)
                    {
                        DispatchQueue.main.async
                        {
                            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"CreditCardHolder\").value = \(SharingManager.sharedInstance.cardName); document.getElementById(\"CreditCardHolder\").dispatchEvent(new Event('input'));", completionHandler: nil)
                            
                            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"KKnr\").value = \(SharingManager.sharedInstance.cardNumber); document.getElementById(\"KKnr\").dispatchEvent(new Event('input'));", completionHandler: nil)
                            
                            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"KKMonth\").value = \(SharingManager.sharedInstance.expMonth); document.getElementById(\"KKMonth\").dispatchEvent(new Event('change'));", completionHandler: nil)
                            
                            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"KKYear\").value = \(SharingManager.sharedInstance.expYear); document.getElementById(\"KKYear\").dispatchEvent(new Event('change'));", completionHandler: nil)
                            
                            self.nikeWKWebView.evaluateJavaScript("document.getElementById(\"CCCVC\").value = \(SharingManager.sharedInstance.securityCode); document.getElementById(\"CCCVC\").dispatchEvent(new Event('input'));", completionHandler: nil)
                            
                            self.nikeWKWebView.evaluateJavaScript("document.querySelector(\"button[id='BtnPurchase']\").click();", completionHandler: nil)
                        }
                    }
                }
            }
        }
    }
}

