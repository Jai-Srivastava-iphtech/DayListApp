import UIKit

class TaskDetailViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var dueDateButton: UIButton!

    // ✅ Task property to receive data
    var task: Task?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
        styleButtons()
    }

    private func setupUI() {
        titleTextField.delegate = self
        descriptionTextField.delegate = self

        titleTextField.returnKeyType = .next
        descriptionTextField.returnKeyType = .done
    }
    
    private func styleButtons() {
        // Style list button
        listButton.layer.borderWidth = 1.5
        listButton.layer.borderColor = UIColor.systemGray3.cgColor
        listButton.layer.cornerRadius = 8.0
        
        // Style due date button
        dueDateButton.layer.borderWidth = 1.5
        dueDateButton.layer.borderColor = UIColor.systemGray3.cgColor
        dueDateButton.layer.cornerRadius = 8.0
    }

    private func populateData() {
        guard let task = task else { return }

        titleTextField.text = task.title
        descriptionTextField.text = ""   // later can be stored
        listButton.setTitle(task.listName ?? "None", for: .normal)
        dueDateButton.setTitle(task.dateText ?? "No date", for: .normal)
    }

    // MARK: - Keyboard flow
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            descriptionTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    // MARK: - Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func saveTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @IBAction func deleteTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
