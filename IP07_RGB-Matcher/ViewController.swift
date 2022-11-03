//
//  ViewController.swift
//  IP07_RGB-Matcher
//
//  Created by Rai, Rhea on 10/28/22.
// TODO: timer, others

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
    var goalBoxInfo = UILabel()
    var userBox = UILabel()
    var userBoxInfo = UILabel()
    
    //game info
    var gameInfo = UILabel()
    
    //sliders
    var redSlider = UISlider()
    var greenSlider = UISlider()
    var blueSlider = UISlider()
    
    var colorTagDictionary = Dictionary<UISlider, Int>()
    var tagColorDictionary = Dictionary<Int, UISlider>()
    
    //score
    var score = 0
    var maxScoreRecorded = 0
    var scoreDetails = UILabel()
    
    //color constants
    let RED_MAX = 1.0
    let GREEN_MAX = 1.0
    let BLUE_MAX = 1.0
    
    //color values (0 to 1.0)
    var userRed = 1.0
    var userGreen = 1.0
    var userBlue = 1.0
    
    var goalRed = 1.0
    var goalGreen = 1.0
    var goalBlue = 1.0
    
    //timer
    let TIME_MAX = 10.0 // seconds
    var currSecCount = 0.0 //sec
    var timerLbl = UILabel()
    var timer = Timer()
       
    
    
    
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
        setInfoLabels()
        
        //start game
        setNewGoalBoxColor()
        
        
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerRunner), userInfo: nil, repeats: true)
    }
    func resetGame() {
        scoreDetails.removeFromSuperview()
        
        currSecCount = 0.0
        timerLbl.text = "Time left: +\(String(TIME_MAX - Double(floor(100*currSecCount)/100))) sec"
        setSliders()
        setBoxes()
        setNewGoalBoxColor()
        
    }
    
    @objc func timerRunner() {
        if(timeIsLeft()) {
            timerLbl.text = "Time left: +\(String(TIME_MAX - Double(floor(100*currSecCount)/100))) sec"
            currSecCount+=0.1
        }
        else {
            endGame()
        }
        
    }
    
    func endGame() {
        
        self.timer.invalidate()
        
        self.view.addSubview(scoreDetails)
        
        self.redSlider.isEnabled = false
        self.greenSlider.isEnabled = false
        self.blueSlider.isEnabled = false
    }
    
    @objc func startNewGame(_sender:UIButton) {
        resetGame()
    }
    
    @objc func sliderValueChanged(_sender:UISlider) {
        //start timer if needed
        if currSecCount < 0.1 {
            startTimer()
        }
        
        //change the user box color
        userRed = Double(redSlider.value)
        userGreen = Double(greenSlider.value)
        userBlue = Double(blueSlider.value)
        userBox.backgroundColor = UIColor(red: CGFloat(userRed), green: CGFloat(userGreen), blue: CGFloat(userBlue), alpha: 1)
        updateScore()
    }
    
    func updateScore() {
        var diff = (1 - sqrt( pow(userRed-goalRed , 2) + pow(userBlue-goalBlue,2) + pow(userGreen-goalGreen,2)))
        self.score = Int(100 * diff)
        //testing:
        //print("score:\(score) | goal:\(goalRed),\(goalBlue), \(goalGreen) | my:\(userRed),\(userBlue), \(userGreen)")
        
    }
    
    
    func timeIsLeft() -> Bool {
        return self.currSecCount <= self.TIME_MAX
    }
    
    func setNewGoalBoxColor() {
        
        goalRed  = CGFloat.random(in: 0...RED_MAX)
        goalGreen = CGFloat.random(in: 0...GREEN_MAX)
        goalBlue = CGFloat.random(in: 0...BLUE_MAX)
        
        goalBox.backgroundColor = UIColor(red: goalRed, green: goalGreen, blue: goalBlue, alpha: 1)
        
        //UIColor(red: CGFloat.random(in: 0...RED_MAX), green: CGFloat.random(in: 0...GREEN_MAX), blue: CGFloat.random(in: 0...BLUE_MAX), alpha: 1)
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
        self.view.addSubview(goalBox)

    }
    fileprivate func setInfoLabels() {
        gameInfo.frame = CGRect(x: Int(self.userBox.frame.minX), y: Int(self.blueSlider.frame.maxY) + yBuffer/9, width: useableLength, height: 2*yBuffer/9)
        gameInfo.text = "Slide the RGB values to match the goal"
        self.view.addSubview(gameInfo)
        
        
        userBoxInfo.frame = CGRect(x: Int(self.userBox.frame.minX), y: Int(self.userBox.frame.maxY) + yBuffer/9, width: Int(userBox.frame.width), height: 2*yBuffer/9)
        userBoxInfo.text = "Your color"
        userBoxInfo.textAlignment = .center
        self.view.addSubview(userBoxInfo)
    
        
        goalBoxInfo.frame = CGRect(x: Int(self.goalBox.frame.minX), y: Int(self.goalBox.frame.maxY) + yBuffer/9, width: Int(userBox.frame.width), height: 2*yBuffer/9)
        goalBoxInfo.text = "Goal color"
        goalBoxInfo.textAlignment = .center
        self.view.addSubview(goalBoxInfo)
        
        timerLbl.frame = CGRect(x: xBuffer, y: yBuffer, width: useableLength, height: yBuffer)
        timerLbl.text = "Time left: +\(String(TIME_MAX - Double(floor(100*currSecCount)/100))) sec"
        timerLbl.textAlignment = .center
        self.view.addSubview(timerLbl)
        //print("got here")
    }
}

