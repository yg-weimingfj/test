//
//  EmptyCarController.swift
//  DriverIos
//
//  Created by my on 2016/12/7.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit


class EmptyCarController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var datePickView : UIDatePicker!
    var contentView : UIView!
    var areaView : UIView!
    
    var sourceAreaLabel : UILabel!
    var pickView: UIView!
    
    var provinceLabel : UILabel!
    var cityLabel : UILabel!
    var townLabel : UILabel!
    let courses = [
        ["name":"Swift","pic":"swift.png"],
        ["name":"OC","pic":"oc.jpg"],
        ["name":"Java","pic":"java.png"],
        ["name":"PHP","pic":"php.jpeg"],
        ["name":"JS","pic":"js.jpeg"],
        ["name":"HTML","pic":"html.jpeg"],
        ["name":"Ruby","pic":"ruby.png"]
    ]
    @IBOutlet weak var sourceAreaView: UIView!
    @IBOutlet weak var emptyCarButton: UIButton!


    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var emptyCarTimeView: UIView!
    
    //变量初始化
    var provinceCode : String!
    var cityCode : String!
    var townCode : String!
    var areaCode : String!
    var areaText : String!
    var selectedAreaCode : String!
    
    var allArea : NSArray!
    var areaArr : Array<AnyObject> = []
    
    let buttonColor = UIColor(red: 51/255, green: 142/255, blue: 255/255, alpha: 0.5)
    
    let screenSize = UIScreen.main.bounds.size
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let sourceAreaViewUI = UITapGestureRecognizer(target: self, action: #selector(sourceAreaPickViewShow))
        sourceAreaView.addGestureRecognizer(sourceAreaViewUI)
        sourceAreaView.isUserInteractionEnabled = true
        
        let emptyCarTimeViewUI = UITapGestureRecognizer(target: self, action: #selector(timePickViewShow))
        emptyCarTimeView.addGestureRecognizer(emptyCarTimeViewUI)
        emptyCarTimeView.isUserInteractionEnabled = true
        
        emptyCarButton.layer.masksToBounds = true
        emptyCarButton.layer.cornerRadius = 10

        pickView = UIView(frame: CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: screenSize.height))
        
        let closeView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height/3))
        closeView.backgroundColor = UIColor(red: 170/255, green: 170/255, blue: 170/255, alpha: 0.5)
        pickView.addSubview(closeView)
        let pickViewAction = UITapGestureRecognizer(target: self, action: #selector(cancel))
        closeView.addGestureRecognizer(pickViewAction)
        closeView.isUserInteractionEnabled = true
    }
    
    func timePickViewShow() {//时间选择显示
        
        if contentView != nil{
            contentView.removeFromSuperview()
        }
        let contentViewWidth = screenSize.width
        let contentViewHeight = screenSize.height/3*2
        contentView = UIView(frame: CGRect(x: 0, y: screenSize.height/3, width: contentViewWidth, height: contentViewWidth))
        contentView.backgroundColor = UIColor.white
        pickView.addSubview(contentView)
        
        let cancelButton = UIButton(frame: CGRect(x: 10, y: 10, width: 60, height: 20))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.backgroundColor = buttonColor
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 3
        contentView.addSubview(cancelButton)
        
        let timeOkButton = UIButton(frame: CGRect(x: contentViewWidth-70, y: 10, width: 60, height: 20))
        timeOkButton.setTitle("确定", for: .normal)
        timeOkButton.setTitleColor(UIColor.white, for: .normal)
        timeOkButton.backgroundColor = buttonColor
        timeOkButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        timeOkButton.layer.masksToBounds = true
        timeOkButton.layer.cornerRadius = 3
        contentView.addSubview(timeOkButton)
        
        datePickView = UIDatePicker(frame: CGRect(x: 0, y: 40, width: contentViewWidth, height: contentViewHeight-40))
        datePickView.locale = Locale.init(identifier: "zh_CN")
        contentView.addSubview(datePickView)
        if timeLabel.text?.isEmpty == false{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: timeLabel.text!)
            datePickView.setDate(date!, animated: true)
        }
        let timeOkButtonView = UITapGestureRecognizer(target: self, action: #selector(timeOk))
        timeOkButton.addGestureRecognizer(timeOkButtonView)
        timeOkButton.isUserInteractionEnabled = true
        
        let cancelButtonUI = UITapGestureRecognizer(target: self, action: #selector(cancel))
        cancelButton.addGestureRecognizer(cancelButtonUI)
        cancelButton.isUserInteractionEnabled = true
        pickOpen()
    }
    
    func pickOpen(){//弹出层显示
        UIApplication.shared.windows[0].addSubview(pickView)//将view加入window中准备显示
        var frame = pickView.frame
        frame.origin.y = 0
        UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
        }) { (Bool) in
            UIView .animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                self.pickView.frame = frame
            }, completion: { (Bool) in})
        }
    }
    
    func timeOk(){//时间确定
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        timeLabel.text = dateFormatter.string(from: datePickView.date)
        contentView.removeFromSuperview()
        cancel()
    }
    func cancel(){//关闭事件
            var frame = pickView.frame
            frame.origin.y += pickView.frame.size.height
            
            UIView.animate(withDuration: 0.3, animations: {
                self.pickView.frame = frame
            }) { (Bool) in
                UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                }, completion: { (Bool) in
                    // 移除
                    self.pickView.removeFromSuperview()
                })
            }
        
        contentView.removeFromSuperview()
    }
    func sourceAreaPickViewShow(){
        if contentView != nil{
            contentView.removeFromSuperview()
        }
        let contentViewWidth = screenSize.width
        let contentViewHeight = screenSize.height/3*2
        
        contentView = UIView(frame: CGRect(x: 0, y: screenSize.height/3, width: contentViewWidth, height: contentViewHeight))
        contentView.backgroundColor = UIColor.white
        pickView.addSubview(contentView)
        let cancelButton = UIButton(frame: CGRect(x: 10, y: 10, width: 60, height: 20))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.backgroundColor = buttonColor
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 3
        let cancelButtonUI = UITapGestureRecognizer(target: self, action: #selector(cancel))
        cancelButton.addGestureRecognizer(cancelButtonUI)
        cancelButton.isUserInteractionEnabled = true
        
        let okButton = UIButton(frame: CGRect(x: contentViewWidth-70, y: 10, width: 60, height: 20))
        okButton.setTitle("确定", for: .normal)
        okButton.setTitleColor(UIColor.white, for: .normal)
        okButton.backgroundColor = buttonColor
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        okButton.layer.masksToBounds = true
        okButton.layer.cornerRadius = 3
        contentView.addSubview(okButton)
        let okButtonUI = UITapGestureRecognizer(target: self, action: #selector(okButtion))
        okButton.addGestureRecognizer(okButtonUI)
        okButton.isUserInteractionEnabled = true
        let areaWidth = (contentViewWidth-160)/3
        provinceLabel = UILabel(frame:CGRect(x: 80, y: 10, width: areaWidth, height: 20))
        cityLabel = UILabel(frame:CGRect(x: 80+areaWidth, y: 10, width: areaWidth, height: 20))
        townLabel = UILabel(frame: CGRect(x: 80+areaWidth*2, y: 10, width: areaWidth, height: 20))
        
        provinceLabel.text = "省份"
        provinceLabel.font = UIFont.systemFont(ofSize: 12)
        provinceLabel.textColor = UIColor.gray
        provinceLabel.textAlignment = NSTextAlignment.center
        contentView.addSubview(provinceLabel)
        let provinceLabelUI = UITapGestureRecognizer(target: self, action: #selector(provinceSelected))
        provinceLabel.addGestureRecognizer(provinceLabelUI)
        provinceLabel.isUserInteractionEnabled = true
        
        cityLabel.text = "城市"
        cityLabel.font = UIFont.systemFont(ofSize: 12)
        cityLabel.textAlignment = NSTextAlignment.center
        cityLabel.textColor = UIColor.gray
        contentView.addSubview(cityLabel)
        let cityLabelUI = UITapGestureRecognizer(target: self, action: #selector(citySelected))
        cityLabel.addGestureRecognizer(cityLabelUI)
        cityLabel.isUserInteractionEnabled = true
        
        
        townLabel.text = "乡镇"
        townLabel.font = UIFont.systemFont(ofSize: 12)
        townLabel.textAlignment = NSTextAlignment.center
        townLabel.textColor = UIColor.gray
        contentView.addSubview(townLabel)
        let townLabelUI = UITapGestureRecognizer(target: self, action: #selector(townSelected))
        townLabel.addGestureRecognizer(townLabelUI)
        townLabel.isUserInteractionEnabled = true
        
        contentView.addSubview(cancelButton)
        pickOpen()
    }
    
    func getAreaData(_ areaCode : String){
        let querySQL = "SELECT CODE,PARENT_CODE,TEXT,PIN_YIN,REMARK,SIMPLE_TEXT,PROVINCE,SIMPLE_CITY,PROVINCE,SIMPLE_CITY,LEVEL,FULL_TEXT,CITY_TEXT,LON,LAT,IS_DIRECTLY_UNDER FROM 'base_area_tab' where PARENT_CODE = '\(areaCode)'"
        // 取出查询到的结果
        let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL)
        areaArr = []
        for dict in resultDataArr! {
            let mymodel = AreaModel(code: dict["CODE"] as! String, parentCode: dict["PARENT_CODE"] as! String, text: dict["TEXT"] as! String, pinYin: dict["PIN_YIN"] as! String, remark: dict["REMARK"] as! String , simpleText: dict["SIMPLE_TEXT"] as! String, province: dict["PROVINCE"] as! String, simpleCity: dict["SIMPLE_CITY"] as! String, areaLevel: dict["LEVEL"] as! String, isDirectlyUnder: dict["IS_DIRECTLY_UNDER"] as! String, fullText: dict["FULL_TEXT"] as! String, cityText: dict["CITY_TEXT"] as! String , lon: dict["LON"] as! String, lat: dict["LAT"] as! String)
            areaArr.append(mymodel)
        }
    }
    
    func okButtion(){
        
    }
    
    func provinceSelected(){
        provinceLabel.textColor = UIColor.black
        cityLabel.textColor = UIColor.gray
        townLabel.textColor = UIColor.gray
        getAreaData("0")
        createView()
    }
    
    func citySelected(){
        cityLabel.textColor = UIColor.black
        townLabel.textColor = UIColor.gray
        
        if(!areaCode.isEmpty){
            let index = areaCode.index(areaCode.startIndex, offsetBy: 2)
            areaCode = areaCode.substring(to: index)
            areaCode! += "0000"
        }
        getAreaData(areaCode)
        createView()
    }
    
    func townSelected(){
        townLabel.textColor = UIColor.black
    }
    
    func createView(){
        if areaView != nil {
            areaView.removeFromSuperview()
        }
        let arrowCount = Int(ceil(Double(areaArr.count)/4))
        areaView = UIView(frame: CGRect(x: 0, y: 40, width: screenSize.width, height: screenSize.height/3*2-40))
        
        //定义collectionView的布局类型，流布局
        let layout = UICollectionViewFlowLayout()
        //设置cell的大小
        layout.itemSize = CGSize(width: Int(screenSize.width-20)/4-10, height: Int(screenSize.height/3*2-40)/arrowCount-10)
        //滑动方向 默认方向是垂直
        layout.scrollDirection = .vertical
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = 5
        //每行之间最小的间距
        layout.minimumLineSpacing = 10
        //定义一个UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 10,y: 0,width: screenSize.width-20,height: areaView.bounds.size.height), collectionViewLayout: layout)
        //设置collectionView的背景颜色
        collectionView.backgroundColor = UIColor.white
        
        //设置collectionView的代理和数据源
        collectionView.delegate = self
        collectionView.dataSource = self
        //CollectionViewCell的注册
        
        //        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCell")
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "ViewCell")
        
        areaView.addSubview(collectionView)
        
        contentView.addSubview(areaView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    

    @IBAction func emptyCarBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return areaArr.count
    }
    
    /**
     - returns: 绘制collectionView的cell
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identify:String = "ViewCell"
        // 获取设计的单元格，不需要再动态添加界面元素
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: identify, for: indexPath) as UICollectionViewCell
        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CollectionViewCell
        
        let lbl = UILabel(frame:CGRect(x:0, y:0, width:cell.bounds.size.width, height:20))
        lbl.textAlignment = .center
        let areaModel:AreaModel = areaArr[indexPath.item] as! AreaModel
        lbl.text = areaModel.text
//        print(areaModel["lon"] as Any)
        cell.backgroundColor = UIColor.blue
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.addSubview(lbl)
        //        cell.imageView.image = UIImage(named: "\(indexPath.row + 2).png")
        //        cell.label.text = courses[indexPath.item]["name"]
        
        //        let cellButton =
        
        return cell
    }
    
    /**
     - returns: 返回headview或者footview
     */
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headView", for: indexPath)
        headView.backgroundColor = UIColor.white
        
        return headView
    }
    
    // #MARK: --UICollectionViewDelegate的代理方法
    /**
     Description:当点击某个Item之后的回应
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let areaModel:AreaModel = areaArr[indexPath.item] as! AreaModel
        areaCode = areaModel.areaCode
        
        citySelected()
    }
}
