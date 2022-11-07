// ViewController.swift
// RXSwiftLearning
// Created by Mashhood Qadeer on 30/10/2022.

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    //For Labels
    @IBOutlet weak var label: UILabel!
    var labelObservable  = ReplaySubject<String>.create(bufferSize: 5)
    
    //For to avoid the subscription
    let disposebag : DisposeBag = DisposeBag()
    //End of avoiding the subscription
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.playWithRxSwift()
        self.setObserver()
    }
    
    func playWithRxSwift(){
        
        let helloSequence = Observable.from(["H","e","l","l","o"])
        let subscription = helloSequence.subscribe { event in
            switch event {
            case .next(let value):
                print(value)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        
        //For dispose bag
        subscription.disposed(by: self.disposebag)
    } //Played very well
    
    //This for setting the observer
    func setObserver(){
        
        //For another way of subscription
        self.labelObservable.observe(on: MainScheduler.instance).bind(to: self.label.rx.text)
            .disposed(by: self.disposebag)
        
//        End of another way of subscription
//        
//        Setting the subscription to it
                 self.labelObservable.subscribe { event in
        
                     switch event {
        
                     case .next( let value):
                         self.label.text = value as? String ?? ""
                         break
        
                     case .completed:
        
                         break
        
                     case .error( let error):
        
                         break
        
                     default:
                         break
        
                     }
        
        
                 }
        
                 self.labelObservable.disposed(by: self.disposebag)
    }
    //end of setting the observer
    
    //For Button Event
    var counter : Int = 0
    @IBAction func buttonPressed(_ sender: UIButton) {
        self.counter += 1
        self.labelObservable.onNext("Hello this \(self.counter)")
    }
    
    @IBAction func openSecondScreen(_ sender: Any) {
        
        let screen = ListingScreen(nibName: String(describing :ListingScreen.self), bundle: nil)
        screen.modalPresentationStyle = .fullScreen
        self.present(screen, animated: true)
        
    }
    
}
