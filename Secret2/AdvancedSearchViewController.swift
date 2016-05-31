
import UIKit

class AdvancedSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var workField: UITextField!
    @IBOutlet weak var favoriteField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var resultView: UITableView!
    var results: [AnyObject] = []
    var keyboardDismissTapGesture: UIGestureRecognizer?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillShow:"),
            name: UIKeyboardWillShowNotification,
            object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: Selector("keyboardWillHide:"),
            name: UIKeyboardWillHideNotification,
            object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        
        super.viewWillDisappear(animated)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if keyboardDismissTapGesture == nil
        {
            keyboardDismissTapGesture = UITapGestureRecognizer(target: self,
                action: Selector("dismissKeyboard:"))
            self.view.addGestureRecognizer(keyboardDismissTapGesture!)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if keyboardDismissTapGesture != nil
        {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture!)
            keyboardDismissTapGesture = nil
        }
    }
    
    func dismissKeyboard(sender: AnyObject) {
        cityField?.resignFirstResponder()
        ageField?.resignFirstResponder()
        genderField?.resignFirstResponder()
        workField?.resignFirstResponder()
        favoriteField?.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func advancedSearch(sender: AnyObject) {
        let city = cityField.text as String!
        let age = ageField.text as String!
        let gender = genderField.text as String!
        let work = workField.text as String!
        let favorite = favoriteField.text as String!
        
        if !city.isEmpty {
            let words:NSArray = getArrayForCity()
            for word in words {
                let str = (word as! NSString).stringByReplacingOccurrencesOfString("___TEST___", withString: city)
                results.append(str)
            }
        }

        if !favorite.isEmpty {
            let words:NSArray = getArrayForFavorite()
            for word in words {
                let str = (word as! NSString).stringByReplacingOccurrencesOfString("___TEST___", withString: favorite)
                results.append(str)
            }
        }

        resultView.reloadData()

    }
    
    func getArrayForCity() -> NSArray {
        return ["Which point do you think the most greatest is in ___TEST___ ?",
                "When do you think ___TEST___ changed your life ?",
                "Do you think you would like to raise your children in ___TEST___ ?"]
        
    }

    func getArrayForFavorite() -> NSArray {
        return ["What made you to do ___TEST___ ?",
            "When did you start ___TEST___ ?",
            "What should I do to start ___TEST___ at first ?"]
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchResultItem", forIndexPath: indexPath)
        cell.textLabel!.text = "\(results[indexPath.row])"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveSearchResult" {
            let sentenceController = segue.destinationViewController as! SentenceViewController
            let secret = results[resultView.indexPathForSelectedRow!.row]
            sentenceController.result = secret as! String
        }
    }
    
    

    @IBAction func clear(sender: UIButton) {
        cityField.text = ""
        ageField.text = ""
        genderField.text = ""
        workField.text = ""
        favoriteField.text = ""
        results = []
        resultView.reloadData()
    }
}
