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
            
            print(movie)
            selectedMovieTitle.text? = (movie["title"] as? String)!
            setReleaseDate((movie["release_date"] as? String)!)
            
            selectedMovieDesc.text? = (movie["overview"] as? String)!
            
            getCoverPhoto()
            fullGenreDict = retrieveGenreNames()
            movieGenreDict = movie["genre_ids"] as? [Int]
            
            
            //selectedMovieGenre.text? = (movie["genres"] as? String)!
            
            matchGenres(fullGenreDict, selectedMovieGenres: movieGenreDict)
            
            
            
        }
        
        
        
        
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
        
        let formattedDate:String = "RELEASED "+(dateString.uppercaseString)
        
        selectedMovieDate.text = formattedDate
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
