//
//  KivaLoanTableViewController.swift
//  KivaLoan
//
//  Created by Simon Ng on 4/10/2016.
//  Updated by Simon Ng on 6/12/2017.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit

class KivaLoanTableViewController: UITableViewController {

    private let kivaLoanURL = "https://api.kivaws.org/v1/loans/newest.json"
    
    private var loans = [Loan]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        getLastestLoans()
        
        tableView.estimatedRowHeight = 92.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loans.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! KivaLoanTableViewCell

        cell.nameLabel.text = loans[indexPath.row].name
        cell.countryLabel.text = loans[indexPath.row].country
        cell.useLabel.text = loans[indexPath.row].use
        cell.amountLabel.text = "$\(loans[indexPath.row].amount)"

        return cell
    }
    
    
    func getLastestLoans() {
        
        guard let loanUrl = URL(string: kivaLoanURL) else { return }
        
//        let request = URLRequest(url: loanUrl)
        let task = URLSession.shared.dataTask(with: loanUrl) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let data = data {

                
                self.loans = self.parseJsonData(data: data)

                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        }
        
        task.resume()
    }
    

    func parseJsonData(data: Data) -> [Loan] {
        var loansData = [Loan]()
        
        let decoder = JSONDecoder()

        do {
            
            let loanDataStore = try decoder.decode(LoanDataSource.self, from: data)
            loansData = loanDataStore.loans
            
        } catch {
            print (error)
        }

        return loansData
    }

}
