
import UIKit

class SentenceViewController: UIViewController {

    @IBOutlet weak var sentenceField: UITextView!
    var secret: Sentence? = nil
    var result: String? = nil
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let secretSentence = secret {
            sentenceField.text = secretSentence.item
        }
        if let secretSentence = result {
            sentenceField.text = secretSentence
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard(sender: AnyObject) {
        sentenceField?.resignFirstResponder()
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        navigationController!.popViewControllerAnimated(true)
    }
    
    @IBAction func save(sender: UIBarButtonItem) {
        if secret != nil {
            editSentence()
        } else {
            createSentence()
        }
        navigationController!.popViewControllerAnimated(true)
    }
    
    func createSentence() {
        let newSentence: Sentence = Sentence.MR_createEntity() as Sentence
        newSentence.item = sentenceField.text
        newSentence.managedObjectContext!.MR_saveToPersistentStoreAndWait()
    }
    
    func editSentence() {
        secret?.item = sentenceField.text
        secret?.managedObjectContext!.MR_saveToPersistentStoreAndWait()
    }
}
