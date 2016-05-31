
import UIKit
import CoreData

class Secret2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var sentenceEntities: [Sentence]!

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
        filterTextField?.resignFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sentenceEntities = Sentence.MR_findAll() as? [Sentence]
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sentenceEntities = Sentence.MR_findAll() as? [Sentence]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func reload(sender: UIButton) {
        self.filterTextField.text = ""
        sentenceEntities = Sentence.MR_findAll() as? [Sentence]
        tableView.reloadData()
    }
    
    @IBAction func filter(sender: UIButton) {
        let sentenceFilter: NSPredicate = NSPredicate(format: "item CONTAINS[c] %@", filterTextField.text!)
        sentenceEntities = Sentence.MR_findAllWithPredicate(sentenceFilter) as? [Sentence]
        tableView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sentenceEntities.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Secret2Item") as UITableViewCell!
        cell.textLabel!.text = sentenceEntities[indexPath.row].item
        return cell
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            sentenceEntities.removeAtIndex(indexPath.row).MR_deleteEntity()
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let sentenceController = segue.destinationViewController as! SentenceViewController
        if segue.identifier == "edit" {
            let secret = sentenceEntities[tableView.indexPathForSelectedRow!.row]
            sentenceController.secret = secret
        }
        
    }
    
}

