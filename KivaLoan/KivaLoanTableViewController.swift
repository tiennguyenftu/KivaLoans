//
//  KivaLoanTableViewController.swift
//  KivaLoan
//

import UIKit

class KivaLoanTableViewController: UITableViewController {
    
    let kivaLoadURL = "https://api.kivaws.org/v1/loans/newest.json"
    var loans = [Loan]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getLatestLoan()
    }
    
    func getLatestLoan() {
        let request = NSURLRequest(URL: NSURL(string: kivaLoadURL)!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            //Parse JSON data
            if let data = data {
                self.loans = self.parseJSONData(data)
                //Reload table view
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }
    
    func parseJSONData(data: NSData) -> [Loan] {

        do {
            let jsonResults = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
            //Parse JSON Data
            let jsonLoans = jsonResults?["loans"] as! [AnyObject]
            for jsonLoan in jsonLoans {
                let loan = Loan()
                loan.name = jsonLoan["name"] as! String
                loan.amount = jsonLoan["loan_amount"] as! Int
                loan.use = jsonLoan["use"] as! String
                let location = jsonLoan["location"] as! [String: AnyObject]
                loan.country = location["country"] as! String
                loans.append(loan)
            }
        } catch {
            print(error)
        }
        
        return loans
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return loans.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! KivaLoanTableViewCell

        let loan = loans[indexPath.row]
        cell.nameLabel.text = loan.name
        cell.countryLabel.text = loan.country
        cell.amountLabel.text = "$\(loan.amount)"
        cell.useLabel.text = loan.use

        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
