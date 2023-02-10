//
//  TwoViewController.swift
//  Birthdays_1
//
//  Created by Артём Синявцев on 08.12.2022.
//

import UIKit

class NewContactController: UIViewController, UITextFieldDelegate {
    
    let dateCalendar = UIDatePicker()
    let imagePicker = UIImagePickerController()
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageAddImageView: UIImageView!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
       // imagePicker.delegate = self
        dateTextField.inputView = dateCalendar
        dateCalendar.datePickerMode = .date
        dateCalendar.preferredDatePickerStyle = .wheels
        imageAddImageView.layer.cornerRadius = 20
        // установка языка, который в настройках телефона
        let locateID = Locale.preferredLanguages.first
        dateCalendar.locale = Locale(identifier: locateID!)
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let rightDone = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([rightDone, doneButton], animated: true)
        
        dateTextField.inputAccessoryView = toolBar
        
        // Создаем экземпляр класса, для добавления фотографии
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapONImage(_ :)))
        imageAddImageView.addGestureRecognizer(tapGesture)
        imageAddImageView.isUserInteractionEnabled = true
        
    }
        // нужно написать функцию tapONImage в @objc
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
        getDateFromPicker()
        view.endEditing(true)
        
    }
    
    // функция формирования даты в нужном ФОРМАТЕ
    func getDateFromPicker() {
        let formattor = DateFormatter()
        formattor.dateFormat = "dd.MM.yyy"
        dateTextField.text = formattor.string(from: dateCalendar.date)
        
    }
    // MARK: - скрытие тектстового поля поля, после заполнения, по кнопке готово
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
        
    }
    
    // MARK: - добавление по КНОПКЕ нового объекта в массив
    @IBAction func addButtonAction(_ sender: UIButton) {
        let photoData = imageAddImageView?.image!.jpegData(compressionQuality: 0.5)
        let humanModel = HumanModel(birthdaysDate: dateTextField.text!, surnameName: nameTextField.text!, humanFoto: photoData)
        DataManager.shared.addModel(model: humanModel)
        navigationController?.popViewController(animated: true)
        
        //imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    
    }
    
}

extension NewContactController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let picketImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imageAddImageView.image = picketImage
        }
        dismiss(animated: true, completion: nil)
    }
}
