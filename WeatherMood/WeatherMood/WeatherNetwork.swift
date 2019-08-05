//
//  WeatherNetwork.swift
//  WeatherMood
//
//  Created by Jonathan Kopp on 8/4/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation

class WeatherNetwork
{
    var city: City?
    func getWeather() //-> City
    {
        let urlRequest = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/weather?zip=94102,us&APPID=6a15e9792b89cf8fbd33ade218a08b39&units=imperial")!)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            guard let data = data else {
                print("Contains No Data")
                return
            }
            DispatchQueue.main.async {
                let object = try! JSONDecoder().decode(City.self, from: data)
                self.city = object
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "fetchedCity"), object: nil)
            }
            
        }
        dataTask.resume()
    }
}

struct City: Codable {
    var main: MainObj
    var weather: [WeatherOBJ]
    
    enum CodingKeys: String, CodingKey {
        case main
        case weather
    }
}
struct WeatherOBJ: Codable{
    var main: String
    var description: String
    enum CodingKeys: String, CodingKey {
        case main
        case description
    }
}
struct MainObj: Codable {
    var temp: Float
    
    enum CodingKeys: String, CodingKey {
        case temp
    }
}
