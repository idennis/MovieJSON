//
//  MovieDetailViewController.swift
//  MovieTest
//
//  Created by Dennis Hou on 5/05/2016.
//  Copyright © 2016 dennis hou. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    
    // MARK: Properties
    @IBOutlet weak var selectedMovieCoverPhoto: UIImageView!
    @IBOutlet weak var selectedMoviePoster: UIImageView!
    
    @IBOutlet weak var selectedMovieTitle: UILabel!
    @IBOutlet weak var selectedMovieDate: UILabel!
    @IBOutlet weak var selectedMovieDesc: UILabel!
    
    var selectedMovie:[String:AnyObject]?
    
    
    // MARK: On Load
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedMoviePoster.layer.shadowColor = UIColor.blackColor().CGColor
        selectedMoviePoster.layer.shadowOpacity = 1.0
        selectedMoviePoster.layer.shadowRadius = 5.0
        
        if let movie = selectedMovie{
            print(movie)
            selectedMovieTitle.text? = (movie["title"] as? String)!
            selectedMovieDate.text? = (movie["release_date"] as? String)!
            selectedMovieDesc.text? = (movie["overview"] as? String)!
            
            
            // Cover Photo
            let baseURL = "http://image.tmdb.org/t/p/w500/"
            var picURL = movie["backdrop_path"] as? String
            var fullPath = baseURL + picURL!
            
            var url = NSURL(string: fullPath)
            let coverPhotoData = NSData(contentsOfURL: url!)
            
            if coverPhotoData != nil{
                selectedMovieCoverPhoto?.image = UIImage(data: coverPhotoData!)
            }
            
            // Poster
            picURL = movie["poster_path"] as? String
            fullPath = baseURL + picURL!
            
            url = NSURL(string: fullPath)
            let posterPhotoData = NSData(contentsOfURL: url!)
            
            if posterPhotoData != nil{
                selectedMoviePoster?.image = UIImage(data: posterPhotoData!)
            }

        }
        
        
        
        
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
