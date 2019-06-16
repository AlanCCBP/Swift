//
//  AboutUsViewController.swift
//  Places
//
//  Created by Alan Nevot on 3/9/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit
import SafariServices

class AboutUsViewController: UITableViewController {

    let sections = [ "Dejar valoración", "Síguenos en las redes sociales" ]
    let sectionContent = [["Valorar en el AppStore", "Déjanos tu feedback" ], ["Facebook", "Twitter", "Instagram"]]
    let sectionLinks = [["", ""], ["https://facebook.com/KombiWorldArgentina", "https://twitter.com/KombiWorldArgentina", "https://instagram.com/KombiWorldArgentina"]]


    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        return self.sectionContent[section].count

    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUsCell", for: indexPath)

        // Configure the cell...

        let cellContent = self.sectionContent[indexPath.section][indexPath.row]

        cell.textLabel?.text = cellContent

        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return self.sections[section]

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if let appStoreUrl = URL(string: self.sectionLinks[indexPath.section][indexPath.row]) {

                    let app = UIApplication.shared

                    if app.canOpenURL(appStoreUrl) {

                        app.open(appStoreUrl, options: [:], completionHandler: nil)
                    }
                }
            case 1:
                performSegue(withIdentifier: "ShowWebView", sender: self.sectionLinks[0][1])
            default:
                break
            }
        case 1:
            //Redes sociales
            if let url = URL(string: self.sectionLinks[indexPath.section][indexPath.row]) {

                let safariViewController = SFSafariViewController(url: url, entersReaderIfAvailable: true)

                present(safariViewController, animated: true, completion: nil)

            }
        default:
            break
        }

        self.tableView.deselectRow(at: indexPath, animated: true)

    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

        if segue.identifier == "ShowWebView" {

            let destinationVC = segue.destination as! WebViewViewController

            destinationVC.urlName = sender as! String

        }
    }
}
