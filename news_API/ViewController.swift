//
//  ViewController.swift
//  news_API
//
//  Created by Cenk Bahadır Çark on 4.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var gelenNews = [News]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        getAllNews()
        
    }
    
    func getAllNews() {
        
        let url = URL(string: "https://api.currentsapi.services/v1/latest-news?apiKey=obc5wxVw27oQMMx3NFspff7lQgcTNBIZKmiFoXDB052JNE7I")!
        
        URLSession.shared.dataTask(with: url){data, response, error in
            if error != nil || data == nil {
                print("error")
            }
            
            do{
                let cevap = try JSONDecoder().decode(NewsResponse.self, from: data!)
                if let gelenHaberler = cevap.news {
                    self.gelenNews = gelenHaberler
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                     
            }catch{
                print(String(describing: error))
            }
        }.resume()
  
    }
    
    


}
extension ViewController: UITableViewDelegate,UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gelenNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let new = gelenNews[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.authorLabel.text = "By: \(new.author!)"
        cell.categoryLabel.text = new.category?.description
        cell.descriptonLabel.text = new.newsDescription
        cell.titleLabel.text = new.title
        cell.publishedLabel.text = new.published
        
        if let url = URL(string: new.image!) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                if data == nil {
                    //Default image for non-image news
                   let url = URL(string: "https://www.creativefabrica.com/wp-content/uploads/2018/12/Breaking-News-Vector-Illustration-by-indostudio-580x386.jpg")!
                    DispatchQueue.main.async {
                        let defaultData = try? Data(contentsOf: url)
                        cell.newsImageView.image = UIImage(data: defaultData!)
                    }
                }else{
                    DispatchQueue.main.async {
                        cell.newsImageView.image = UIImage(data: data!)
                    }
                }
                
                
            }
        }
        cell.newsImageView.image = UIImage(named: new.image!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urls = gelenNews[indexPath.row]
        
        if let url = URL(string: urls.url!) {
            UIApplication.shared.open(url)
        }
    }
}
