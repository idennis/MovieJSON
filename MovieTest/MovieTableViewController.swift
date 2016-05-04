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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        

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
        // #warning Incomplete implementation, return the number of rows
        return movieDictionaryArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieTableViewCell
        var dict = movieDictionaryArray[indexPath.row]
        cell.movieTitleLabel?.text = dict["original_title"] as? String
        cell.movieYearLabel?.text = dict["release_date"] as? String
        
        let baseURL = "http://image.tmdb.org/t/p/w500/"
        let picURL = dict["backdrop_path"] as? String
        let fullPath = baseURL + picURL!
        print(fullPath)
        let url = NSURL(string: fullPath)
        let data = NSData(contentsOfURL: url!)
        
        if data != nil{
            cell.movieCoverPhoto?.image = UIImage(data: data!)
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
