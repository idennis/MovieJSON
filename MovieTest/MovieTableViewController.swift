//
//  MovieTableViewController.swift
//  
//
//  Created by Dennis Hou on 4/05/2016.
//
//

import UIKit
import Alamofire
import SwiftyJSON
import Haneke

class MovieTableViewController: UITableViewController {

    // MARK: Properties
    let APIKEY = "7c83103e95bac8cf6bc8d26c40c3df08"
    
    // Array of Dictionary
    var movieDictionaryArray:[[String:AnyObject]] = []
    var pageNo:Int = 1
    
    // Movie array for caching
    var movies = Model.sharedInstance.movies
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var loadingMoreData:Bool = false
    var refreshPage:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        spinner.startAnimating()
        
        loadMovies()

        
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.refreshPage = movieDictionaryArray.count
        return movieDictionaryArray.count
    }

    
    // MARK: - Load via Alamo & SwiftyJSON
    func loadMovies(){
        
        
        Alamofire.request(.GET, "https://api.themoviedb.org/3/movie/popular?page="+String(self.pageNo)+"&api_key="+APIKEY).progress({ (bytesRead, totalBytesRead, totalBytesExpectedToRead) in
            
            self.spinner.startAnimating()
            self.loadingMoreData = false
            
        }).responseJSON { (responseData) -> Void in
            
            if((responseData.result.value) != nil) {
                
                self.spinner.stopAnimating()
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                
                if let data = swiftyJsonVar["results"].arrayObject{
                    
                    self.movieDictionaryArray += data as! [[String:AnyObject]]
                }
                
                
                
                if self.movieDictionaryArray.count > 0{
                    self.tableView.reloadData()
                    
//                    let newIndexPath = NSIndexPath(forRow: self.movieDictionaryArray.count, inSection: 0)
//                    self.tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Left)

                }
                
                
                
            }
                
            else if ((responseData.result.value) == nil){
                let alert = UIAlertController(title: "Uh oh", message: "We couldn't connect to the server, try switching on Wi-Fi or cellular data and restart the app.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    func loadContentForCell(cell: MovieTableViewCell, indexPath: NSIndexPath){
        var dict = movieDictionaryArray[indexPath.row]
        
        
            cell.movieTitleLabel?.text = dict["original_title"] as? String
            
            let dateFromJSON = dict["release_date"] as? String
            
            let NSDateValue = convertDateToNSDate(dateFromJSON!)
            let formattedDate = convertNSDateToString(NSDateValue!)
            
            cell.movieYearLabel?.text? = "RELEASED " + (formattedDate?.uppercaseString)!
            
            let cellMovieRating = dict["vote_average"] as? Double
            cell.movieRatingLabel?.text = String(format: "%.2g",(cellMovieRating)!)
            
            let baseURL = "http://image.tmdb.org/t/p/w500/"
            let picURL = dict["backdrop_path"] as? String
            let fullPath = baseURL + picURL!
            let url = NSURL(string: fullPath)
            let data = NSData(contentsOfURL: url!)
            
            if data != nil{
            //    cell.movieCoverPhoto.hnk_setImageFromURL(url!)
//                cell.movieCoverPhoto?.image = UIImage(data: data!)
            }
            cell.layoutMargins = UIEdgeInsetsZero
            setRatingColor(cell, rating: cellMovieRating!)
        
    }
    
    
    // MARK : - Loading Table View
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        if !loadingMoreData && indexPath.row == refreshPage - 1{
            loadingMoreData = true
            self.pageNo += 1
            loadMovies()
        }

        if let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as? MovieTableViewCell{
            loadContentForCell(cell, indexPath: indexPath)
            return cell
        }
        
        return MovieTableViewCell()
    }
    
    
    
    
    // MARK: - Navigation


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowDetail" {
            let movieDetailViewController = segue.destinationViewController as! MovieDetailViewController
            
            if let selectedMovieCell = sender as? MovieTableViewCell{
                let indexPath = tableView.indexPathForCell(selectedMovieCell)!
                let selectedMovie = movieDictionaryArray[indexPath.row]
                movieDetailViewController.selectedMovie = selectedMovie
            }
        }
        
    }
 
    
    
    
    // MARK: Time Formatter
    func convertDateToNSDate(dateString:String)->NSDate?{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let s = dateFormatter.dateFromString(dateString)
        
        return s
    }
    
    func convertNSDateToString(s:NSDate)->String?{
        //CONVERT FROM NSDate to String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        let dateString = dateFormatter.stringFromDate(s)
        
        return dateString
    }
    
    
    // MARK: Rating Indicator
    func setRatingColor(cell:MovieTableViewCell,rating:Double){
        
        if (rating < 5){
            cell.movieRatingLabel.layer.backgroundColor = UIColor.redColor().CGColor
        }
        else if (rating < 7){
            cell.movieRatingLabel.layer.backgroundColor = UIColor(red: 0.97, green: 0.57, blue: 0.20, alpha: 1.00).CGColor
        }
        else if (rating > 6){
            cell.movieRatingLabel.layer.backgroundColor = UIColor(red:0.45,green:0.70,blue:0.26,alpha:1.00).CGColor
        }
        cell.movieRatingLabel.layer.cornerRadius = 5
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}
