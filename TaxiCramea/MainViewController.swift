//
//  MainViewController.swift
//  TaxiCramea
//
//  Created by админ on 28.05.17.
//  Copyright © 2017 админ. All rights reserved.
//

import UIKit
import Alamofire
import Toaster
import UserNotifications


class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var regionButtonArray: [UIButton]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hightMenuButton: NSLayoutConstraint!

    @IBOutlet weak var reytLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var nikLabel: UILabel!
    @IBOutlet weak var testView: UIView!
    
    @IBOutlet weak var dateView: UIView!
    var classAvto: Bool!
    var countOrderIntoRegion = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var orderArray = [OrderModel]()
    var orderCurrentArray = [OrderModel]()
    var currentRegion: String!  = regionArray[0]
    var currentDay = CurrentDay.toDay
    var allOrderChoose : Bool = true
    var currentOptions : CurrentOptions = CurrentOptions.allOrder
    
    let myNotification = Notification.Name(rawValue:"Найдены трансферы по вашему поиску")
    
    @IBOutlet weak var tabelConstr: NSLayoutConstraint! // 116
    @IBAction func regionButton(_ sender: UIButton) {
        testView.isHidden = true
         currentRegion = regionArray[sender.tag-1]
         currentDay = CurrentDay.toDay
         getCurrentOrderByRegion()
   
    }
   // checkDay (Filter)
    @IBAction func toDayClick(_ sender: Any) {
        currentDay = CurrentDay.toDay
        getCurrentOrderByRegion()
    }
    @IBAction func tomorrowClick(_ sender: Any) {
        currentDay = CurrentDay.tomorrow
         getCurrentOrderByRegion()
    }
    @IBAction func afterTomorrowClick(_ sender: Any) {
        currentDay = CurrentDay.afterTomorrow
         getCurrentOrderByRegion()
    }
    
    
    @IBAction func beack(_ sender: UIButton) {

        testView.isHidden = false
    }
    @IBAction func optionsClick(_ sender: Any) {
    }
 
    @IBAction func buyClick(_ sender: Any) {
        
    }
    @IBAction func soundClick(_ sender: Any) {
        
    }
    
    @IBAction func exitClick(_ sender: Any) {
        
    }

    @IBAction func allOrder(_ sender: Any) {
        allOrderChoose =  true
        testView.isHidden = false
        tabelConstr.constant = 116
        dateView.isHidden = false
        currentOptions = .allOrder
        
    }
    
    @IBAction func myOrderClick(_ sender: Any) {
        
        currentOptions = .myOrder
        
        let user: UserModel = UserModel.shared
        //let avto: AvtoModel = AvtoModel.shared
        let url = BASEURL + "transfer_active.php"
        orderArray.removeAll()
        let parameters: Parameters = [
            "code": CODE ,
            "token":  user.tokenUserTaxi ,
            "id_user":  user.idUser,
            "classAuto": "1",
            ]
        Alamofire.request(url, method: .post, parameters: parameters).responseString{ respons in
            var data = self.convertToDictionary(text: respons.result.value)

            let transfers =  data?["transfer"] as? NSDictionary
      
            if transfers != nil {
                var orderItem: OrderModel
                self.orderCurrentArray.removeAll()
                for (_, value) in transfers! {
                    print(value)
                    orderItem = OrderModel()
                    orderItem.loadLongOrder(data: value as! NSDictionary)
                    print(value)
                    self.orderCurrentArray.append(orderItem)
                }
                 print( self.orderCurrentArray)
                self.tableView.reloadData()
              
            } else {
                Toast.init(text: "На данный момент трансферов нет").show()
            }
            
        }
        
        allOrderChoose = false
        testView.isHidden = true
        tabelConstr.constant = 0
        dateView.isHidden = true
    }

    @IBAction func lookFor(_ sender: Any) {

        allOrderChoose = false
        testView.isHidden = true
        tabelConstr.constant = 0
        dateView.isHidden = true
        
        currentOptions = .iLookFor
        let user: UserModel = UserModel.shared
        let url = BASEURL + "buy_main.php"
        orderArray.removeAll()
        let parameters: Parameters = [
            "code": CODE ,
            "token":  user.tokenUserTaxi ,
            "id_user":  user.idUser,
            ]
        Alamofire.request(url, method: .post, parameters: parameters).responseString{ respons in
            var data = self.convertToDictionary(text: respons.result.value)
            let transfers =  data?["buy"] as? NSDictionary
            if transfers != nil {
                var orderItem: OrderModel
                self.orderCurrentArray.removeAll()
                for (_, value) in transfers! {
                    print(value)
                    orderItem = OrderModel()
                    orderItem.loadBuyOrder(data: value as! NSDictionary)
                    print(value)
                    self.orderCurrentArray.append(orderItem)
                }
                print( self.orderCurrentArray)
                self.tableView.reloadData()
                
            } else {
                Toast.init(text: "Ваш поиск пустой. Перейдите в \"Куплю\"").show()
            }
            
        }
        
    }

    @IBAction func findClick(_ sender: Any) {
       loadFind()
    }

    func loadFind() {
        allOrderChoose = false
        testView.isHidden = true
        tabelConstr.constant = 0
        dateView.isHidden = true
        currentOptions = .iFind
        let user: UserModel = UserModel.shared
        let url = BASEURL + "buy_search.php"
        orderArray.removeAll()
        let parameters: Parameters = [
            "code": CODE ,
            "token":  user.tokenUserTaxi ,
            "id_user":  user.idUser,
            ]
        Alamofire.request(url, method: .post, parameters: parameters).responseString{ respons in
            var data = self.convertToDictionary(text: respons.result.value)
            let transfers =  data?["transfer"] as? NSDictionary
            
            if transfers != nil {
                var orderItem: OrderModel
                self.orderCurrentArray.removeAll()
                for (_, value) in transfers! {
                    print(value)
                    orderItem = OrderModel()
                    orderItem.loadShotOrder(data: value as! NSDictionary)
                    print(value)
                    self.orderCurrentArray.append(orderItem)
                }
                print( self.orderCurrentArray)
                self.tableView.reloadData()
                
            } else {
                Toast.init(text: "По вашим запросам ни чего не найдено. Можете расширить поиск в меню \"Куплю\"").show()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nc = NotificationCenter.default
        nc.addObserver(forName:myNotification, object:nil, queue:nil, using:catchNotification)
        
        self.navigationController?.isNavigationBarHidden = true;
        
        let user: UserModel = UserModel.shared
        reytLabel.text = user.rayting
        scoreLabel.text = user.score
        nikLabel.text = user.nameUserTaxi
        self.tableView.delegate = self
        self.tableView.dataSource = self
        textForRegionButton() // set text (region and count order) into button
        let userNib = UINib(nibName: "MainTableViewCell", bundle: nil)
        self.tableView.register(userNib, forCellReuseIdentifier: "MainTableViewCell")
        
        let fullOrderNib = UINib(nibName: "LongTableViewCell", bundle: nil)
        self.tableView.register(fullOrderNib, forCellReuseIdentifier: "LongTableViewCell")
        
        
        let buyOrderNib = UINib(nibName: "BuyTableViewCell", bundle: nil)
        self.tableView.register(buyOrderNib, forCellReuseIdentifier: "BuyTableViewCell")
        
        
        
        _ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.update), userInfo: nil, repeats: true);
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    func textForRegionButton() {
        var test : String!
        var textButtonRegion : String!
        for button in regionButtonArray {
            test = String(describing: countOrderIntoRegion[button.tag-1])
            textButtonRegion = regionArray[button.tag-1] + "\n " + test
            button.setTitle(textButtonRegion, for: .normal)
            button.titleLabel?.textAlignment = NSTextAlignment.center
        }
    }
    
    func getCurrentOrderByRegion() {
        countOrderIntoRegion = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        orderCurrentArray.removeAll()
        var index = 0
        var dateString : String!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

        for order in orderArray {
            if order.region1 == currentRegion {

                dateString = order.time
           
                let date = dateFormatter.date(from: dateString!)
                if checkDay(dateOrder: date!) {
                    orderCurrentArray.append(order)
                }
            }
            index = 0
            for region in regionArray {
                if region == order.region1 {
                    countOrderIntoRegion[index] += 1
                }
                index += 1
            }

        }
        textForRegionButton()
        self.tableView.reloadData()
    }

    
    func checkDay(dateOrder : Date )-> Bool {
        let date = Date()
        let calendar = Calendar.current
        let dayOrder = calendar.component(.day, from: dateOrder)
        switch currentDay {
        case .toDay:
            let toDayCalendar = calendar.component(.day, from: date)
            if toDayCalendar == dayOrder {
                return true
            } else {
                return false
            }
        case .tomorrow:
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date)
            let toDayCalendar = calendar.component(.day, from: tomorrow!)
            if toDayCalendar == dayOrder {
                return true
            } else {
                return false
            }
        case .afterTomorrow:
            
            let tomorrow = Calendar.current.date(byAdding: .day, value: 2, to: date)
            let toDayCalendar = calendar.component(.day, from: tomorrow!)
            if toDayCalendar == dayOrder {
                return true
            } else {
                return false
            }
        }
        return true
    }
    
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let message  = userInfo["message"] as? String,
            let date     = userInfo["date"]    as? Date else {
                print("No userInfo found in notification")
                return
        }
        
        let alert = UIAlertController(title: "Notification!",
                                      message:"\(message) received at \(date)",
            preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func update() {
        
        let user: UserModel = UserModel.shared
        let avto: AvtoModel = AvtoModel.shared
        let url = BASEURL + "transfer.php"
        orderArray.removeAll()
        let parameters: Parameters = [
            "code": CODE ,
            "token":  user.tokenUserTaxi ,
            "id_user":  user.idUser ,
            "classAuto": "1",
            ]
        
        
        Alamofire.request(url, method: .post, parameters: parameters).responseString{ respons in
            var data = self.convertToDictionary(text: respons.result.value)
            let transfers =  data?["transfer"] as? NSDictionary
                if transfers != nil {
                    var orderItem: OrderModel
                    for (_, value) in transfers! {
                      
                        orderItem = OrderModel()
                        orderItem.loadShotOrder(data: value as! NSDictionary)
                        self.orderArray.append(orderItem)
                    }
                    print(self.orderArray[0].region1)
                    if self.allOrderChoose { // if
                        self.getCurrentOrderByRegion()
                    }
                } else {
                    Toast.init(text: "На данный момент трансферов нет").show()
                }
            
            print(data)
            let transfersFind =  data?["buy"] as? NSDictionary
       
            if transfersFind != nil {
                let content = UNMutableNotificationContent()
                content.title = NSString.localizedUserNotificationString(forKey: "По вашим запросам найдены трансферы", arguments: nil)
                content.body = NSString.localizedUserNotificationString(forKey: "Пожалуйста зайдите в раздел \"Найденные\" ", arguments: nil)
                content.sound = UNNotificationSound.default()
                content.badge = 1
                let trifer = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest.init(identifier: "Test3", content: content, trigger: trifer)
                let center = UNUserNotificationCenter.current()
                center.add(request)
                self.loadFind()
            }

        }
        
 
        let urlAcunt = BASEURL + "account_info.php"
        orderArray.removeAll()
        let parametersForAccount: Parameters = [
            "code": CODE ,
            "token":  user.tokenUserTaxi ,
            "id_user":  user.idUser ,
            ]
        Alamofire.request(urlAcunt, method: .post, parameters: parametersForAccount).responseString{ respons in
            var data = self.convertToDictionary(text: respons.result.value)
            self.scoreLabel.text = data?["score"] as? String
            self.reytLabel.text = data?["rayting"] as? String
            avto.classAvtoUserTaxi = data?["class"] as? String
        }
        
        
        
    }
    
    
  func convertToDictionary(text: String?) -> [String: Any]? {
        if let data = text?.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    

    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderCurrentArray.count
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentOptions == .allOrder {    
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)  as! MainTableViewCell
            var orderItem: OrderModel = OrderModel()
            orderItem = orderCurrentArray[indexPath.row]
            cell.whereLabel.text = orderItem.whence
            cell.whenceLabel.text = orderItem.whereOrder
            cell.dateLabel.text = orderItem.time
            cell.costLabel.text = orderItem.cost
        
         return cell
        }
        if currentOptions == .myOrder {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LongTableViewCell", for: indexPath)  as! LongTableViewCell
            var orderItem: OrderModel = OrderModel()
           
            orderItem = orderCurrentArray[indexPath.row]
             print(orderItem.name)
            cell.whereLabel.text = orderItem.whence
            cell.whenceLabel.text = orderItem.whereOrder
            cell.dateLabel.text = orderItem.time
            cell.costLabel.text = orderItem.cost
            cell.commentLabel.text = orderItem.comment
            cell.plainLabel.text = orderItem.flight
            cell.numberLabel.text = orderItem.number
            cell.nameLabel.text = orderItem.name
            cell.infoLabel.text = orderItem.info
            
            cell.komissionLabel.text = orderItem.commision
            print(orderItem.your)
 
            cell.yourLabel.text =  orderItem.your
            cell.buttonInfo.addTarget(self, action: #selector(self.displayToolTipDetails(_:)), for: .touchUpInside)
            
            return cell
        }
        
        
        
        if currentOptions == .iLookFor {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "BuyTableViewCell", for: indexPath)  as! BuyTableViewCell
            var orderItem: OrderModel = OrderModel()
            
            orderItem = orderCurrentArray[indexPath.row]
            print(orderItem.name)
           

            cell.beforeTime.text = orderItem.toDate
            cell.toTime.text =  orderItem.beforeDate
            cell.whereTextLabel.text = orderItem.whereOrder
            cell.whenceTextLabel.text = orderItem.whence
            cell.dateTextLabel.text = orderItem.time
            
            return cell
        }
        
        
        if currentOptions == .iFind {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)  as! MainTableViewCell
            var orderItem: OrderModel = OrderModel()
            orderItem = orderCurrentArray[indexPath.row]
            cell.whereLabel.text = orderItem.whence
            cell.whenceLabel.text = orderItem.whereOrder
            cell.dateLabel.text = orderItem.time
            cell.costLabel.text = orderItem.cost
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)  as! MainTableViewCell
 
    }

    
    func displayToolTipDetails(_ sender : UIButton) {
   
    
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentOptions == .allOrder {
            let message = "Взять заказ"
            let alertOrder = UIAlertController(title: "Взять", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertOrder.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                let user: UserModel = UserModel.shared
                //let avto: AvtoModel = AvtoModel.shared
                let url = BASEURL + "transfer_buy.php"
                    let parameters: Parameters = [
                        "code": CODE ,
                        "token":  user.tokenUserTaxi ,
                        "id_user":  user.idUser ,
                        "id_zakaz":  self.orderCurrentArray[indexPath.row].id ,
                        "classAuto": "1",
                        ]
                Alamofire.request(url, method: .post, parameters: parameters).responseString{ respons in
                    let dataOrder = self.convertToDictionary(text: respons.result.value)
                    let buyOrder = dataOrder?["success"]
                    if buyOrder != nil {
                        Toast.init(text: "Трансфер перемещен в текущие заказы").show()
                        var indexOrder = 0
                        for oreder in self.orderArray {
                            if oreder.id == self.orderCurrentArray[indexPath.row].id {
                                self.orderArray.remove(at: indexOrder)
                            }
                            indexOrder += 1
                        }
                        self.orderCurrentArray.remove(at: indexPath.row)
                    
                    } else {
                        Toast.init(text: "Не достаточно средств на счету или трансфер забрали").show()
                    }
                    self.tableView.reloadData()
                }
            
            }))
        
            alertOrder.addAction(UIAlertAction(title: "Не беру", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertOrder, animated: true, completion: nil)
        }
        
        
        if currentOptions == .iFind {
            let message = "Взять заказ"
            let alertOrder = UIAlertController(title: "Взять", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertOrder.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                let user: UserModel = UserModel.shared
                //let avto: AvtoModel = AvtoModel.shared
                let url = BASEURL + "transfer_buy.php"
                let parameters: Parameters = [
                    "code": CODE ,
                    "token":  user.tokenUserTaxi ,
                    "id_user":  user.idUser ,
                    "id_zakaz":  self.orderCurrentArray[indexPath.row].id ,
                    "classAuto": "1",
                    ]
                Alamofire.request(url, method: .post, parameters: parameters).responseString{ respons in
                    let dataOrder = self.convertToDictionary(text: respons.result.value)
                    let buyOrder = dataOrder?["success"]
                    if buyOrder != nil {
                        Toast.init(text: "Трансфер перемещен в текущие заказы").show()
                        var indexOrder = 0
                        for oreder in self.orderArray {
                            if oreder.id == self.orderCurrentArray[indexPath.row].id {
                                self.orderArray.remove(at: indexOrder)
                            }
                            indexOrder += 1
                        }
                        self.orderCurrentArray.remove(at: indexPath.row)
                        
                    } else {
                        Toast.init(text: "Не достаточно средств на счету или трансфер забрали").show()
                    }
                    self.tableView.reloadData()
                }
                
            }))
            
            alertOrder.addAction(UIAlertAction(title: "Не беру", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertOrder, animated: true, completion: nil)
        }

        
        
        if currentOptions == .myOrder  {
            
            let message = "Завершить трансфер"
            let alertOrder = UIAlertController(title: "Тренсфер будет удален и з спаска ваших трансферов", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertOrder.addAction(UIAlertAction(title: "Завершить", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                let user: UserModel = UserModel.shared
                
                let url = BASEURL + "transfer_complete.php"
                let parameters: Parameters = [
                    "code": CODE ,
                    "token":  user.tokenUserTaxi ,
                    "id_user":  user.idUser ,
                    "id_zakaz":  self.orderCurrentArray[indexPath.row].id ,
                    
                    ]
                Alamofire.request(url, method: .post, parameters: parameters).responseString{ respons in
                    let dataOrder = self.convertToDictionary(text: respons.result.value)
                    let buyOrder = dataOrder?["success"]
                    if buyOrder != nil {
                        Toast.init(text: "Трансфер завершон").show()
                        self.orderCurrentArray.remove(at: indexPath.row)
                        
                    } else {
                        Toast.init(text: "Повторите попытку. Трансфер может быть завершен только в день транзакции").show()
                    }
                    self.tableView.reloadData()
                }
                
            }))
            
            alertOrder.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertOrder, animated: true, completion: nil)

            
            
        }
        
        

        if currentOptions == .iLookFor  {
            
            let message = " Удалить из поиска"
            let alertOrder = UIAlertController(title: "Удалить", message: message, preferredStyle: UIAlertControllerStyle.alert)
            alertOrder.addAction(UIAlertAction(title: "Удалить", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                let user: UserModel = UserModel.shared
          
                let url = BASEURL + "buy_main_id_remove.php"
                let parameters: Parameters = [
                    "code": CODE ,
                    "token":  user.tokenUserTaxi ,
                    "id_user":  user.idUser ,
                    "id_buy":  self.orderCurrentArray[indexPath.row].id ,
                    
                    ]
                
                Alamofire.request(url, method: .post, parameters: parameters).responseString{ respons in
                    let dataOrder = self.convertToDictionary(text: respons.result.value)
                    let buyOrder = dataOrder?["success"]
                    if buyOrder != nil {
                        Toast.init(text: "Эллемент удален из поиска").show()
                        self.orderCurrentArray.remove(at: indexPath.row)
                        
                    } else {
                        Toast.init(text: "Не удалось удалить эллемент").show()
                    }
                    self.tableView.reloadData()
                }
                
            }))
            
            alertOrder.addAction(UIAlertAction(title: "Отмена", style: UIAlertActionStyle.default, handler: nil))
            self.present(alertOrder, animated: true, completion: nil)
            
        }
        
        
    }

}
