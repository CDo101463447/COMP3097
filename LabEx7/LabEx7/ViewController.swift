import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var timesTable: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    @IBAction func calculateTapped(_ sender: UIButton) {
        guard let text = numberTextField.text,
              let number = Int(text) else {
            print("Invalid number entered") // This prints to the Xcode console
            showInvalidNumberAlert() // Optionally display an alert to the user
            return
        }
        
        // If valid, generate the times table:
        timesTable = (1...10).map { $0 * number }
        tableView.reloadData()
    }

    func showInvalidNumberAlert() {
        let alert = UIAlertController(title: "Invalid Input",
                                      message: "Please enter a valid number.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }

    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timesTable.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row + 1) × \(numberTextField.text!) = \(timesTable[indexPath.row])"
        return cell
    }
}
