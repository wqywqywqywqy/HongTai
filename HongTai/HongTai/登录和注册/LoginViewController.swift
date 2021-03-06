//
//  LoginViewController.swift
//  HongTai
//
//  Created by 周旭 on 2018/10/12.
//  Copyright © 2018年 欧张帆. All rights reserved.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    var users = [pop]()
    var user: pop?
    var carts = [caart]()
    var ccart: caart?
     var dataModel = DataModel()
    var modeldata = CartModel()
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        username.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        username.minimumFontSize=14  //最小可缩小的字号
        password.adjustsFontSizeToFitWidth=true  //当文字超出文本框宽度时，自动调整文字大小
        password.minimumFontSize=14  //最小可缩小的字号
        username.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        password.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        password.isSecureTextEntry = true //输入内容会显示成小黑点
        username.placeholder="请输入用户名"
        password.placeholder="请输入密码"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func xiugaimima(_ sender: Any) {
         getLocalData()
        if(username.text != "")
        {
            for x in 0...users.count - 1
            {
                if(username.text == users[x].name)
                {
                    let alertController = UIAlertController(title: "修改密码",message: "请输入密码", preferredStyle: .alert)
                    alertController.addTextField {
                        (textField: UITextField!) -> Void in
                        textField.placeholder = "新密码"
                    }
                    alertController.addTextField {
                        (textField: UITextField!) -> Void in
                        textField.placeholder = "确认密码"
                        textField.isSecureTextEntry = true
                    }
                    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                    let okAction = UIAlertAction(title: "好的", style: .default, handler: {
                        action in
                        //也可以用下标的形式获取textField let login = alertController.textFields![0]
                        let newpw = alertController.textFields!.first!
                        let rnewpw = alertController.textFields!.last!
                        if(newpw.text != "" ){
                            if(rnewpw.text == newpw.text)
                            {
                                let app = UIApplication.shared.delegate as! AppDelegate
                                func getContext() -> NSManagedObjectContext{
                                    
                                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                                    
                                    return appDelegate.persistentContainer.viewContext
                                }
                                //获取数据上下文对象
                                let context = getContext()
                                //声明数据的请求，声明一个实体结构
                                
                                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                                //查询条件
                                fetchRequest.predicate = NSPredicate(format: "username = '\(self.username.text!)' ")
                                // 返回结果在finalResult中
                                
                                let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in
                                    //对返回的数据做处理。
                                    let fetchObject  = result.finalResult! as! [User]
                                    for c in fetchObject{
                                        c.userpassword = newpw.text
                                        app.saveContext()
                                        print("啊")
                                        let alertController = UIAlertController(title: "提示!", message: "修改成功", preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "确认", style: .default,handler: nil)
                                        alertController.addAction(okAction)
                                        self.present(alertController, animated: true, completion: nil)
                                    }//c结束
                                }//内部第一步
                                // 执行异步请求调用execute
                                do {
                                    try context.execute(asyncFecthRequest)
                                    
                                } catch  {
                                    print("error")
                                }//内部第二步
                            }
                            else//这是判断确认密码与新密码是否一致
                            {
                                let alertController = UIAlertController(title: "提示!",
                                                                        message: "确认密码与新密码不一致！", preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "返回", style: .default,handler: nil)
                                alertController.addAction(okAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                            
                        }
                        else//这是判断新密码是否填写的
                        {
                            let alertController = UIAlertController(title: "提示!",
                                                                    message: "请填写新密码！", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "返回", style: .default,handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    })//这是好的事件里的
                    alertController.addAction(cancelAction)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                continue
            }
            for x in 0...users.count - 1
            {
                if(username.text != users[x].name)
                {
                    let alertController = UIAlertController(title: "提示!",
                                                            message: "用户未注册", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "返回", style: .default,handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                continue
            }//第二个for
        }
        else
            //第一个判断用户明是否填写
        {
            let alertController = UIAlertController(title: "提示!",
                                                    message: "请填写用户名", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "返回", style: .default,handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func login(_ sender: Any) {
        getLocalData()
        if(username.text == "" || password.text == "")
        {
            let alertController = UIAlertController(title: "提示!",
                                                    message: "用户名或密码不能为空", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "返回", style: .default,handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        if users.count > 0 {
            for x in 0...users.count - 1
            {
                if(username.text == users[x].name && password.text == users[x].password)
                {
                    let alertController = UIAlertController(title: "提示!",
                                                            message: "登录成功", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确认", style: .default,handler: {
                        action in
                            self.performSegue(withIdentifier: "login", sender: self)
                    })
//                     modeldata.loadData()
//                    getLocalData1()
//                    if carts.isEmpty == false
//                    {
//                    for x in 0...carts.count - 1
//                    {
//                        if carts[x].username == username.text
//                        {
//                            modeldata.cartlist.append(CartList(goodsimg:carts[x].goodsimg, goodstyle: carts[x].goodstyle, goodsname: carts[x].goodsname, introduction: carts[x].introduction,marketprice: carts[x].marketprice,salesnum: carts[x].salesnum,stock: carts[x].stock ,userid: carts[x].userid,total: carts[x].total, number:carts[x].number,username:carts[x].username))
//                            modeldata.saveData()
//                        }
//                        continue
//                    }
//                    }
                    dataModel.loadData()
                    dataModel.userliebiao.append(UserInfo(name: username.text!, password: password.text!, id:users[x].userbianhao, image: users[x].userimg,realname: users[x].realname, update: users[x].userupdate))
                    dataModel.saveData()
                    print("进入了")
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                continue
                
            }
            
            
            for x in 0...users.count - 1
            {
            if(username.text != users[x].name && password.text == users[x].password)
            {
                let alertController = UIAlertController(title: "提示!",
                                                        message: "用户名未注册", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "返回", style: .default,handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
            continue
            }
            
            
            for x in 0...users.count - 1
            {
                if(username.text == users[x].name && password.text != users[x].password)
                {
                    let alertController = UIAlertController(title: "提示!",
                                                            message: "密码错误", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "返回", style: .default,handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                continue
            }
            
            for x in 0...users.count - 1
            {
                if(username.text != users[x].name && password.text != users[x].password)
                {
                    let alertController = UIAlertController(title: "提示!",
                                                            message: "查无此用户", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "返回", style: .default,handler: nil)
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                continue
            }
            }
        else
        {
            let alertController = UIAlertController(title: "提示!",
                                                    message: "用户未注册", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "返回", style: .default,handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
        }
    }
//else//没有用户判断
//{
//    let alertController = UIAlertController(title: "提示!",
//                                            message: "用户不存在！", preferredStyle: .alert)
//    let okAction = UIAlertAction(title: "返回", style: .default,handler: nil)
//    alertController.addAction(okAction)
//    self.present(alertController, animated: true, completion: nil)
//}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
extension LoginViewController {
    fileprivate func getLocalData() {
        //        步骤一：获取总代理和托管对象总管
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedObectContext = appDelegate.persistentContainer.viewContext
        
        //        步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        //        步骤三：执行请求
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                users.removeAll()
                for result in results {
                    guard let user = translateData(from: result) else { return }
                    users.append(user)
                }
            }
            
        } catch  {
            fatalError("获取失败")
        }
        
    }
    
    fileprivate func translateData(from: NSManagedObject) -> (pop?) {
        
        if let img = from.value(forKey: "userimage") as? Data,let useid = from.value(forKey: "userid") as? String,let name = from.value(forKey: "username") as? String,let updateTime = from.value(forKey: "userupdate") as? Date, let password = from.value(forKey: "userpassword") as? String, let realname = from.value(forKey: "userrealname") as? String{
            let user = pop(userimg: img, name: name, password:password, realname: realname, userbianhao: useid , userupdate: updateTime )
            
            return user
        }
        return nil
    }
}


extension LoginViewController {
    
    fileprivate func getLocalData1() {
        //        步骤一：获取总代理和托管对象总管
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedObectContext = appDelegate.persistentContainer.viewContext
        
        //        步骤二：建立一个获取的请求
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cart")
        
        //        步骤三：执行请求
        do {
            let fetchedResults = try managedObectContext.fetch(fetchRequest) as? [NSManagedObject]
            if let results = fetchedResults {
                carts.removeAll()
                for result in results {
                    guard let cartss = translateData1(from: result) else { return }
                    carts.append(cartss)
                }
            }
            
        } catch  {
            fatalError("获取失败")
        }
        
    }
    
    
    fileprivate func translateData1(from: NSManagedObject) -> (caart?) {
        
        if let img = from.value(forKey: "goodsimg") as? String,let goodsname = from.value(forKey: "goodsname") as? String,let style = from.value(forKey: "goodstyle") as? String,let introduction = from.value(forKey: "introduction") as? String, let marketprice = from.value(forKey: "marketprice") as? String, let number = from.value(forKey: "number") as? String, let salesnum = from.value(forKey: "salesnum") as? String, let stock = from.value(forKey: "stock") as? String, let total = from.value(forKey: "total") as? String, let userid = from.value(forKey: "userid") as? String, let username = from.value(forKey: "username") as? String{
            let user = caart(userid: userid, total: total, stock: stock, salesnum: salesnum, number: number, marketprice: marketprice, introduction: introduction, goodstyle: style, goodsname: goodsname, goodsimg: img,username:username)
            
            return user
        }
        return nil
    }
}
