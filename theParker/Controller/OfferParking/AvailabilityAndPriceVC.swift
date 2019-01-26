//
//  PriceAndTimeVC.swift
//  theParker
//
//  Created by Ketan Choyal on 27/12/18.
//  Copyright © 2018 Ketan Choyal. All rights reserved.
//

import UIKit

class AvailabilityAndPriceVC: UIViewController {

    @IBOutlet weak var hourlySwitch: UISwitch!
    @IBOutlet weak var hourlyPrice: InsetTextField!
    @IBOutlet weak var dailySwitch: UISwitch!
    @IBOutlet weak var dailyPrice: InsetTextField!
    @IBOutlet weak var weeklySwitch: UISwitch!
    @IBOutlet weak var weeklyPrice: InsetTextField!
    @IBOutlet weak var monthlySwitch: UISwitch!
    @IBOutlet weak var monthlyPrice: InsetTextField!
    @IBOutlet weak var availabilitySegment: UISegmentedControl!
    @IBOutlet weak var finishButton: UIButton!
    
    var price_hourly = 10
    var price_daily : Int!
    var price_weekly : Int!
    var price_monthly : Int!
    
    var visibility = "visible"
    var availibility : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("pin : \(DataService.pinToUpload)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }

    @IBAction func finishBtn(_ sender: Any) {
        if availabilitySegment.selectedSegmentIndex == UISegmentedControl.noSegment {
            alert(message: "Please select Parking Availability")
        }
        else if !hourlySwitch.isOn {
            alert(message: "Please select Hourly price")
        } else {
            finishButton.isEnabled = false
            addDetails { (success) in
                if success {
                    DataService.instance.createPinLocation(completionhandeler: { (success) in
                        if success {
                            self.finishButton.isEnabled = true
                            self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            self.alert(message: "Please try again")
                            self.finishButton.isEnabled = true
                        }
                    })
                } else {
                    self.alert(message: "Please try again")
                    self.finishButton.isEnabled = true
                }
            }
        }
        
    }
    
    func addDetails(completionhandler : @escaping (_ complete : Bool) -> ()) {
        segmentChanged()
        let pin = DataService.pinToUpload
        pin.availability = availibility
        
        if availibility == "open" {
            pin.visibility = visibility
        } else {
            pin.visibility = "invisible"
        }
        
        if hourlySwitch.isOn {
            if (hourlyPrice.text?.isBlank)! {
                self.alert(message: "Please input Price")
                completionhandler(false)
                return
            } else {
                pin.price_hourly = hourlyPrice.text!
            }
        }
        
        if weeklySwitch.isOn {
            if (weeklyPrice.text?.isBlank)! {
                self.alert(message: "Please input Price")
                completionhandler(false)
                return
            } else {
                pin.price_weekly = weeklyPrice.text!
            }
        }
        
        if dailySwitch.isOn {
            if (dailyPrice.text?.isBlank)! {
                self.alert(message: "Please input Price")
                completionhandler(false)
                return
            } else {
                pin.price_daily = dailyPrice.text!
            }
        }
        
        if monthlySwitch.isOn {
            if (monthlyPrice.text?.isBlank)! {
                self.alert(message: "Please input Price")
                completionhandler(false)
                return
            } else {
                pin.price_monthly = monthlyPrice.text!
            }
        }
        completionhandler(true)
        
    }
    
    func segmentChanged() {
        switch availabilitySegment.selectedSegmentIndex {
        case 0:
            availibility = "open"
            break
        case 1:
            availibility = "closed"
            break
        default:
            break
        }
    }
    
    @IBAction func availabilitySegmentChanged(_ sender: Any) {
        switch availabilitySegment.selectedSegmentIndex {
        case 0:
            availibility = "open"
            break
        case 1:
            availibility = "closed"
            break
        default:
            break
        }
    }
    
    func alert(message:String )
    {
        let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                
                //  self.UISetup(enable: true)
            }
        }))
        self.present(alertview, animated: true, completion: nil)
        
    }
        
}
