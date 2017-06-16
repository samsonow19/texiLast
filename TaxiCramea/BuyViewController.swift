//
//  BuyViewController.swift
//  TaxiCramea
//
//  Created by жека on 12.06.17.
//  Copyright © 2017 админ. All rights reserved.
//

import UIKit
import SearchTextField
import Alamofire
import Toaster

class BuyViewController: UIViewController {

    @IBOutlet weak var whereTextAC: SearchTextField!
    @IBOutlet weak var whenceTextAC: SearchTextField!
    @IBOutlet weak var dateTextFild: UITextField!
    @IBOutlet weak var timeTextFild1: UITextField!
    @IBOutlet weak var timeTextFild2: UITextField!
 
    
    let datePiker = UIDatePicker()
    let timePiker1 = UIDatePicker()
    let timePiker2 = UIDatePicker()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        
    
        
        whereTextAC.startVisible = true
        //let whereSearchTextField = SearchTextField(frame: CGRect(x: 10, y: 100, width: 200, height: 40))
        whereTextAC.filterStrings(regionArray)
        
        whenceTextAC.startVisible = true
        whenceTextAC.filterStrings(regionArray)
        
        datePiker.datePickerMode = .date
        timePiker1.datePickerMode = .countDownTimer
        timePiker1.minuteInterval = 30
        timePiker2.datePickerMode = .countDownTimer
        timePiker2.minuteInterval = 30
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneDatePressed) )
        toolbar.setItems([doneButton], animated: false)
        dateTextFild.inputAccessoryView = toolbar
        dateTextFild.inputView = datePiker
        
        
        let toolbarTime1 = UIToolbar()
        toolbarTime1.sizeToFit()
        let doneButtonTime1 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTime1Pressed) )
        toolbarTime1.setItems([doneButtonTime1], animated: false)
        timeTextFild1.inputAccessoryView = toolbarTime1
        timeTextFild1.inputView = timePiker1
        
        
        let toolbarTime2 = UIToolbar()
        toolbarTime2.sizeToFit()
        let doneButtonTime2 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTime2Pressed) )
        toolbarTime2.setItems([doneButtonTime2], animated: false)
        timeTextFild2.inputAccessoryView = toolbarTime2
        timeTextFild2.inputView = timePiker2


    }
    
    func doneDatePressed() {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        let strDate = dateFormatter.string(from: datePiker.date)

        dateTextFild.text = "\(strDate)"
        self.view.endEditing(true)
    }
    
    func doneTime1Pressed() {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        let strDate = dateFormatter.string(from: timePiker1.date)
        
        timeTextFild1.text = "\(strDate)"
        self.view.endEditing(true)
    }
    func doneTime2Pressed() {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = Locale(identifier:"en_US_POSIX")
        let strDate = dateFormatter.string(from: timePiker2.date)
        
        timeTextFild2.text = "\(strDate)"
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    @IBAction func savefindOrder(_ sender: Any) {
        
        let user: UserModel = UserModel.shared
        let url = BASEURL + "buy.php"
        let date1 = dateTextFild.text! + timeTextFild1.text!
        let date2 = dateTextFild.text! + timeTextFild2.text!
        
        let parameters: Parameters = [
            "code": CODE ,
            "token":  user.tokenUserTaxi ,
            "id_user":  user.idUser ,
            "destination": whenceTextAC.text ?? "",
            "whence": whereTextAC.text ?? "",
            "data": date1,
            "data_to": date2,
            ]
        Alamofire.request(url, method: .post, parameters: parameters).responseString{ respons in
            var data = convertToDictionary(text: respons.result.value)
            
            print(data)
            let test =  data?["success"]
            if test != nil {
                Toast.init(text: "Ваш заказ сохренен").show()
                
            } else {
                Toast.init(text: "Ошибка").show()
            }
            
        }
        
        
    }
    

}
