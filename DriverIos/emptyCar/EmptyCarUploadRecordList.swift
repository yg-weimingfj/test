//
//  EmptyCarUploadRecordList.swift
//  DriverIos
//  空车最新列表
//  Created by my on 2016/12/28.
//  Copyright © 2016年 weiming. All rights reserved.
//

import UIKit

class EmptyCarUploadRecordList: UIViewController {
    
    @IBOutlet weak var emptyShareImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let shareAction = UITapGestureRecognizer(target: self, action: #selector(shareEmptyCar))
        emptyShareImageView.addGestureRecognizer(shareAction)
        emptyShareImageView.isUserInteractionEnabled = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func back(_ sender: Any) {
         self.dismiss(animated: true, completion: nil)
    }

    @IBAction func editEmptyCarRecord(_ sender: Any) {
        let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "editEmtpyCarRecordView") as! EditEmtpyCarRecordView
        self.present(vc, animated: true, completion: nil)
    }
    func shareEmptyCar(){
        print(12)
        let sb = UIStoryboard(name: "emptyCarUpload", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "shareEmptyCarView") as! ShareEmptyCarView
        self.present(vc, animated: true, completion: nil)
    }

}
