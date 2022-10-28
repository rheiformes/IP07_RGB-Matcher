//
//  ViewController.swift
//  IP07_RGB-Matcher
//
//  Created by Rai, Rhea on 10/28/22.
//

import UIKit

class ViewController: UIViewController {

    //screen values
    var screenWidth: Int = 0
    var screenHeight: Int = 0
    var useableLength: Int = 0
    var xBuffer = 0
    
    var yBuffer = 0
    
    //color boxes
    var goalBox = UILabel()
    var userBox = UILabel()
    
    //sliders
    var redSlider = UISlider()
    var greenSlider = UISlider()
    var blueSlider = UISlider()
    var colorTagDictionary = Dictionary<UISlider, Int>()
    var tagColorDictionary = Dictionary<Int, UISlider>()
    
    //variables of rounds
    var roundNum = 0
    var currScore = 0
    var score = 0
    var maxScoreRecorded = 0
    
    //color constants
    let RED_MAX = 1.0
    let GREEN_MAX = 1.0
    let BLUE_MAX = 1.0
    
    //time constants
    let TIME_MAX = 10.0 // seconds
    var currSecCount = 0.0 //sec
    
    
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //set screen constants/buffers
        setScreenValues()
        
        //set UI elements
        colorTagDictionary = [redSlider: 0, greenSlider: 1, blueSlider: 2]
        tagColorDictionary = [0: redSlider, 1:greenSlider, 2:blueSlider]
        setBoxes()
        setSliders()
        
        //start game
        setNewGoalBoxColor()
        
        //TODO: add Timer, use time is left, add round functionalities
        
    }
    
    @objc func sliderValueChanged(_sender:UISlider) {
        //start timer if needed
        //stop time and disable sliders if needed
        
        //change the user box color
        userBox.backgroundColor = UIColor(red: CGFloat(redSlider.value), green: CGFloat(greenSlider.value), blue: CGFloat(blueSlider.value), alpha: 1)
        
    }
    
    func timeIsLeft() -> Bool {
        return self.currSecCount <= self.TIME_MAX
    }
    
    func setNewGoalBoxColor() {
        goalBox.backgroundColor = UIColor(red: CGFloat.random(in: 0...RED_MAX), green: CGFloat.random(in: 0...GREEN_MAX), blue: CGFloat.random(in: 0...BLUE_MAX), alpha: 1)
    }
    
    fileprivate func setSliders() {
        //set up sliders
        redSlider.frame = CGRect(x: self.xBuffer, y: Int(self.userBox.frame.maxY) + yBuffer, width: self.useableLength, height: yBuffer/2)
        redSlider.minimumValue = 0
        redSlider.maximumValue = Float(RED_MAX)
        redSlider.setValue(redSlider.maximumValue, animated: false)
        redSlider.tintColor = UIColor.red
        redSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        redSlider.tag = colorTagDictionary[redSlider]!
        self.view.addSubview(redSlider)
        
        greenSlider.frame = CGRect(x: self.xBuffer, y: Int(self.redSlider.frame.maxY), width: self.useableLength, height: yBuffer/2)
        greenSlider.minimumValue = 0
        greenSlider.maximumValue = Float(GREEN_MAX)
        greenSlider.setValue(greenSlider.maximumValue, animated: false)
        greenSlider.tintColor = UIColor.green
        greenSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        greenSlider.tag = colorTagDictionary[greenSlider]!
        self.view.addSubview(greenSlider)
        
        blueSlider.frame = CGRect(x: self.xBuffer, y: Int(self.greenSlider.frame.maxY), width: self.useableLength, height: yBuffer/2)
        blueSlider.minimumValue = 0
        blueSlider.maximumValue = Float(BLUE_MAX)
        blueSlider.setValue(blueSlider.maximumValue, animated: false)
        blueSlider.tintColor = UIColor.blue
        blueSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        blueSlider.tag = colorTagDictionary[blueSlider]!
        self.view.addSubview(blueSlider)
    }

    fileprivate func setScreenValues() {
        
        
        //set up default screen constants
        let screenBounds: CGRect = UIScreen.main.bounds
        self.screenWidth = Int(screenBounds.width)
        self.screenHeight = Int(screenBounds.height)
        self.xBuffer = screenWidth/10
        self.yBuffer = screenHeight/9
        self.useableLength = screenWidth - 2*xBuffer
    }
    fileprivate func setBoxes() {
        //set boxes
        let boxBuffer = useableLength/9
        
        self.userBox.frame = CGRect(x: self.xBuffer, y: 2*self.yBuffer, width: 4*boxBuffer, height: screenHeight/4)
        self.userBox.layer.borderColor = UIColor.black.cgColor
        self.userBox.layer.borderWidth = 3
        self.view.addSubview(userBox)
        
        self.goalBox.frame = CGRect(x: Int(self.userBox.frame.maxX) + boxBuffer, y: 2*self.yBuffer, width: 4*boxBuffer, height: Int(self.userBox.frame.height))
        self.goalBox.layer.borderColor = UIColor.black.cgColor
        self.goalBox.layer.borderWidth = 3
        self.view.addSubview(goalBox)
    }
    
}

