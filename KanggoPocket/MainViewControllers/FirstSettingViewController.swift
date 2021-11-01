//
//  FirstSettingViewController.swift
//  KanggoPocket
//
//  Created by 최명근 on 2017. 10. 6..
//  Copyright © 2017년 RiDsoft. All rights reserved.
//

import UIKit

class FirstSettingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var txtFldName: UITextField!
    @IBOutlet weak var switchTeacher: UISwitch!
    @IBOutlet weak var pickerStdNum: UIPickerView!
    @IBOutlet weak var txtInfoCheck: UILabel!
    
//    let grades = [1, 2, 3]
//    let classes = [1, 2, 3, 4, 5, 6, 7, 8, 9]
//    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
//        11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
//        21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
//        31, 32, 33, 34, 35, 36, 37, 38, 39, 40]
    
    let pickerData = [[1, 2, 3],
                      [1, 2, 3, 4, 5, 6, 7, 8, 9],
                      [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
                       11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
                       21, 22, 23, 24, 25, 26, 27, 28, 29, 30,
                       31, 32, 33, 34, 35, 36, 37, 38, 39, 40]]
    
    let pickerString = [["1학년", "2학년", "3학년"],
                       ["1반", "2반", "3반", "4반", "5반", "6반", "7반", "8반", "9반"],
                       ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
                        "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                        "21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
                        "31", "32", "33", "34", "35", "36", "37", "38", "39", "40"]]
    
    let userDefault = UserDefaults(suiteName: "group.KanggoPocket")!
    var name: String = ""
    var grade: Int = 0
    var classNum: Int = 0
    var stdNum: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerStdNum.dataSource = self
        pickerStdNum.delegate = self
        txtFldName.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerString[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
    }
    
    func updateLabel() {
        grade = pickerData[0][pickerStdNum.selectedRow(inComponent: 0)]
        classNum = pickerData[1][pickerStdNum.selectedRow(inComponent: 1)]
        stdNum = pickerData[2][pickerStdNum.selectedRow(inComponent: 2)]
        var stdNumString: String?
        if stdNum < 10 {
            stdNumString = String(grade) + String(classNum) + "0" + String(stdNum)
        } else {
            stdNumString = String(grade) + String(classNum) + String(stdNum)
        }
        if name != "" {
            txtInfoCheck.text = stdNumString! + ", " + name + " " + NSLocalizedString("first_setting_student", comment: "first_setting_stduent")
        } else {
            txtInfoCheck.text = stdNumString!
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(self.txtFldName) {
            self.txtFldName.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func btnWebLink(_ sender: UIButton) {
        if let url = URL(string: "http://ridsoft.xyz/basic_policy.html") {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func switchTeacher(_ sender: UISwitch) {
        if sender.isOn {
            if name != "" {
                txtInfoCheck.text = name + NSLocalizedString("first_setting_teacher", comment: "first_setting_teacher")
            }
            pickerStdNum.isHidden = true
        } else {
            txtInfoCheck.text = NSLocalizedString("first_setting_input_all_info", comment: "first_setting_input_all_info")
            pickerStdNum.isHidden = false
        }
    }
    
    @IBAction func txtFldNameTyped(_ sender: UITextField) {
        name = txtFldName.text!
        updateLabel()
    }
    
    @IBAction func btnComplete(_ sender: UIButton) {
        // 선생님 로그인일 경우 학년, 반, 번은 0으로 고정
        name = txtFldName.text!
        if checkInfoValid() {
            checkInfoToUser()
        }
    }
    
    func checkInfoValid() -> Bool {
        if switchTeacher.isOn {
            return checkTeacherInfoValid()
        }
        if name == "" {
            showAlert(title: NSLocalizedString("first_setting_alert_empty", comment: "first_setting_alert_empty"), msg: NSLocalizedString("first_setting_alert_empty_msg", comment: "first_setting_alert_empty_msg"), handler: nil)
            return false
        }
        if name.count < 2 || name.count > 4 {
            showAlert(title: NSLocalizedString("first_setting_alert_name", comment: "first_setting_alert_name"), msg: NSLocalizedString("first_setting_alert_name_msg", comment: "first_setting_alert_name_msg"), handler: nil)
            return false
        }
        if grade == 0 || classNum == 0 || stdNum == 0 {
            showAlert(title: NSLocalizedString("first_setting_alert_stdnum", comment: "first_setting_alert_stdnum"), msg: NSLocalizedString("first_setting_alert_stdnum_msg", comment: "first_setting_alert_stdnum_msg"), handler: nil)
            return false
        }
        return true
    }
    
    func checkTeacherInfoValid() -> Bool {
        if name == "" {
            showAlert(title: NSLocalizedString("first_setting_alert_empty", comment: "first_setting_alert_empty"), msg: NSLocalizedString("first_setting_alert_empty_msg", comment: "first_setting_alert_empty_msg"), handler: nil)
            return false
        }
        if (name.count) < 2 || (name.count) > 4 {
            showAlert(title: NSLocalizedString("first_setting_alert_name", comment: "first_setting_alert_name"), msg: NSLocalizedString("first_setting_alert_name_msg", comment: "first_setting_alert_name_msg"), handler: nil)
            return false
        }
        return true
    }
    
    func checkInfoToUser() {
        let title = NSLocalizedString("first_setting_alert_check", comment: "first_setting_alert_check")
        var msg = NSLocalizedString("first_setting_alert_check_msg", comment: "first_setting_alert_check_msg")
        if switchTeacher.isOn {
            msg += name + NSLocalizedString("first_setting_teacher", comment: "first_setting_teacher")
        } else {
            msg += "\(String(describing: grade))학년 \(String(describing: classNum))반 \(String(describing: stdNum))번 \(String(describing: name)) 학생"
        }
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        let confirmAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: { (action) -> Void in
            self.saveUserInfo(isTeacher: self.switchTeacher.isOn)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: "cancel"), style: .cancel, handler: { (action) -> Void in
            
        })
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        setActionSheet(alertController, barButton: nil)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setActionSheet(_ alert: UIAlertController, barButton: UIBarButtonItem?) {
        if let barButton = barButton {
            if let popoverController = alert.popoverPresentationController {
                popoverController.barButtonItem = barButton
            }
        } else {
            if let popoverController = alert.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
    }
    
    func showAlert(title: String, msg: String, handler: ((UIAlertAction) -> Swift.Void)?) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: NSLocalizedString("confirm", comment: "confirm"), style: .default, handler: handler)
        alertController.addAction(defaultAction)
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveUserInfo(isTeacher: Bool) {
        userDefault.set(isTeacher, forKey: UserDefaultsKeys().BOOL_TEACHER)
        userDefault.set(name, forKey: UserDefaultsKeys().STRING_NAME)
        // 선생님이면 학번을 0000으로 고정
        if isTeacher {
            grade = 0
            classNum = 0
            stdNum = 0
        }
        userDefault.set(grade, forKey: UserDefaultsKeys().INT_GRADE)
        userDefault.set(classNum, forKey: UserDefaultsKeys().INT_CLASS)
        userDefault.set(stdNum, forKey: UserDefaultsKeys().INT_NUMBER)
        
        let ud = UserDefaults.standard
        ud.set(false, forKey: UserDefaultsKeys().BOOL_IS_FIRST)
        
        userDefault.synchronize()
        ud.synchronize()
        
        self.dismiss(animated: true, completion: nil)
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
