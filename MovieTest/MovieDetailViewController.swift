//
//  MovieDetailViewController.swift
//  MovieTest
//
//  Created by Dennis Hou on 5/05/2016.
//  Copyright © 2016 dennis hou. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MovieDetailViewController: UIViewController {

    let APIKEY = "7c83103e95bac8cf6bc8d26c40c3df08"
    
    
    // MARK: Properties
    @IBOutlet weak var selectedMovieCoverPhoto: UIImageView!
    @IBOutlet weak var selectedMoviePoster: UIImageView!
    
    @IBOutlet weak var selectedMovieTitle: UILabel!
    @IBOutlet weak var selectedMovieDate: UILabel!
    @IBOutlet weak var selectedMovieDesc: UILabel!
    
    @IBOutlet weak var showMoreButton: UIButton!
    var selectedMovieOverview:String = ""
    var showMore:Bool = false
    var smallOverview:Bool = false
    
    var movieCast:[[String:AnyObject]] = []
    var movieCrew:[[String:AnyObject]] = []
    
    @IBOutlet weak var movieDirector: UILabel!
    
    
    @IBOutlet weak var selectedMovieGenre: UILabel!
    var selectedMovie:[String:AnyObject]?
    var fullGenreDict:[[String:AnyObject]]?
    var movieGenreDict:[Int]?
    
    
    // MARK: On Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stylePoster()
        
        if let movie = selectedMovie{
            self.selectedMovie = movie
            
            
            selectedMovieTitle.text? = (movie["title"] as? String)!
            
            let movieId:String = String(movie["id"]!)
            getCastCrew(movieId)
            
            setReleaseDate((movie["release_date"] as? String)!)
            
            
            selectedMovieOverview = (movie["overview"] as? String)!
            loadDescription(selectedMovieOverview)
            
            getDirector()
            getCoverPhoto()
            
            //fullGenreDict = retrieveGenreNames()
            //movieGenreDict = movie["genre_ids"] as? [Int]
            
            //selectedMovieGenre.text? = (movie["genres"] as? String)!
            //matchGenres(fullGenreDict, selectedMovieGenres: movieGenreDict)
            
            
            
        }
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }

    
    
    // MARK: - Cast and Crew
    func getCastCrew(movieID:String){
        let reqString = "https://api.themoviedb.org/3/movie/"+movieID+"/credits?api_key="+self.APIKEY
        Alamofire.request(.GET, reqString).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                if let castData = swiftyJsonVar["cast"].arrayObject{
                    self.movieCast = castData as! [[String:AnyObject]]
                    
                }
                
                if let data = swiftyJsonVar["crew"].arrayObject{
                    self.movieCrew = data as! [[String:AnyObject]]
                    //print(self.movieCrew)
                }
            }
                
            else if ((responseData.result.value) == nil){
                let alert = UIAlertController(title: "Uh oh", message: "We couldn't connect to the server, try switching on Wi-Fi or cellular data and restart the app.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    // Get Director
    func getDirector(){
        
        print("SEPARATOR\n\n\n\n\n\n\n")
        let dict = self.movieCrew
        print(dict)
    }
    
    
    
    // MARK: - Styles
    // Image
    func stylePoster(){
        selectedMoviePoster.layer.shadowColor = UIColor.blackColor().CGColor
        selectedMoviePoster.layer.shadowOpacity = 1.0
        selectedMoviePoster.layer.shadowRadius = 5.0
    }
    
    // Cover photo
    func getCoverPhoto(){
        // Cover Photo
        let baseURL = "http://image.tmdb.org/t/p/w500/"
        var picURL = self.selectedMovie!["backdrop_path"] as? String
        var fullPath = baseURL + picURL!
        
        var url = NSURL(string: fullPath)
        let coverPhotoData = NSData(contentsOfURL: url!)
        
        if coverPhotoData != nil{
            selectedMovieCoverPhoto?.image = UIImage(data: coverPhotoData!)
        }
        
        // Poster
        picURL = self.selectedMovie!["poster_path"] as? String
        fullPath = baseURL + picURL!
        
        url = NSURL(string: fullPath)
        let posterPhotoData = NSData(contentsOfURL: url!)
        
        if posterPhotoData != nil{
            selectedMoviePoster?.image = UIImage(data: posterPhotoData!)
            selectedMoviePoster.layer.borderColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.3).CGColor
            selectedMoviePoster.layer.borderWidth = 0.4
        }

    }
    
    // Date
    func setReleaseDate(releaseDate:String){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let dateValue = dateFormatter.dateFromString(releaseDate)
        
        let properFormatter = NSDateFormatter()
        properFormatter.dateFormat = "dd MMMM, YYYY"
        let dateString = properFormatter.stringFromDate(dateValue!)
        
        let formattedDate:String = "Released "+(dateString)
        
        selectedMovieDate.text = formattedDate
    }
    
    
    // MARK: - Show More and Description
    func loadDescription(overview:String){
        self.selectedMovieDesc.text? = overview
        self.selectedMovieDesc?.numberOfLines = 4
        self.selectedMovieDesc?.lineBreakMode = .ByTruncatingTail
        self.selectedMovieDesc?.sizeToFit()
        
        if (countDescLines(self.selectedMovieDesc) <= 3){
            self.showMore = false
            self.smallOverview = true
            showMoreButton.setTitle("", forState: UIControlState.Normal)
        }
    }
    
    @IBAction func showMoreTapped(sender: AnyObject) {
        
        if (self.showMore == false && self.smallOverview == false){
            print("in first")
            self.selectedMovieDesc?.numberOfLines = 0
            self.selectedMovieDesc?.sizeToFit()
            showMoreButton.setTitle("SHOW LESS", forState: UIControlState.Normal)
            self.showMore = true
        }
        
        
        else{
            print("in second")
            self.selectedMovieDesc?.numberOfLines = 4
            self.selectedMovieDesc?.lineBreakMode = .ByTruncatingTail
            self.selectedMovieDesc?.sizeToFit()
            showMoreButton.setTitle("SHOW MORE", forState: UIControlState.Normal)
            self.showMore = false
        }
    }
    
    
    func countDescLines(label:UILabel)->Int{
        if let text = label.text{
            // cast text to NSString so we can use sizeWithAttributes
            let myText = text as NSString
            
            //Set attributes
            let attributes = [NSFontAttributeName : UIFont.systemFontOfSize(UIFont.systemFontSize())]
            print(attributes)
            //Calculate the size of your UILabel by using the systemfont and the paragraph we created before. Edit the font and replace it with yours if you use another
            let labelSize = myText.boundingRectWithSize(CGSizeMake(label.bounds.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
            
            //Now we return the amount of lines using the ceil method
            let lines = ceil(CGFloat(labelSize.height) / label.font.lineHeight)
            print(Int(lines))
            return Int(lines)
        }
        
        return 0
    }

    
    // MARK : - Genre
    // Genre
    func retrieveGenreNames()->[[String:AnyObject]]?{
        
        var genreNameDictionary:[[String:AnyObject]] = []
        
        Alamofire.request(.GET, "https://api.themoviedb.org/3/genre/list?api_key="+APIKEY).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                
                let swiftyJsonVar = JSON(responseData.result.value!)
                if let data = swiftyJsonVar["results"].arrayObject{
                    genreNameDictionary = data as! [[String:AnyObject]]
                }

            }
            
        }
        return genreNameDictionary
    }
    
    
    
    func matchGenres(fullGenres:[[String:AnyObject]]?, selectedMovieGenres:[Int]?){
        
//        for (id, name) in fullGenres{
//            for selMovieGenre in selectedMovieGenres!{
//                if (key, value) == selMovieGenre{
//                    print(valueForKey(key))
//                }
//            }
//        }
//        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
