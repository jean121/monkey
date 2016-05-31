
import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var keywordField: UITextField!
    @IBOutlet weak var resultView: UITableView!
    var results: NSArray = []
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
        keywordField?.resignFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func search(sender: UIButton) {
        // POSTで送信したい情報をセット
        let keyword = keywordField.text as String!
        let str = "data=\(keyword)"
        let strData:NSData? = str.dataUsingEncoding(NSUTF8StringEncoding)
        
        // 通信先
        let url: NSURL = NSURL(string: "http://ec2-54-64-169-162.ap-northeast-1.compute.amazonaws.com/secret/search.php")!
        // POST用のリクエストを生成
        let myRequest:NSMutableURLRequest = NSMutableURLRequest(URL: url)

        myRequest.HTTPMethod = "POST"
        myRequest.HTTPBody = strData
        
        NSURLConnection.sendAsynchronousRequest(myRequest, queue: NSOperationQueue.mainQueue(), completionHandler: self.getHttp)
    }

    func getHttp(res:NSURLResponse?, data:NSData?, error:NSError?){
        let myData:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        results = myData.componentsSeparatedByString("|")
        resultView.reloadData()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ResultItem", forIndexPath: indexPath)
        cell.textLabel!.text = "\(results[indexPath.row])"
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "saveResult" {
            let sentenceController = segue.destinationViewController as! SentenceViewController
            let secret = results[resultView.indexPathForSelectedRow!.row]
            sentenceController.result = secret as! String
        }
    }
}
