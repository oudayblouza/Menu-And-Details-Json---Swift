//
//  DetailNewsViewController.swift
//  Ouday_Blouza_APP
//
//  Created by Ouday Blouza on 23/10/2018.
//  Copyright © 2018 Ouday Blouza. All rights reserved.
//

import UIKit
import WebKit

class DetailNewsViewController: UIViewController , WKNavigationDelegate {
    //initiate a "new" object with data from the tableView
 var new : News?
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgvCover: UIImageView!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblCategorie: UILabel!
    @IBOutlet weak var lblLink: UILabel!
      let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = new?.newsTitle
        let attr = try? NSAttributedString(htmlString: (new?.newsBody)!)
        lblDescription.attributedText = attr
        lblSubTitle.text = new?.newsSubTitle
        lblCategorie.text = new?.newsCat
        lblLink.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(linkAction)))
        lblLink.isUserInteractionEnabled = true
        let imageUrlString = URLS.GETURL+(new?.newsThumbImage)!
        let imageUrl:URL = URL(string: imageUrlString)!
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageData:NSData = NSData(contentsOf: imageUrl)!
          // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                self.imgvCover.image = image!
            }
        }
    }
    // function to open a WebViewer  page with a dynamic link
    @objc func linkAction () {
        guard let url = URL(string: URLS.GETURL+(new?.newsUrl)!) else { return }
        webView.frame = view.bounds
        webView.navigationDelegate = self
        webView.load(URLRequest(url: url))
        webView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        view.addSubview(webView)
    }
    
    // instanciate and create a WebView
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix( URLS.GETURL+(new?.newsUrl)!),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                print("Redirected to browser. No need to open it locally")
                decisionHandler(.cancel)
            } else {
                print("Open it locally")
                decisionHandler(.allow)
            }
        } else {
            print("not a user click")
            decisionHandler(.allow)
        }
    }

}

// Convert Html String to an nsattribute


extension NSAttributedString {
    
    convenience init(htmlString html: String, font: UIFont? = nil, useDocumentFontSize: Bool = true) throws {
        let options: [NSAttributedString.DocumentReadingOptionKey : Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        let data = html.data(using: .utf8, allowLossyConversion: true)
        guard (data != nil), let fontFamily = font?.familyName, let attr = try? NSMutableAttributedString(data: data!, options: options, documentAttributes: nil) else {
            try self.init(data: data ?? Data(html.utf8), options: options, documentAttributes: nil)
            return
        }
        
        let fontSize: CGFloat? = useDocumentFontSize ? nil : font!.pointSize
        let range = NSRange(location: 0, length: attr.length)
        attr.enumerateAttribute(.font, in: range, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
            if let htmlFont = attrib as? UIFont {
                let traits = htmlFont.fontDescriptor.symbolicTraits
                var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)
                
                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitBold)!
                }
                
                if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                    descrip = descrip.withSymbolicTraits(.traitItalic)!
                }
                
                attr.addAttribute(.font, value: UIFont(descriptor: descrip, size: fontSize ?? htmlFont.pointSize), range: range)
            }
        }
        
        self.init(attributedString: attr)
    }
    
}
