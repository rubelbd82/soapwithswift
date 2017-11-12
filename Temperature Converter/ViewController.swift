//
//  ViewController.swift
//  Temperature Converter
//
//  Created by Farhad on 10/24/14.
//  Copyright (c) 2014 Web In Dream. All rights reserved.
//

import UIKit

//Step 1: Add protocol names that we will be delegating.

class ViewController: UIViewController, UITextFieldDelegate, NSURLConnectionDelegate,NSURLConnectionDataDelegate,  XMLParserDelegate {
    
    var mutableData:NSMutableData  = NSMutableData()
    var currentElementName:String = ""

    @IBOutlet var txtCelsius : UITextField!
    @IBOutlet var txtFahrenheit : UITextField!
    
    @IBAction func actionConvert(_ sender: Any) {
        let celcius = txtCelsius.text
        
//        let soapMessage = "<?xml version='1.0' encoding='utf-8'?><soap12:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap12='http://www.w3.org/2003/05/soap-envelope'><soap12:Body><CelsiusToFahrenheit xmlns='http://www.w3schools.com/xml/'><Celsius>\(celcius!)</Celsius></CelsiusToFahrenheit></soap12:Body></soap12:Envelope>"
        
        
        let soapMessage = "<?xml version='1.0' encoding='utf-8'?>        <soap:Envelope xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:xsd='http://www.w3.org/2001/XMLSchema' xmlns:soap='http://schemas.xmlsoap.org/soap/envelope/'><soap:Body><ConvertTemp xmlns='http://www.webserviceX.NET/'><Temperature>\(celcius!)</Temperature><FromUnit>degreeCelsius</FromUnit><ToUnit>degreeFahrenheit</ToUnit></ConvertTemp></soap:Body></soap:Envelope>"
        
//        let urlString = "http://www.webservicex.net/ConvertTemperature.asmx"
        let urlString = "http://www.webservicex.net/ConvertTemperature.asmx"
        
        let url = URL(string: urlString)
        
        let theRequest = NSMutableURLRequest(url: url!)
        
        let msgLength = soapMessage.characters.count
        
        theRequest.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.addValue(String(msgLength), forHTTPHeaderField: "Content-Length")
        theRequest.httpMethod = "POST"
        theRequest.httpBody = soapMessage.data(using: String.Encoding.utf8, allowLossyConversion: false) // or false
        
        let connection = NSURLConnection(request: theRequest as URLRequest, delegate: self, startImmediately: true)
        
        connection!.start()
        
 
    
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
    
    


    
    // NSXMLParserDelegate
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        currentElementName = elementName
    }
    
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentElementName == "ConvertTempResult" {
            txtFahrenheit.text = string
        }
    }
    
    
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        print("connection error = \(error)")
    }
    
    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
        mutableData = NSMutableData()
    }
    
    
    func connection(_ connection: NSURLConnection, didReceive data: Data) {
        self.mutableData.append(data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        
        let xmlParser = XMLParser(data: mutableData as Data)
        xmlParser.delegate = self
        xmlParser.parse()
        xmlParser.shouldResolveExternalEntities = true
    }

}

