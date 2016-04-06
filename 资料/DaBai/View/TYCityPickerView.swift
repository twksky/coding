//
//  TYCityPickerView.swift
//  DaBai
//
//  Created by BaiTianWei on 15/6/1.
//  Copyright (c) 2015年 BaiTianWei. All rights reserved.
//

import UIKit

class TYCityPickerView: UIPickerView,UIPickerViewDataSource,UIPickerViewDelegate {
    
    private var provinces:NSArray!
    private var cities:NSArray!
    private var areas:NSArray!
    
    var province:String = ""
    var city:String = ""
    var area:String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setting()
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setting(){
        self.delegate = self
        self.dataSource = self
        
        self.provinces = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("area.plist", ofType: nil)!)
        self.cities = provinces.objectAtIndex(0).objectForKey("cities") as! NSArray
        self.areas = cities.objectAtIndex(0).objectForKey("areas") as! NSArray
        
        self.province = provinces.objectAtIndex(0).objectForKey("state") as! String
        self.city = cities.objectAtIndex(0).objectForKey("city") as! String
        if areas.count > 0 {
            self.area = areas.objectAtIndex(0) as! String
        }else {
            self.area = ""
        }
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return provinces.count
        case 1:
            return cities.count
        case 2:
            return areas.count
        default:
            return 0
        }
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        switch component {
        case 0:
            return provinces.objectAtIndex(row).objectForKey("state") as! String
        case 1:
            return cities.objectAtIndex(row).objectForKey("city") as! String
        case 2:
            if areas.count>0{
                return areas.objectAtIndex(row) as! String
            }else{
                return ""
            }
        default:
            return ""
        }
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            cities = provinces.objectAtIndex(row).objectForKey("cities") as! NSArray
            self.selectRow(0, inComponent: 1, animated: true)
            self.reloadComponent(1)
            areas = cities.objectAtIndex(0).objectForKey("areas") as! NSArray
            self.selectRow(0, inComponent: 2, animated: true)
            self.reloadComponent(2)
            
            self.province = provinces.objectAtIndex(row).objectForKey("state") as! String
            self.city = cities.objectAtIndex(0).objectForKey("city") as! String
            if areas.count > 0 {
                self.area = areas.objectAtIndex(0) as! String
            }else {
                self.area = ""
            }
            
        case 1:
            areas = cities.objectAtIndex(row).objectForKey("areas") as! NSArray
            self.selectRow(0, inComponent: 2, animated: true)
            self.reloadComponent(2)
            
            self.city = cities.objectAtIndex(row).objectForKey("city") as! String
            if areas.count > 0 {
                self.area = areas.objectAtIndex(0) as! String
            }else {
                self.area = ""
            }
            
        case 2:
            if areas.count > 0 {
                self.area = areas.objectAtIndex(row) as! String
            }else {
                self.area = ""
            }
        default:
            break
        }
    }
    
}
