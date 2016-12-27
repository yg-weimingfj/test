//
//  DictDropDownView.swift
//  DriverIos
//
//  Created by my on 2016/12/27.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class DictDropDownView: UIView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    var bbchange :((_ id : String,_ text : String)->Void)?
    
    var viewWidth : CGFloat!
    var viewHeight : CGFloat!
    var titleValue : String!
    var dictArr : Array<AnyObject> = []
    var dictValue : String!
    var dictLabel : UILabel!
    var dictView : UIView!
    var alertController : UIAlertController!
    override init(frame: CGRect){
        
        super.init(frame: frame)
        viewWidth = frame.size.width
        viewHeight = frame.size.height-78
        
    }
    
    func createView(){
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 58))
        
        addSubview(titleLabel)
        titleLabel.text = titleValue
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = NSTextAlignment.center
        
        let borderView = UIView(frame: CGRect(x: 0, y: 58, width: viewWidth, height: 1))
        borderView.backgroundColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 0.5)
        addSubview(borderView)
        
        
        let arrowCount = Int(ceil(Double(dictArr.count)/4))
        var cellHeight = Int(viewHeight)/arrowCount-10
        if(cellHeight > Int((viewWidth-20)/4)-10){
            cellHeight = Int((viewWidth-20)/4)-10
        }
        dictView = UIView(frame: CGRect(x: 0, y: 78, width: viewWidth, height: viewHeight))
        dictView.backgroundColor = UIColor.clear
        addSubview(dictView)
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
        let collectionView = UICollectionView(frame: CGRect(x: 10,y: 0,width: viewWidth-20,height: dictView.bounds.size.height), collectionViewLayout: layout)
        //设置collectionView的背景颜色
        collectionView.backgroundColor = UIColor.clear
        
        //设置collectionView的代理和数据源
        collectionView.delegate = self
        collectionView.dataSource = self
        //CollectionViewCell的注册
        
        //        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCell")
        collectionView.register(UICollectionViewCell.self,
                                forCellWithReuseIdentifier: "ViewCell")
        
        dictView.addSubview(collectionView)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dictArr.count
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
        let dictModel:DictModel = dictArr[indexPath.item] as! DictModel
        lbl.text = dictModel.dictText
        lbl.font = UIFont.systemFont(ofSize: 12)
        //        print(areaModel["lon"] as Any)
        cell.backgroundColor = UIColor.white
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 10
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 200/255, green: 199/255, blue: 204/255, alpha: 0.5).cgColor
        cell.addSubview(lbl)
        if(dictValue != nil){
            if(dictValue == dictModel.dictCode){
                cell.backgroundColor = UIColor(red: 51/255, green: 145/255, blue: 252/255, alpha: 1)
            }
        }
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
        
        let dictModel:DictModel = dictArr[indexPath.item] as! DictModel
        dictValue = dictModel.dictCode
        dictLabel.text = dictModel.dictText
        bbchange?(dictModel.dictCode,dictModel.dictText)
        alertController.dismiss(animated: true, completion: nil)
//        self.areaLabel.text = areaModel.text
    }
}
