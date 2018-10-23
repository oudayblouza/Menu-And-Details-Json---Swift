//
//  ViewController.swift
//  Ouday_Blouza_APP
//
//  Created by Ouday Blouza on 23/10/2018.
//  Copyright © 2018 Ouday Blouza. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITableViewDataSource ,UITableViewDelegate{

    
    @IBOutlet weak var tableNews: UITableView!
    
    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URLS.GETURL+"index.php?id=581"
        guard let JsonUrl = URL(string: url) else {return}
        // Calling a func to convert a JSON Response to data in TableView
        readAllJson( url: JsonUrl)
    }
    
    // Number of tableView rows by section equal to the arraylist lenght
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    // tableview cell height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    // fill UIelements with data from the arraylist
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let imgv:UIImageView = cell.viewWithTag(100) as! UIImageView
        let lblTitle:UILabel = cell.viewWithTag(101) as! UILabel
        let lblDescription:UILabel = cell.viewWithTag(102) as! UILabel
        let lblType:UILabel = cell.viewWithTag(103) as! UILabel
        let lblSubTitle:UILabel = cell.viewWithTag(104) as! UILabel
        lblTitle.text = news[indexPath.row].newsTitle
        lblDescription.text = news[indexPath.row].newsShortDesc
        lblType.text = news[indexPath.row].newsCat
        lblSubTitle.text = news[indexPath.row].newsSubTitle
        let imageUrlString = URLS.GETURL+news[indexPath.row].newsThumbImage!
        
        // change imageView shape to round
        imgv.layer.cornerRadius = 40;
        imgv.clipsToBounds = true;
        imgv.layer.borderWidth = 2.0;
        imgv.layer.borderColor = UIColor.black.cgColor
        
        imgv.downloadImage(from: imageUrlString)

        return cell
    }
    
    // cast json response to array of news object and reload the tableView
    fileprivate func readAllJson(url : URL) {
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil{
                print(error!)
            }
            guard let data = data else {return}
            do {
                self.news = try JSONDecoder().decode([News].self, from: data)
                for new in self.news {
                    //Force the reloadData to the main thread
                    DispatchQueue.main.async {
                        self.tableNews.reloadData()
                    }
                }
            }catch let jsonError{
                print("Error",jsonError)
            }
            }.resume()
        
    }
    //call the prepare segue when a cell is clicked
    var rowSelected : Int?
    var new : News?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowSelected = indexPath.row
        new = news[rowSelected!]
        performSegue(withIdentifier: "detailSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Get the destination  view controller in destVC.
        // Pass the selected object to the new view controller.
        if let destVC = segue.destination as? DetailNewsViewController {
            destVC.new = new 
        }
    }

}

//Extention to load the images in the cache to avoid memory loss
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        // set initial image to nil so it doesn't use the image from a reused cell
        image = nil
        
        // check if the image is already in the cache
        if let imageToCache = imageCache.object(forKey: imgURL! as NSString) {
            self.image = imageToCache
            return
        }
        
        // download the image asynchronously
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                // create UIImage
                let imageToCache = UIImage(data: data!)
                // add image to cache
                imageCache.setObject(imageToCache!, forKey: imgURL! as NSString)
                self.image = imageToCache
            }
        }
        task.resume()
    }
}
