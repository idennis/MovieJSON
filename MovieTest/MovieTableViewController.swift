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

class MovieTableViewController: UITableViewController {

    // MARK: Properties
    let APIKEY = "7c83103e95bac8cf6bc8d26c40c3df08"
    
    // Array of Dictionary
    var movieDictionaryArray:[[String:AnyObject]] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        Alamofire.request(.GET, "https://api.themoviedb.org/3/movie/popular?api_key="+APIKEY).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                print(swiftyJsonVar)
                
                if let data = swiftyJsonVar["results"].arrayObject{
                    self.movieDictionaryArray = data as! [[String:AnyObject]]
                }
                if self.movieDictionaryArray.count > 0{
                    self.tableView.reloadData()
                }
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (movieDictionaryArray.count)
        return movieDictionaryArray.count
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
                cell.movieCoverPhoto?.image = UIImage(data: data!)
            }
            cell.layoutMargins = UIEdgeInsetsZero
            setRatingColor(cell, rating: cellMovieRating!)
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as? MovieTableViewCell{
            
            loadContentForCell(cell, indexPath: indexPath)
            return cell
        }
        
        print (MovieTableViewCell())
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
