//
//  ViewController.swift
//  Birthdays_1
//
//  Created by Артём Синявцев on 06.12.2022.
//
import RealmSwift
import UIKit

class ViewController: UIViewController {
    
    //let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    let idTable = "iDTable"
    var poisk = UISearchController()
    let notificationCenterr = UNUserNotificationCenter.current()
    var selectedDate: Date?
    
    @IBOutlet weak var tableView: UITableView!
  
    @IBAction func addNewContactController(_ sender: UIBarButtonItem) {
        
        let newContactController = storyboard?.instantiateViewController(withIdentifier: "NewContactController")
        navigationController?.pushViewController(newContactController!, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // добавление БОЛЬШОГО Navigation Bar
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        // добавление СТРОКИ ПОИСКА, расширяем класс через extension(ниже) и создаем переменную (выше)
        let poisk = UISearchController(searchResultsController: nil)
        poisk.searchResultsUpdater = self
        self.navigationItem.searchController = poisk
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        tableView.reloadData()
        
    }
    
    // MARK: -  Свайп справа. Удаление сообщения
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "delete") {
            (action, view, success) in
            let array = DataManager.shared.getAllHumans()
            let deleteHuman = array[indexPath.row]
            DataManager.shared.removeHuman(model: deleteHuman)
            tableView.reloadData()
            
        }
        
        delete.backgroundColor = .red
        delete.image = UIImage(named: "delete")
        return UISwipeActionsConfiguration(actions: [delete])

    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.getAllHumans().count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: idTable) as! OneTableCell
        let array = DataManager.shared.getAllHumans()
        let human = array[indexPath.row]
        cell.dateTableLabel.text = human.birthdaysDate
        cell.nameTableLabel.text = human.surnameName
        cell.fotoTableImageView.image = UIImage(data: human.humanFoto!)
        cell.fotoTableImageView.layer.cornerRadius = 20
        cell.backgroundColor = .systemGray6
        cell.textLabel?.text = String(indexPath.item + 1)
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        return cell
        
    }
    
    //MARK: -  Сообщает делегату, что строка выбрана
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let green = storyboard.instantiateViewController(withIdentifier: "DetailViewControlller") as? DetailViewController {
            let array = DataManager.shared.getAllHumans()
            let human = array[indexPath.row]
            green.detailName = human.surnameName
            green.detailDate = human.birthdaysDate
            green.detailImage = UIImage(data: human.humanFoto!)
            show(green, sender: nil)
        }
        
        
    }
    
    // ВЫСОТА ЯЧЕЙКИ (heightForRowAt)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
        
    }
    
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        print(searchController.searchBar.text as Any)
    }
    
}

