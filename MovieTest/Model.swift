//
//  Model.swift
//  MovieTest
//
//  Created by Dennis Hou on 7/05/2016.
//  Copyright © 2016 dennis hou. All rights reserved.
//

import Foundation


class Model{
    var movies:[Movie]
    var APIKEY:String = "7c83103e95bac8cf6bc8d26c40c3df08"
    private struct Static{
        static var instance:Model?
        
    }
    
    
    class var sharedInstance: Model
    {
        // If no instance of model, instantiate new instance
        if !(Static.instance != nil)
        {
            Static.instance = Model()
        }
        return Static.instance!
    }

    
    private init()
    {
        movies = [Movie]()
    }
    

}