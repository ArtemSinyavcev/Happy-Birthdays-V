//
//  DetailViewController.swift
//  Birthdays_1
//
//  Created by Артём Синявцев on 29.12.2022.
//

import UIKit
import Foundation
import UserNotifications

class DetailViewController: UIViewController {
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailDateTextLabel: UITextField!
    @IBOutlet weak var detailNameTextField: UITextField!
    @IBOutlet weak var detailReminderTextField: UITextField!
    
    let notificationCenterr = UNUserNotificationCenter.current()
    var datePicker = UIDatePicker()
    var selectedDate: Date?
    let imagePicker = UIImagePickerController()
    
    var detailImage: UIImage?
    var detailDate: String?
    var detailName: String?
    var detailReminder: String?
    
    var detailHumanPrototype: HumanModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailImageView.image = detailImage
        detailImageView.layer.cornerRadius = 20
        detailDateTextLabel.text = detailDate
        detailNameTextField.text = detailName
        
        schedulNotification()
        
        detailReminderTextField.inputView = datePicker
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.frame = .init(x: 0, y: 0, width: 0, height: 500)
        datePicker.backgroundColor = .systemGray6
        datePicker.tintColor = .black
        let locateID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: locateID!)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([flexSpace, doneButton], animated: true)
        detailReminderTextField.inputAccessoryView = toolBar
        
        datePicker.addTarget(self, action: #selector(dateChanget), for: .valueChanged)
        
        // Создаем экземпляр класса, для добавления ФОТОГРАФИИ
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapONImage(_ :)))
        detailImageView.addGestureRecognizer(tapGesture)
        detailImageView.isUserInteractionEnabled = true
        
    }
    
        // Для ВЫБОРА ДЕЙСТВИЯ с фото нужно написать функцию tapONImage в @objc
    @objc func tapONImage(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(title: "Изображение", message: nil, preferredStyle: .actionSheet)
        let actionFoto = UIAlertAction(title: "С фотогалереи", style: .default) { (alert) in
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "С камеры", style: .default) { (alert) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "Отмена", style: .cancel, handler:  nil)
        
        alert.addAction(actionFoto)
        alert.addAction(actionCamera)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
        
    // функция кнопки готово
    @objc func doneAction() {
        schedulNotification()
        view.endEditing(true)
    }
    
    // функция отображение данных c datePicker сразу в текстФильд
    @objc func dateChanget() {
        selectedDate = datePicker.date
        getDateFromPicker()
    }
    
    // функция формирования даты в нужном ФОРМАТЕ
    func getDateFromPicker() {
        let formattor = DateFormatter()
        formattor.dateFormat = "dd. MM. yyyy  HH:mm"
        detailReminderTextField.text = formattor.string(from: datePicker.date)
        
    }
    
    // MARK: - сохранение редактирования после нажатия на кнопку
   
    @IBAction func detailSaveButtonAction(_ sender: UIButton) {
    let photoData = detailImageView?.image!.jpegData(compressionQuality: 0.5)
        DataManager.shared.editingHuman(model: detailHumanPrototype!, name: detailNameTextField.text!, date: detailDateTextLabel.text!, foto: photoData, notification: detailReminderTextField.text!)
        let humanModel = HumanModel()
        humanModel.nitificationDate = detailReminderTextField.text
        navigationController?.popViewController(animated: true)
    }
        
    // MARK: - Запрос уведомления с определенным содержанием
    func schedulNotification() {
        
        let content  = UNMutableNotificationContent()
        content.title = "Новое уведомление"
        content.body = "Поздравить ФАМИЛИЯ"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        var triggerDate = DateComponents()
        triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: datePicker.date)
        if let year = triggerDate.year, let month = triggerDate.month, let day = triggerDate.day, let hour = triggerDate.hour, let minute = triggerDate.minute {
            print("year: \(year), month: \(month), day: \(day), hour: \(hour), minute: \(minute) ")
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        // запрос на уведомление
        let idenfication = "Local notification"
        let request = UNNotificationRequest(identifier: idenfication, content: content, trigger: trigger)
        notificationCenterr.add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
        
        let center = UNUserNotificationCenter.current()
        center.getDeliveredNotifications { (notifications) in
            for _ in notifications { center.removePendingNotificationRequests(withIdentifiers: [idenfication] )
                
            }
        }
    }
    
}

extension DetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picketImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            detailImageView.image = picketImage
        }
        dismiss(animated: true, completion: nil)
    }
}
