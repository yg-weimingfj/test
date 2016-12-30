//
//  AreaDropDownView.swift
//  DriverIos
//
//  Created by my on 2016/12/27.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class AreaDropDownView: UIView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var bbchange :((_ areaCode:String,_ provinceValue:String,_ cityValue : String,_ townValue : String)->Void)?
    var areaCode : String!
    var areaArr : Array<AnyObject> = []
   
    var provinceLabel : UILabel!
    var cityLabel : UILabel!
    var townLabel : UILabel!
    var areaLabel : UILabel!
    var provinceValue : String! = "省份"
    var cityValue :String! = "城市"
    var townValue : String! = "区/镇"
    var areaView : UIView!
    var alertController : UIAlertController!
    var viewWidth : CGFloat!
    var viewHeight : CGFloat!
    var showLevel : String!//判断父级页面显示的地区地址（nil或者0则显示当前的所选的item，1为当前item加上一级item，2为详细地址
    var areaTitleLabel : UILabel!
    var title : String! = nil
    override init(frame: CGRect){
        
        super.init(frame: frame)
        viewWidth = frame.size.width
        viewHeight = frame.size.height-124
        
    }
    func createAreaView(){
        areaTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 58))
        
        addSubview(areaTitleLabel)
        if(title != nil){
            areaTitleLabel.text = title
        }else{
           areaTitleLabel.text = "请选择出发地"
        }
        areaTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        areaTitleLabel.textAlignment = NSTextAlignment.center
        
        let borderView = UIView(frame: CGRect(x: 0, y: 58, width: viewWidth, height: 1))
        borderView.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 0.5)
        addSubview(borderView)
        
        let areaWidth = (viewWidth)/3
        provinceLabel = UILabel(frame:CGRect(x: 0, y: 59, width: areaWidth, height: 44))
        cityLabel = UILabel(frame:CGRect(x: areaWidth, y: 59, width: areaWidth, height: 44))
        townLabel = UILabel(frame: CGRect(x: areaWidth*2, y: 59, width: areaWidth, height: 44))
        
        provinceLabel.text = provinceValue
        
        
        provinceLabel.font = UIFont.systemFont(ofSize: 17)
        provinceLabel.textColor = UIColor.gray
        provinceLabel.textAlignment = NSTextAlignment.center
        addSubview(provinceLabel)
        let provinceLabelUI = UITapGestureRecognizer(target: self, action: #selector(provinceSelected))
        provinceLabel.addGestureRecognizer(provinceLabelUI)
        provinceLabel.isUserInteractionEnabled = true
        
        cityLabel.text = cityValue
        
        cityLabel.font = UIFont.systemFont(ofSize: 17)
        cityLabel.textAlignment = NSTextAlignment.center
        cityLabel.textColor = UIColor.gray
        addSubview(cityLabel)
        let cityLabelUI = UITapGestureRecognizer(target: self, action: #selector(citySelected))
        cityLabel.addGestureRecognizer(cityLabelUI)
        cityLabel.isUserInteractionEnabled = true
        
        
        townLabel.text = townValue
        
        townLabel.font = UIFont.systemFont(ofSize: 17)
        townLabel.textAlignment = NSTextAlignment.center
        townLabel.textColor = UIColor.gray
        addSubview(townLabel)
        let townLabelUI = UITapGestureRecognizer(target: self, action: #selector(townSelected))
        townLabel.addGestureRecognizer(townLabelUI)
        townLabel.isUserInteractionEnabled = true
        
        let areaBorderView = UIView(frame: CGRect(x: 0, y: 103, width: viewWidth, height: 1))
        areaBorderView.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 0.5)
        addSubview(areaBorderView)
        chooseShow()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func chooseShow(){
        if(areaCode != nil){
            if(areaCode.range(of: "0000") != nil){
                provinceSelected()
            }else if (areaCode.range(of: "00") != nil){
                citySelected()
            }else {
                townSelected()
            }
        }else{
            provinceSelected()
        }
    }
    func provinceSelected(){
        provinceLabel.textColor = UIColor.black
        cityLabel.textColor = UIColor.gray
        townLabel.textColor = UIColor.gray
        getAreaData("0")
        createView()
    }
    
    func citySelected(){
        if(areaCode != nil){
            if(!areaCode.isEmpty){
                cityLabel.textColor = UIColor.black
                townLabel.textColor = UIColor.gray
                if(areaCode != nil){
                    if(areaCode.range(of: "0000") != nil){
                        cityLabel.text = "城市"
                        cityValue = "城市"
                    }
                    if (areaCode.range(of: "00") != nil){
                        townLabel.text = "区/镇"
                        townValue = "区/镇"
                    }
                }
                let index = areaCode.index(areaCode.startIndex, offsetBy: 2)
                var cityAreaCode = areaCode.substring(to: index)
                cityAreaCode += "0000"
                getAreaData(cityAreaCode)
                createView()
            }
        }
    }
    
    func townSelected(){
        if(areaCode != nil){
            if(!areaCode.isEmpty){
                townLabel.textColor = UIColor.black
                if(areaCode != nil){
                    if (areaCode.range(of: "00") != nil){
                        townLabel.text = "区/镇"
                        townValue = "区/镇"
                    }
                }
                let index = areaCode.index(areaCode.startIndex, offsetBy: 4)
                var townAreaCode = areaCode.substring(to: index)
                townAreaCode += "00"
                getAreaData(townAreaCode)
                createView()
            }
        }
    }
    
    func createView(){
        if areaView != nil {
            areaView.removeFromSuperview()
        }
        let arrowCount = Int(ceil(Double(areaArr.count)/4))
        var cellHeight = Int(viewHeight)/arrowCount-10
        if(cellHeight > Int((viewWidth-20)/4)-10){
            cellHeight = Int((viewWidth-20)/4)-10
        }
        areaView = UIView(frame: CGRect(x: 0, y: 124, width: viewWidth, height: viewHeight))
        areaView.backgroundColor = UIColor.clear
        addSubview(areaView)
        //定义collectionView的布局类型，流布局
        let layout = UICollectionViewFlowLayout()
        //设置cell的大小
        layout.itemSize = CGSize(width: Int((viewWidth-20)/4)-10, height: cellHeight)
        //滑动方向 默认方向是垂直
        layout.scrollDirection = .vertical
        //每个Item之间最小的间距
        layout.minimumInteritemSpacing = 5
        //每行之间最小的间距
        layout.minimumLineSpacing = 10
        //定义一个UICollectionView
        let collectionView = UICollectionView(frame: CGRect(x: 10,y: 0,width: viewWidth-20,height: areaView.bounds.size.height), collectionViewLayout: layout)
        //设置collectionView的背景颜色
        collectionView.backgroundColor = UIColor.clear
        
        //设置collectionView的代理和数据源
        collectionView.delegate = self
        collectionView.dataSource = self
        //CollectionViewCell的注册
        
        //        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCell")
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "ViewCell")
        
        areaView.addSubview(collectionView)

    }
    func getAreaData(_ areaCode : String){
        let querySQL = "SELECT CODE,PARENT_CODE,TEXT,PIN_YIN,REMARK,SIMPLE_TEXT,PROVINCE,SIMPLE_CITY,PROVINCE,SIMPLE_CITY,LEVEL,FULL_TEXT,CITY_TEXT,LON,LAT,IS_DIRECTLY_UNDER FROM 'base_area_tab' where PARENT_CODE = '\(areaCode)'"
        // 取出查询到的结果
        let resultDataArr = SQLManager.shareInstance().queryDataBase(querySQL: querySQL)
        areaArr = []
        if(resultDataArr != nil){
            for dict in resultDataArr! {
                let mymodel = AreaModel(code: dict["CODE"] as! String, parentCode: dict["PARENT_CODE"] as! String, text: dict["TEXT"] as! String, pinYin: dict["PIN_YIN"] as! String, remark: dict["REMARK"] as! String , simpleText: dict["SIMPLE_TEXT"] as! String, province: dict["PROVINCE"] as! String, simpleCity: dict["SIMPLE_CITY"] as! String, areaLevel: dict["LEVEL"] as! String, isDirectlyUnder: dict["IS_DIRECTLY_UNDER"] as! String, fullText: dict["FULL_TEXT"] as! String, cityText: dict["CITY_TEXT"] as! String , lon: dict["LON"] as! String, lat: dict["LAT"] as! String)
                areaArr.append(mymodel)
            }
        }
        
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
        
        let lbl = UILabel(frame:CGRect(x:0, y:0, width:cell.bounds.size.width, height:cell.bounds.size.height))
        lbl.textAlignment = .center
        let areaModel:AreaModel = areaArr[indexPath.item] as! AreaModel
        lbl.text = areaModel.text
        lbl.font = UIFont.systemFont(ofSize: 12)
        //        print(areaModel["lon"] as Any)
        cell.backgroundColor = UIColor.white
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 0.5).cgColor
        cell.addSubview(lbl)
        let mymodel:AreaModel = areaArr[indexPath.item] as! AreaModel
        if(areaCode != nil){
            if(areaCode.substring(to: areaCode.index(areaCode.startIndex, offsetBy: 2))+"0000" == mymodel.areaCode){
                provinceLabel.text = mymodel.text
                cell.backgroundColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 1)
            }else if(areaCode.substring(to: areaCode.index(areaCode.startIndex, offsetBy: 4))+"00" == mymodel.areaCode){
                cityLabel.text = mymodel.text
                cell.backgroundColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 1)
            }else if(areaCode == mymodel.areaCode){
                townLabel.text = mymodel.text
                cell.backgroundColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 1)
            }
        }
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
        if(areaModel.areaCodeLevel == "1"){
            citySelected()
            provinceLabel.text = areaModel.text
            provinceValue = areaModel.text
        }else if (areaModel.areaCodeLevel == "2"){
            townSelected()
            cityLabel.text = areaModel.text
            cityValue = areaModel.text
        }else if(areaModel.areaCodeLevel == "3"){
            townLabel.text = areaModel.text
            self.alertController.dismiss(animated: true, completion: nil)
            townValue = areaModel.text
        }
        bbchange?(areaCode,provinceValue,cityValue,townValue)
        if(showLevel == nil || showLevel == "0"){
            self.areaLabel.text = areaModel.text
        }else if(showLevel == "1"){
            self.areaLabel.text = areaModel.cityText
        }else if(showLevel == "2"){
            self.areaLabel.text = areaModel.fullText
        }
        
    }

}
