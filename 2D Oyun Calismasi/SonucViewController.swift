//
//  SonucViewController.swift
//  2D Oyun Calismasi
//
//  Created by Deniz Gülbahar on 26.04.2022.
//

import UIKit

class SonucViewController: UIViewController {

    
    
    @IBOutlet weak var skorLabel: UILabel!
    @IBOutlet weak var enYuksekSkor: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let d = UserDefaults.standard
        
        let anlikSkor = d.integer(forKey: "anlikSkor")
        let yuksekSkor = d.integer(forKey: "yuksekSkor")
    
        skorLabel.text =  "\(anlikSkor)"
        
        if anlikSkor > yuksekSkor  {
        
            d.set(anlikSkor, forKey: "yuksekSkor")
            enYuksekSkor.text =  "\(anlikSkor)"
            
        } else {
            
            enYuksekSkor.text = "\(yuksekSkor)"
            
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    @IBAction func tekrarOyna(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
   
}
