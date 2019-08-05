//
//  ViewController.swift
//  WeatherMood
//
//  Created by Jonathan Kopp on 8/4/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   
    var greetingLabel = UILabel()
    var greetinglabelView = UIView()
    var feelinglabelView = UIView()
    var feelingLabel = UILabel()
    var menuView = UIView()
    var menuHeight = CGFloat()
    var timer = Timer()
    var swipeButton = UIButton()
    var upDownAlpha = Bool()
    var slider = CustomSlider()
    var currentMood = String()
    var b = UIButton()//Ready button!
    var backgroundImage = UIImageView()
    var weatherNetwork = WeatherNetwork()
    var currWeather: City?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up greeting labels, Button and UISlider
        view.backgroundColor = #colorLiteral(red: 0.4196078431, green: 0.3764705882, blue: 1, alpha: 1)
        backgroundImage.image = #imageLiteral(resourceName: "DSC100373704")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.alpha = 0.4
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        
        greetinglabelView.backgroundColor = .clear
        greetinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height + 60, width: self.view.bounds.width, height: 60)
        greetingLabel.frame = CGRect(x: 10, y: 0, width: self.greetinglabelView.bounds.width - 20, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "Arial-BoldMT", size: 40)
        greetingLabel.numberOfLines = 1
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        greetingLabel.text = "How are you feeling today?"
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.greetinglabelView.addSubview(greetingLabel)
        self.view.addSubview(greetinglabelView)
        
        feelinglabelView.backgroundColor = .clear
        feelinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height + 260, width: self.view.bounds.width, height: 200)
        feelingLabel.frame = CGRect(x: 10, y: 90, width: self.feelinglabelView.bounds.width - 20, height: 50)
        feelingLabel.textAlignment = .center
        feelingLabel.text = "I feel happy!"
        feelingLabel.shadowColor = .black
        feelingLabel.shadowOffset = CGSize(width: -2, height: 2)
        currentMood = "Happy"
        feelingLabel.numberOfLines = 1
        feelingLabel.font = UIFont(name: "Arial-BoldMT", size: 30)
        feelingLabel.adjustsFontSizeToFitWidth = true
        feelingLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        slider = CustomSlider(frame:CGRect(x: 20, y: 40, width: self.view.bounds.width - 40, height: 50))
        if(slider.frame.width >= 700)
        {
            slider.frame = CGRect(x: 100, y: 40, width: self.view.bounds.width - 200, height: 50)
        }
        slider.trackWidth = 10
        slider.minimumValue = 0
        slider.maximumValue = 9
        slider.isContinuous = true
        slider.tintColor = UIColor.white
        slider.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        slider.layer.shadowOffset = CGSize(width: -2, height: 2)
        slider.setThumbImage(#imageLiteral(resourceName: "Emoji_Icon_-_Happy_70x70").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
        slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        
        b = UIButton()
        b.frame = CGRect(x: self.view.bounds.width / 2  - 75, y: 160, width: 150, height: 40.0)
        b.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b.setTitle("Submit", for: .normal)
        b.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 2
        b.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b.addTarget(self, action:#selector(self.moodPressed(_:)), for: .touchUpInside)
        feelinglabelView.alpha = 0.0
        self.feelinglabelView.addSubview(b)
        
        self.feelinglabelView.addSubview(slider)
        self.feelinglabelView.addSubview(feelingLabel)
        self.view.addSubview(feelinglabelView)
        
        menuHeight = 65//self.view.bounds.height * 0.1
        menuView.frame = CGRect(x: 0, y: self.view.bounds.height - menuHeight, width: self.view.bounds.width, height: menuHeight)
        menuView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5)
        //menuView.layer.cornerRadius = 10
        self.view.addSubview(menuView)
        //Animate the menu
        menuView.alpha = 1.0
        setUpMenu()
        moveLabels()
        
        //Start the network task.
        weatherNetwork.getWeather()
        //Subscribe to the notification once data has been fetched
        NotificationCenter.default.addObserver(self, selector: #selector(fetchedWeather), name: NSNotification.Name(rawValue: "fetchedCity"), object: nil)
    }
    
    //Activates once the weather gets fetched.
    //Starts to draw icons based on the weather
    @objc func fetchedWeather(){
        if let weather = weatherNetwork.city{
            print(weather)
            drawWeather(weather: weather)
            currWeather = weather
        }
    }
    
    //Draws the weather topbar
    func drawWeather(weather: City)
    {

        let icon = UIImageView()
        icon.frame = CGRect(x: self.view.bounds.width / 2 - 37.5, y: 50, width: 75, height: 75)
        
        if(weather.weather[0].main == "Clear")
        {
            icon.image = #imageLiteral(resourceName: "icons8-sun-64")
        }else{
            icon.image = #imageLiteral(resourceName: "icons8-partly-cloudy-day-100")
        }
        self.view.addSubview(icon)
        let labe = UILabel()
        
        labe.backgroundColor = .clear
        labe.frame = CGRect(x: 0, y: icon.frame.maxY + 5, width: self.view.bounds.width, height: 20)
        labe.textAlignment = .center
        labe.font = UIFont(name: "Arial-BoldMT", size: 20)
        labe.numberOfLines = 1
        labe.adjustsFontSizeToFitWidth = true
        labe.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let degrees = Int(weather.main.temp)
        labe.text = "\(degrees)\u{2109} with \(weather.weather[0].description)."
        labe.shadowColor = .black
        labe.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(labe)
    }
    
    //Set-up the UISlider with its values
    @objc func sliderValueDidChange(_ sender: UISlider!)
    {
        let theValue = (sender.value)
        if(theValue < 1)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Emoji_Icon_-_Happy_70x70").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel happy!"
            currentMood = "Happy"
        }else if(theValue < 2)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Emoji_Icon_-_unamused_face_70x70").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel bored."
            currentMood = "Bored"
        }else if(theValue < 3)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Dizzy_Emoji_Icon_ac9b8e32-707e-4cae-9ea7-5ad1c136e2d9_70x70").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel frustrated."
            currentMood = "Frustrated"
        }else if(theValue < 4)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Super_Angry_Face_Emoji_ios10_70x70").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel angry."
            currentMood = "Angry"
        }else if(theValue < 5)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "stressed").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel lonely."
            currentMood = "Lonely"
        }else if(theValue < 6)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "deprressedorsad").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel stressed."
            currentMood = "Stressed"
        }else if(theValue < 7)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "anxious").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel anxious."
            currentMood = "Anxious"
        }else if(theValue < 8)
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Crying_Emoji_Icon_2_70x70").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel sad."
            currentMood = "Sad"
        }
        else
        {
            slider.setThumbImage(#imageLiteral(resourceName: "Crying_Emoji_Icon_2_70x70").resizeImage(targetSize: CGSize(width: 50, height: 50)), for: .normal)
            feelingLabel.text = "I feel depressed..."
            currentMood = "Depressed"
        }
        
    }
    
    //Animate the greeting labels
    func moveLabels()
    {
        UIView.animate(withDuration: 1.0, animations: {
            self.greetinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height / 4, width: self.view.bounds.width, height: 60)
            
        }, completion: { (finished: Bool) in
            UIView.animate(withDuration: 1.0, animations: {
                self.feelinglabelView.alpha = 1
                self.feelinglabelView.frame = CGRect(x: 0, y: self.view.bounds.height / 4 + 60, width: self.view.bounds.width, height: 200)
                
            })
        })
    }
    
    //Sets up the menu subview and adds it to superview.
    func setUpMenu()
    {
        let startX = self.menuView.bounds.width / 2 - 25
        
        let moodTrackerButton = UIButton()
        moodTrackerButton.frame = CGRect(x: startX , y: 0, width: 50, height: 50)
        moodTrackerButton.setImage(#imageLiteral(resourceName: "icons8-chart-64"), for: .normal)
        moodTrackerButton.addTarget(self, action: #selector(moodTrackerPressed), for: .touchUpInside)
        menuView.addSubview(moodTrackerButton)
        

    }
    
    //Goes to the visual graph of moods
        //Type controls what the current weather is like.
    @objc func moodTrackerPressed()
    {
        if let weather = currWeather{
            var type = "1"//Cloudy
            if weather.weather[0].main == "Clear"
            {
                type = "2"//Sunny
            }
            let vc = MoodTrackerVC()
            let animation = CATransition()
            vc.type = type
            animation.type = .fade
            animation.subtype = .fromTop
            animation.duration = 0.6
            self.view.window!.layer.add(animation, forKey: nil)
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //Adds the mood to the userDefaults and then presents the mood graphs.
    @objc func moodPressed(_ sender: UIButton)
    {
        if let weather = currWeather{
        var type = "1"//Cloudy
        if weather.weather[0].main == "Clear"
        {
            type = "2"//Sunny
        }
        let moodStrings = ["Happy\(type)","Bored\(type)","Frustrated\(type)","Angry\(type)","Lonely\(type)","Stressed\(type)","Anxious\(type)","Sad\(type)","Depressed\(type)"]
        let userDefaults = Foundation.UserDefaults.standard
        var ctr = 0
        while(ctr < moodStrings.count)
        {
            if("\(currentMood)\(type)" == moodStrings[ctr])
            {
                //print(moodStrings[ctr])
                let moodDict = (userDefaults.dictionary(forKey: moodStrings[ctr]) ?? [String : Int]())
                if(moodDict.isEmpty)
                {
                    let newDict = [moodStrings[ctr] : 1] as [String : Any]
                    userDefaults.set(newDict, forKey: moodStrings[ctr])
                }else{
                    for (_,value) in moodDict
                    {
                        let newValue = value as? Int
                        let newDict = [moodStrings[ctr] : newValue! + 1] as [String : Any]
                        userDefaults.set(newDict, forKey: moodStrings[ctr])
                    }
                }
                ctr = moodStrings.count
            }
            ctr += 1
        }
        let vc = MoodTrackerVC()
        let animation = CATransition()
        vc.type = type
        animation.type = .fade
        animation.subtype = .fromTop
        animation.duration = 0.6
        self.view.window!.layer.add(animation, forKey: nil)
        self.present(vc, animated: false, completion: nil)
        
        }
    }
}


open class CustomSlider : UISlider {
    @IBInspectable open var trackWidth:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
}

