//
//  GameScene.swift
//  2D Oyun Calismasi
//
//  Created by Deniz Gülbahar on 26.04.2022.
//

import SpriteKit
import GameplayKit

enum CarpismaTipi:UInt32 {

    case anakarakter = 1
    case siyahkare = 2
    case saridaire = 3
    case kirmiziucgen = 4
}

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var anakarakter:SKSpriteNode = SKSpriteNode()
    var kirmiziucgen:SKSpriteNode = SKSpriteNode()
    var saridaire:SKSpriteNode = SKSpriteNode()
    var siyahkare:SKSpriteNode = SKSpriteNode()
    
    var skorLabel:SKLabelNode = SKLabelNode()
    
    var ViewController:UIViewController?
    
    var dokunmaKontrol = false
    
    var oyunBaslangicKontrol = false
    
    var sayici:Timer?
    
    var ekranGenisligi:Int?
    
    var ekranYuksekligi:Int?
    
    var toplamSkor = 0
   
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        
        ekranGenisligi = Int(self.size.width)
        
        ekranYuksekligi = Int(self.size.height)
        
        print("Ekran genişliği: \(ekranGenisligi!)")
        print("Ekran yüksekliği: \(ekranYuksekligi!)")
        
        if let tempKarakter = self.childNode(withName: "anakarakter") as? SKSpriteNode {
            
            anakarakter = tempKarakter
            
            anakarakter.physicsBody?.categoryBitMask = CarpismaTipi.anakarakter.rawValue
            
            anakarakter.physicsBody?.collisionBitMask = CarpismaTipi.siyahkare.rawValue | CarpismaTipi.saridaire.rawValue | CarpismaTipi.kirmiziucgen.rawValue
            
            anakarakter.physicsBody?.contactTestBitMask = CarpismaTipi.siyahkare.rawValue | CarpismaTipi.saridaire.rawValue | CarpismaTipi.kirmiziucgen.rawValue
        }
        if let tempKarakter = self.childNode(withName: "kirmiziucgen") as? SKSpriteNode {
            
            kirmiziucgen = tempKarakter
            
            kirmiziucgen.physicsBody?.categoryBitMask = CarpismaTipi.kirmiziucgen.rawValue
            kirmiziucgen.physicsBody?.collisionBitMask = CarpismaTipi.anakarakter.rawValue
            kirmiziucgen.physicsBody?.contactTestBitMask = CarpismaTipi.anakarakter.rawValue
        }
        if let tempKarakter = self.childNode(withName: "saridaire") as? SKSpriteNode {
            
            saridaire = tempKarakter
            
            saridaire.physicsBody?.categoryBitMask = CarpismaTipi.saridaire.rawValue
            saridaire.physicsBody?.collisionBitMask = CarpismaTipi.anakarakter.rawValue
            saridaire.physicsBody?.contactTestBitMask = CarpismaTipi.anakarakter.rawValue
        }
        if let tempKarakter = self.childNode(withName: "siyahkare") as? SKSpriteNode {
            
            siyahkare = tempKarakter
            
            siyahkare.physicsBody?.categoryBitMask = CarpismaTipi.siyahkare.rawValue
            siyahkare.physicsBody?.collisionBitMask = CarpismaTipi.anakarakter.rawValue
            siyahkare.physicsBody?.contactTestBitMask = CarpismaTipi.anakarakter.rawValue
        }
        
        if let tempKarakter = self.childNode(withName: "skorLabel") as? SKLabelNode {
            
            skorLabel = tempKarakter
            skorLabel.text = "Skor : 0"
        }
        
        sayici = Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(GameScene.hareket), userInfo: nil, repeats: true)
        
       
    }
    
    @objc func hareket () {
        
        if oyunBaslangicKontrol {
            
            let anakarakterhiz = CGFloat(ekranGenisligi!/30) //25
            let siyahkarehiz = CGFloat(ekranGenisligi!/150) // 5
            let kirmiziücgenhiz = CGFloat(ekranGenisligi!/250) // 3
            let saridairehiz = CGFloat(ekranGenisligi!/120) // 6
            
            if dokunmaKontrol {
                
                let yukariHareket:SKAction = SKAction.moveBy(x: 0, y: anakarakterhiz, duration: 1)
                
                anakarakter.run(yukariHareket)
                
                
            } else {
                
                let asagiHareket:SKAction = SKAction.moveBy(x: 0, y: -anakarakterhiz, duration: 1)
                
                anakarakter.run(asagiHareket)
            }
            
            cisimlerinSerbestHareketi(cisimAdi: siyahkare, cisimHizi: -siyahkarehiz)
            cisimlerinSerbestHareketi(cisimAdi: kirmiziucgen, cisimHizi: -kirmiziücgenhiz)
            cisimlerinSerbestHareketi(cisimAdi: saridaire, cisimHizi: -saridairehiz)
        }
    }
    
    func cisimlerinSerbestHareketi(cisimAdi:SKSpriteNode,cisimHizi:CGFloat) {
        
        if Int(cisimAdi.position.x) < 0 {
            
            cisimAdi.position.x = CGFloat(ekranGenisligi! + 20)
            cisimAdi.position.y = -CGFloat(arc4random_uniform(UInt32(ekranYuksekligi!)))
            
        } else {
            
            let solaHareket:SKAction = SKAction.moveBy(x: cisimHizi, y: 0, duration: 6)
            
            cisimAdi.run(solaHareket)
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
      //  print("Ekrana dokunuldu.")
        
       dokunmaKontrol = true
        
       oyunBaslangicKontrol = true
        
       //  self.ViewController?.performSegue(withIdentifier: "toSonuc", sender: nil)
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
      //  print("Ekran bırakıldı.")
        
        dokunmaKontrol = false
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
      //  print("Ekran üzerinde hareket etti.")
    }
    
    
    // Çarpışma Kontrolü
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == CarpismaTipi.anakarakter.rawValue &&
            contact.bodyB.categoryBitMask == CarpismaTipi.siyahkare.rawValue{
            
            print("Anakarakter siyahkareye çarptı.")
            
            sayici?.invalidate()
            
            let d = UserDefaults.standard
            
            d.set(toplamSkor, forKey: "anlikSkor")
            
            self.ViewController?.performSegue(withIdentifier: "toSonuc", sender: nil)
            
            
        }
        
        if contact.bodyB.categoryBitMask == CarpismaTipi.anakarakter.rawValue &&      contact.bodyA.categoryBitMask == CarpismaTipi.siyahkare.rawValue{
            
            print("Siyahkare anakaraktere çarptı.")
            
            sayici?.invalidate()
            
            let d = UserDefaults.standard
            
            d.set(toplamSkor, forKey: "anlikSkor")
            
            self.ViewController?.performSegue(withIdentifier: "toSonuc", sender: nil)
            
            
        }
        
        if contact.bodyA.categoryBitMask == CarpismaTipi.anakarakter.rawValue &&      contact.bodyB.categoryBitMask == CarpismaTipi.kirmiziucgen.rawValue{
            
            let basaAl:SKAction = SKAction.moveBy(x:CGFloat(ekranGenisligi! + 20), y: -CGFloat(arc4random_uniform(UInt32(ekranYuksekligi!))), duration: 0.02)
            kirmiziucgen.run(basaAl)
            
            toplamSkor = toplamSkor + 50
            skorLabel.text = " Skor : \(toplamSkor)"
            
        }
        
        if contact.bodyB.categoryBitMask == CarpismaTipi.anakarakter.rawValue &&      contact.bodyA.categoryBitMask == CarpismaTipi.kirmiziucgen.rawValue{
            
            let basaAl:SKAction = SKAction.moveBy(x:CGFloat(ekranGenisligi! + 20), y: -CGFloat(arc4random_uniform(UInt32(ekranYuksekligi!))), duration: 0.02)
            kirmiziucgen.run(basaAl)
            
            toplamSkor = toplamSkor + 50
            skorLabel.text = " Skor : \(toplamSkor)"
            
        }
        
        if contact.bodyA.categoryBitMask == CarpismaTipi.anakarakter.rawValue &&      contact.bodyB.categoryBitMask == CarpismaTipi.saridaire.rawValue{
            
            let basaAl:SKAction = SKAction.moveBy(x:CGFloat(ekranGenisligi! + 20), y: -CGFloat(arc4random_uniform(UInt32(ekranYuksekligi!))), duration: 0.02)
            saridaire.run(basaAl)
            
            toplamSkor = toplamSkor + 20
            skorLabel.text = " Skor : \(toplamSkor)"
        }
        
        if contact.bodyB.categoryBitMask == CarpismaTipi.anakarakter.rawValue &&      contact.bodyA.categoryBitMask == CarpismaTipi.saridaire.rawValue{
            
            let basaAl:SKAction = SKAction.moveBy(x:CGFloat(ekranGenisligi! + 20), y: -CGFloat(arc4random_uniform(UInt32(ekranYuksekligi!))), duration: 0.02)
            saridaire.run(basaAl)
            
            toplamSkor = toplamSkor + 20
            skorLabel.text = " Skor : \(toplamSkor)"
        }
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
