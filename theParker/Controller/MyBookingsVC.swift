//
//  MyBookingsVC.swift
//  theParker
//
//  Created by Ketan Choyal on 18/03/19.
//  Copyright © 2019 Ketan Choyal. All rights reserved.
//

import UIKit

class MyBookingsVC: UIViewController {
    
    @IBOutlet weak var menu: UIBarButtonItem!
    
    @IBOutlet weak var myBookingsTable: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        menu.target = revealViewController()
        menu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        myBookingsTable.delegate = self
        myBookingsTable.dataSource = self
        BookingService.instance.getMyBookings { (success) in
            self.myBookingsTable.reloadData()
        }
    }
    
}

extension MyBookingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BookingService.instance.myBookings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "myBookingCell") as? MyBookingCell else { return UITableViewCell() }
        
        let bookings = BookingService.instance.myBookings
        let key = Array(bookings.keys)[indexPath.row]
        let booking = bookings[key]
        cell.configureCell(booking!)
        
        return cell
    }
    
    
}

extension MyBookingsVC {
    
    
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
