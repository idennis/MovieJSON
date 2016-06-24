//
//  MovieTableViewCell.swift
//  MovieTest
//
//  Created by Dennis Hou on 4/05/2016.
//  Copyright © 2016 dennis hou. All rights reserved.
//

import UIKit
import Haneke

class MovieTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieYearLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    
    @IBOutlet weak var movieCoverPhoto: UIImageView!

    var url:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

//    func setImage(url: String){
//        let imageURL = NSURL(string: url)
//
//    }
}
