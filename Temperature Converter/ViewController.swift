//
//  ViewController.swift
//  Temperature Converter
//
//  Created by Farhad on 10/24/14.
//  Copyright (c) 2014 Web In Dream. All rights reserved.
//

import UIKit

//Step 1: Add protocol names that we will be delegating.

class ViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate, NSXMLParserDelegate {
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:NSString = ""
    
    
    
    @IBOutlet var txtCelsius : UITextField!
    @IBOutlet var txtFahrenheit : UITextField!
    
    
    @IBAction func actionConvert(sender : AnyObject) {
        let celcius = txtCelsius.text
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><CelsiusToFahrenheit xmlns='http://www.w3schools.com/xml/'><Celsius>\(celcius!)</Celsius></CelsiusToFahrenheit></soap12:Body></soap12:Envelope>"
        
        let urlString = "http://www.w3schools.com/xml/tempconvert.asmx"
        
        let url = NSURL(string: urlString)
        
        let theRequest = NSMutableURLRequest(URL: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = soapMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest, delegate: self, startImmediately: true)
        connection!.start()
        
        if (connection == true) {
            var mutableData : Void = NSMutableData.initialize()
        }

    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // NSURLConnectionDelegate
    
    // NSURL
    
    
    
    func connection(connection: NSURLConnection!, didReceiveResponse response: NSURLResponse!) {
        mutableData.length = 0;
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!) {
        mutableData.appendData(data)
    }
    
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        let response = NSString(data: mutableData, encoding: NSUTF8StringEncoding)
        
        let xmlParser = NSXMLParser(data: mutableData)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }

    
    // NSXMLParserDelegate
    
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName
    }
    
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        if currentElementName == "CelsiusToFahrenheitResult" {
            txtFahrenheit.text = string
        }
    }
}

