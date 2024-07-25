//
//  ProfileViewController.swift
//  DemoEditMode
//
//  Created by Nik Dub on 24.07.2024.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var nameTextField: PaddedTextField!
    @IBOutlet private weak var genderTextField: PaddedTextField!
    @IBOutlet private weak var dateOfBirthTextField: PaddedTextField!
    @IBOutlet private weak var phoneTextField: PaddedTextField!
    @IBOutlet private weak var emailTextField: PaddedTextField!
    @IBOutlet private weak var usernameTextField: PaddedTextField!
    @IBOutlet private weak var saveButton: UIButton!
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet var textFields: [PaddedTextField]!
    
    // MARK: - Private properties -
    
    private let viewModel: ProfileViewModel = ProfileViewModelImpl()
    private let genderList = ["Male", "Female"]
    private let debouncer = Debouncer()
    private var datePicker: UIDatePicker!
    private var genderPicker: UIPickerView!
    
    // MARK: - Lifecycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    // MARK: - Private methods -
    
    private func initialSetup() {
        setupUI()
        setupGenderPicker()
        setupBirthdayPicker()
    }
    
    private func setupUI() {
        profileImageButton.addTarget(
            self,
            action: #selector(profileImageTapped),
            for: .touchUpInside
        )
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.borderColor = UIColor.lightGray.cgColor
        textFields.forEach {
            $0.delegate = self
        }
        saveButton.addTarget(
            self,
            action: #selector(saveButtonTapped),
            for: .touchUpInside
        )
        saveButton.layer.cornerRadius = 15
        textFields.forEach {
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
        }
        updateUI()
    }
    
    private func updateUI() {
        let user = viewModel.getSavedUser()
        profileImageView.image = UIImage(data: user.image)
        nameLabel.text = user.fullname
        usernameLabel.text = "@" + user.username
        nameTextField.text = user.fullname
        genderTextField.text = user.gender
        dateOfBirthTextField.text = user.birthday
        phoneTextField.text = user.phoneNumber
        emailTextField.text = user.email
        usernameTextField.text = user.username
    }
    
    private func setupBirthdayPicker() {
        let picker = UIDatePicker(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.bounds.size.width,
                height: 200
            )
        )
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        picker.maximumDate = Calendar.current.date(
            byAdding: .year,
            value: -18,
            to: Date()
        )
        picker.minimumDate = Calendar.current.date(
            byAdding: .year,
            value: -100, to: Date()
        )
        picker.addTarget(
            self,
            action: #selector(birthdayPicked(_:)),
            for: .valueChanged)
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(datePickerDone)
        )
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        viewModel.didPickedOptionFor(
            .birthday,
            value: picker.date.asString()
        )
        datePicker = picker
        dateOfBirthTextField.inputAccessoryView = toolBar
        dateOfBirthTextField.inputView = datePicker
        dateOfBirthTextField.text = picker.maximumDate?.asString()
    }
    
    private func setupGenderPicker() {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(dismissAction)
        )
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        picker.selectRow(
            .zero,
            inComponent: .zero,
            animated: false
        )
        viewModel.didPickedOptionFor(
            .gender,
            value: genderList[.zero]
        )
        genderPicker = picker
        genderTextField.inputAccessoryView = toolBar
        genderTextField.inputView = genderPicker
        genderTextField.text = genderList[.zero]
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(
            title: "Success",
            message: "All fields are completely saved",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Done", style: .default)
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    private func textFieldValueChanged(_ textField: UITextField) {
        switch textField {
        case nameTextField:
            viewModel.didPickedOptionFor(.fullname, value: textField.text ?? "")
        case genderTextField:
            viewModel.didPickedOptionFor(.gender, value: textField.text ?? "")
        case dateOfBirthTextField:
            viewModel.didPickedOptionFor(.birthday, value: textField.text ?? "")
        case phoneTextField:
            viewModel.didPickedOptionFor(.phoneNumber, value: textField.text ?? "")
        case emailTextField:
            viewModel.didPickedOptionFor(.email, value: textField.text ?? "")
        case usernameTextField:
            viewModel.didPickedOptionFor(.username, value: textField.text ?? "")
        default: break
        }
    }
    
    // MARK: - Actions -
    
    @objc private func birthdayPicked(_ sender: UIDatePicker) {
        debouncer.debounce { [unowned self] in
            let newDate = sender.date.asString()
            dateOfBirthTextField.text = newDate
            viewModel.didPickedOptionFor(.birthday, value: newDate)
        }
    }
    
    @objc private func datePickerDone() {
        dateOfBirthTextField.resignFirstResponder()
    }
    
    @objc private func dismissAction() {
        genderTextField.resignFirstResponder()
    }
    
    @objc private func profileImageTapped() {
        let photoPicker = PhotoPickerViewController()
        photoPicker.onSelect = { imageData in
            self.profileImageView.image = UIImage(data: imageData)
            self.viewModel.didPickedImage(imageData)
        }
        present(photoPicker, animated: true)
    }
    
    @objc private func saveButtonTapped() {
        let errorFields = viewModel.validateAndSave()
        nameTextField.layer.borderColor = errorFields.contains { $0 == .fullname }
        ? UIColor.red.cgColor
        : UIColor.lightGray.cgColor
        genderTextField.layer.borderColor = errorFields.contains { $0 == .gender }
        ? UIColor.red.cgColor
        : UIColor.lightGray.cgColor
        dateOfBirthTextField.layer.borderColor = errorFields.contains { $0 == .birthday }
        ? UIColor.red.cgColor
        : UIColor.lightGray.cgColor
        phoneTextField.layer.borderColor = errorFields.contains { $0 == .phoneNumber }
        ? UIColor.red.cgColor
        : UIColor.lightGray.cgColor
        emailTextField.layer.borderColor = errorFields.contains { $0 == .email }
        ? UIColor.red.cgColor
        : UIColor.lightGray.cgColor
        usernameTextField.layer.borderColor = errorFields.contains { $0 == .username }
        ? UIColor.red.cgColor
        : UIColor.lightGray.cgColor
        if errorFields.isEmpty {
            updateUI()
            showSuccessAlert()
        }
    }
}

// MARK: - Extensions -

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        debouncer.debounce { [unowned self] in
            textFieldValueChanged(textField)
        }
    }
}

extension ProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        viewModel.didPickedOptionFor(.gender, value: genderList[row])
        genderTextField.text = genderList[row]
    }
    
    func numberOfComponents(
        in pickerView: UIPickerView
    ) -> Int {
        return 1
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return genderList.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return genderList[row]
    }
}
