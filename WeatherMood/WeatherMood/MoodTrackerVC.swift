//
//  MoodTrackerVC.swift
//  WeatherMood
//
//  Created by Jonathan Kopp on 8/4/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import Charts

class MoodTrackerVC: UIViewController{
    var backgroundImage = UIImageView()
    var pieChart = PieChartView()
    var moods = moodChart()
    var moodValues = [Int]()
    var theMoods = [String]()
    var greetingLabel = UILabel()
    var resetTrakerButton = UIButton()
    var resetView = UIView()
    var type = String()//Either 1 = Overcast 2 = Sunny
    var b1 = UIButton()//Overcast Button
    var b2 = UIButton()//Sunny Button
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up top view
        backgroundImage.image = #imageLiteral(resourceName: "DSC100373704")
        backgroundImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.alpha = 0.3
        self.view.addSubview(backgroundImage)
        
        greetingLabel.frame = CGRect(x: 45, y: 25, width: self.view.bounds.width - 90, height: 50)
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 30)
        greetingLabel.adjustsFontSizeToFitWidth = true
        greetingLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if(type == "1")
        {
             greetingLabel.text = "Overcast Moods"
        }else{
            greetingLabel.text = "Sunny Moods"
        }
        greetingLabel.shadowColor = .black
        greetingLabel.shadowOffset = CGSize(width: -2, height: 2)
        self.view.addSubview(greetingLabel)
        
        //Swipe gesture to dismiss
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(self.swipeRight(_:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        //Start to fill the PieChart
        getTheMoodValues()
        setUpPieChart()
        
        let backButton = UIButton()
        backButton.frame = CGRect(x: 5, y: greetingLabel.frame.minY + 12.5, width: 25, height: 25)
        backButton.setImage(#imageLiteral(resourceName: "icons8-chevron-left-50").mask(with: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), for: .normal)
        backButton.alpha = 1.0
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        //Reset button which will trigger the reset of the graph
        resetTrakerButton.frame = CGRect(x: self.view.bounds.width / 2  - 100, y: pieChart.frame.maxY + 20, width: 200, height: 40.0)
        resetTrakerButton.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        resetTrakerButton.setTitle("Reset", for: .normal)
        resetTrakerButton.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        resetTrakerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resetTrakerButton.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        resetTrakerButton.layer.cornerRadius = 20
        resetTrakerButton.layer.borderWidth = 2
        resetTrakerButton.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        resetTrakerButton.addTarget(self, action:#selector(self.resetPressed), for: .touchUpInside)
        
        if(!moodValues.isEmpty)
        {
            self.view.addSubview(resetTrakerButton)
        }
        //Overcast Button
        b1.frame = CGRect(x: 0, y: greetingLabel.frame.maxY + 5, width: view.bounds.width / 2, height: 40.0)
        b1.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b1.setTitle("Overcast", for: .normal)
        b1.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b1.titleLabel?.adjustsFontSizeToFitWidth = true
        b1.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b1.layer.cornerRadius = 20
        b1.layer.borderWidth = 2
        b1.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b1.addTarget(self, action:#selector(self.b1Pressed), for: .touchUpInside)
        view.addSubview(b1)
        
        //Sunny Button
        b2.frame = CGRect(x: view.bounds.width / 2, y: greetingLabel.frame.maxY + 5, width: view.bounds.width / 2, height: 40.0)
        b2.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b2.setTitle("Sunny", for: .normal)
        b2.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b2.titleLabel?.adjustsFontSizeToFitWidth = true
        b2.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b2.layer.cornerRadius = 20
        b2.layer.borderWidth = 2
        b2.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b2.addTarget(self, action:#selector(self.b2Pressed), for: .touchUpInside)
        view.addSubview(b2)
        if type == "1"{
            b1.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.2)
        }else{
            b2.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.2)
        }
    }
    
    @objc func b1Pressed()//Overcast Button Pressed
    {
        if(type != "1"){
            resetTheView(theType: "1")
            b2.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
            b1.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.2)}
    }
    @objc func b2Pressed()//Sunny Button Pressed
    {
        if(type != "2"){
        resetTheView(theType: "2")
        b2.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.2)
        b1.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        
        }
    }
    //When b1 or b2 gets activated
    func resetTheView(theType: String)
    {
        type = theType
        pieChart.removeFromSuperview()
        moods = moodChart()
        moodValues = [Int]()
        getTheMoodValues()
        setUpPieChart()
        if(type == "1")
        {
            greetingLabel.text = "Overcast Moods"
        }else{
            greetingLabel.text = "Sunny Moods"
        }
        view.bringSubviewToFront(b1)
        view.bringSubviewToFront(b2)
    }
    //Triggers the reset view
    @objc func resetPressed()
    {
        resetView.frame = CGRect(x: 0, y: b1.frame.maxY, width: self.view.bounds.width, height: 100)
        resetView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: self.view.bounds.width - 20, height: 60))
        label.numberOfLines = 2
        label.text = "Press reset to clear your \n Mood Tracker."
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .clear
        resetView.addSubview(label)
        let b = UIButton()
        b.frame = CGRect(x: self.view.bounds.width / 2  - 152.5, y: label.frame.maxY, width: 150, height: 40.0)
        b.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b.setTitle("Reset", for: .normal)
        b.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b.titleLabel?.adjustsFontSizeToFitWidth = true
        b.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b.layer.cornerRadius = 20
        b.layer.borderWidth = 2
        b.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b.addTarget(self, action:#selector(self.yesReset), for: .touchUpInside)
        self.resetView.addSubview(b)
        
        let b2 = UIButton()
        b2.frame = CGRect(x: self.view.bounds.width / 2 + 2.5, y: label.frame.maxY, width: 150, height: 40.0)
        b2.titleLabel!.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        b2.setTitle("Cancel", for: .normal)
        b2.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        b2.titleLabel?.adjustsFontSizeToFitWidth = true
        b2.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.2)
        b2.layer.cornerRadius = 20
        b2.layer.borderWidth = 2
        b2.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        b2.addTarget(self, action:#selector(self.noReset), for: .touchUpInside)
        self.resetView.addSubview(b2)
        self.view.addSubview(resetView)
        resetView.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.pieChart.frame = CGRect(x: 10, y: 180, width: self.view.bounds.width - 20, height: self.view.bounds.height / 1.5)
            self.resetTrakerButton.alpha = 0.0
            self.resetView.alpha = 1.0
        })
    }
    
    //When user agree's to reset
    @objc func yesReset()
    {
        
        resetView.removeFromSuperview()
        resetView = UIView()
        
        let moodStrings = ["Happy\(type)","Bored\(type)","Frustrated\(type)","Angry\(type)","Lonely\(type)","Stressed\(type)","Anxious\(type)","Sad\(type)","Depressed\(type)"]
        let userDefaults = Foundation.UserDefaults.standard
        var ctr = 0
        
        while(ctr < moodStrings.count)
        {
            userDefaults.set([moodStrings[ctr], 0], forKey: moodStrings[ctr])
            ctr += 1
        }
        
        pieChart.removeFromSuperview()
        noDataView()
    }
    
    //Remove reset view
    @objc func noReset()
    {
        
        resetView.removeFromSuperview()
        resetView = UIView()
        moveBack()
    }
    //Move the Piechart
    func moveBack()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.pieChart.frame = CGRect(x: 10, y: 80, width: self.view.bounds.width - 20, height: self.view.bounds.height / 1.5)
            self.resetTrakerButton.alpha = 1.0
        })
    }
    
    //Dissmiss vc
    @objc func backButtonPressed()
    {
        let animation = CATransition()
        animation.type = .fade
        animation.duration = 0.4
        animation.subtype = .fromLeft
        self.view.window!.layer.add(animation, forKey: nil)
        
        self.dismiss(animated: false, completion: nil)
    }
    
    //Sets up the piechart with the mood values.
    func setUpPieChart()
    {
        if(theMoods.count > 0)
        {
            pieChart.frame = CGRect(x: 10, y: 80, width: self.view.bounds.width - 20, height: self.view.bounds.height / 1.5)
            pieChart.holeColor = .clear
            pieChart.backgroundColor = .clear
            pieChart.chartDescription?.textColor = UIColor.white
            pieChart.legend.textColor = UIColor.white
            pieChart.legend.font = UIFont(name: "AvenirNext-DemiBold", size: 12)!
            pieChart.chartDescription?.font = UIFont(name: "AvenirNext-DemiBold", size: 40)!
            pieChart.chartDescription?.xOffset = pieChart.frame.width / 2
            pieChart.chartDescription?.yOffset = pieChart.frame.height - 120
            pieChart.chartDescription?.textAlign = .center
            
            //theMoods = ["Happy","Bored","Frustrated","Angry","Lonely","Sad"]
            var datasets = [PieChartDataEntry]()
            var colors = getColorSet()
            var ctr = 0
            while(ctr < moodValues.count)
            {
                var theTitle = theMoods[ctr]
                theTitle.removeLast(1)
                let data = PieChartDataEntry(value: Double(moodValues[ctr]), label: theTitle)
                datasets.append(data)
                colors[ctr] = colors[ctr].withAlphaComponent(0.8)
                ctr += 1
            }
            let dataSet = PieChartDataSet(entries: datasets, label: "")
            dataSet.colors = colors
            dataSet.sliceSpace = 4
            
            let pFormatter = NumberFormatter()
            pFormatter.numberStyle = .none
            pFormatter.maximumFractionDigits = 0
            let data = PieChartData(dataSet: dataSet)
            data.setValueFormatter((DefaultValueFormatter(formatter: pFormatter)))
            pieChart.data = data
            pieChart.chartDescription?.text = ""
            pieChart.usePercentValuesEnabled = false
            pieChart.drawSlicesUnderHoleEnabled = false
            pieChart.holeRadiusPercent = 0.58
            pieChart.transparentCircleRadiusPercent = 0.61
            pieChart.drawHoleEnabled = true
            let l = pieChart.legend
            l.horizontalAlignment = .center
            l.verticalAlignment = .bottom
            l.orientation = .horizontal
            l.drawInside = false
            l.xEntrySpace = 7
            l.yEntrySpace = 0
            l.yOffset = 0
            
            
            pieChart.notifyDataSetChanged()
            self.view.addSubview(pieChart)
        }else{
            noDataView()
        }
    }
    
    //If there are no values in the data set show that theyre are none
    func noDataView()
    {
        let label = UILabel(frame: CGRect(x: 10, y: greetingLabel.frame.maxY + 20, width: self.view.bounds.width - 20, height: 100))
        label.numberOfLines = 2
        label.text = "No mood data to load."
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.backgroundColor = .clear
        self.view.addSubview(label)
    }
    
    //Each mood has its own color set.
    func getColorSet() -> [UIColor]
    {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),#colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1),#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1),#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),#colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1),#colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1),#colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1),#colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)]
        var theColors = [UIColor]()
        for i in theMoods
        {
            //let i = t + type
            if(i == "Happy\(type)")
            {
                theColors.append(colors[0])
            }else if(i == "Bored\(type)")
            {
                theColors.append(colors[1])
            }else if(i == "Frustrated\(type)")
            {
                theColors.append(colors[2])
            }else if(i == "Angry\(type)")
            {
                theColors.append(colors[3])
            }else if(i == "Lonely\(type)")
            {
                theColors.append(colors[4])
            }else if(i == "Stressed\(type)")
            {
                theColors.append(colors[5])
            }else if(i == "Anxious\(type)")
            {
                theColors.append(colors[6])
            }else if(i == "Sad\(type)")
            {
                theColors.append(colors[7])
            }else if(i == "Depressed\(type)")
            {
                theColors.append(colors[8])
            }
        }
        return theColors
    }
    
    //Fetches the mood values from the user defaults
    func getTheMoodValues()
    {
        print(type)
        let moodStrings = ["Happy\(type)","Bored\(type)","Frustrated\(type)","Angry\(type)","Lonely\(type)","Stressed\(type)","Anxious\(type)","Sad\(type)","Depressed\(type)"]
        print(moodStrings)
        let userDefaults = Foundation.UserDefaults.standard
        var ctr = 0
        
        while(ctr < moodStrings.count)
        {
            let moodDict = (userDefaults.dictionary(forKey: moodStrings[ctr]) ?? [String : Int]())
            if(!moodDict.isEmpty)
            {
                for (key,value) in moodDict
                {
                    print(value)
                    let theValue = value as? Int
                    self.moodValues.append(theValue!)
                    self.theMoods.append(key)
                }
            }else{print("Empty")}
            ctr += 1
        }
    }
    
    //Dismiss VC
    @objc func swipeRight(_ sender: UISwipeGestureRecognizer){
        let location = (sender.location(in: pieChart))
        if(location.y >= pieChart.frame.maxY - 100)
        {
            let animation = CATransition()
            animation.type = .fade
            animation.duration = 0.4
            animation.subtype = .fromLeft
            self.view.window!.layer.add(animation, forKey: nil)
            
            self.dismiss(animated: false, completion: nil)
        }
    }
}

struct moodChart{
    var moodValues: [Int]?
    
}
