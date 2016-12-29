//
//  EmptyCarUploadRecordList.swift
//  DriverIos
//
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
        // Do any additional setup after loading the view.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
