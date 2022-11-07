//ListingScreen.swift
//RXSwiftLearning
//Created by Mashhood Qadeer on 30/10/2022.

import UIKit
import RxSwift
import RxCocoa

class ListingScreen: UIViewController {
    
    //For disposebag
    var disposebag : DisposeBag = DisposeBag()
    
    //For listView
    @IBOutlet weak var tableViewList: UITableView!
    var viewModel : ToDoViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = ToDoViewModel(tableView: self.tableViewList)
        self.tableViewList!.rx.setDelegate(self).disposed(by: self.disposebag)
        self.viewModel!.generateFakeData()
        
        //For ReplySubjects
        self.replySubject()
        //End of ReplySubjects
        
    }
    
    //For Add Item Button
    @IBAction func addItemButton(_ sender: UIButton) {
        self.viewModel.appendOneMoreItem()
    }
    
    @IBAction func backNow(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    //To learn the reply subject
    func replySubject(){
        
        let replaySub = ReplaySubject<String>.create(bufferSize: 4)
        replaySub.on(.next("(pre) Event 1"))
        replaySub.on(.next("(pre) Event 2"))
        replaySub.on(.next("(pre) Event 3"))
        replaySub.on(.next("(pre) Event 4"))
        replaySub.on(.next("(pre) Event 5")) //5 events overfills the buffer
        replaySub.subscribe({ //replays the 4 events in memory (2-5)
            print("line: \(#line)", "event: \($0)")
        })
        .disposed(by: self.disposebag)
        3
    }
    //End of reply subject
    
    
}

//MARK: For tableView Delegate
extension ListingScreen : UITableViewDelegate {
    
    
}

//For Model
struct ToDoModel {
    
    var name : String
    var phone : String
    
    init( name: String, phone : String ){
        self.name = name
        self.phone = phone
    }
    
}

//For View Model Class
class ToDoViewModel {
    
    var dataObserver : ReplaySubject<[TodoDataType]>!
    var disposebag: DisposeBag!
    var list : [TodoDataType] = [] {
        didSet {
            self.dataObserver.onNext(self.list)
        }
    }
    weak var tableView : UITableView?
    
    init( tableView : UITableView){
        self.tableView = tableView
        self.dataObserver = ReplaySubject<[TodoDataType]>.create(bufferSize: 5)
        self.disposebag = DisposeBag()
        self.bindView()
    }
    
    //To bind the view to RxDelegate
    func bindView(){
        self.tableView?.register( UINib( nibName: String(describing: ListItemTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ListItemTableViewCell.self))
        self.dataObserver.bind(to: self.tableView!.rx.items(
            cellIdentifier: String(describing: ListItemTableViewCell.self),
            cellType: UITableViewCell.self)){  row, element, cell in
                
                switch element {
                    
                case .DATAITEM(let item):
                    (cell as! ListItemTableViewCell).configLayout(model:item )
                    break;
                    
                default:
                    break;
                    
                }
                
            }.disposed(by: self.disposebag)
        self.dataObserver.disposed(by: self.disposebag)
    }
    //End of binding the view to RxDelegate
    
    
    //Generate fake data
    func generateFakeData(){
        for i in 0...50 {
            let item = ToDoModel( name: "Name \(i)", phone: "Phone number \(i)")
            list.append( TodoDataType.DATAITEM(item) )
        }
    }
    //End of generating fake data
    
    //To append one more item
    func appendOneMoreItem(){
        self.list.append(TodoDataType.DATAITEM(ToDoModel(name: "Name \(self.list.count)", phone: "")))
    }
    //End of appending one more item
    
}

enum TodoDataType {
    case EMPTY
    case DATAITEM(ToDoModel)
}
