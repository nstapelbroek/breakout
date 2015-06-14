//
//  SettingsTableViewController.swift
//  Breakout
//
//  Created by Mad Nico on 18/05/15.
//  Copyright (c) 2015 HAN ICA. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    private let settings = BreakoutSettings.load()

    @IBOutlet weak var paddleWidthSlider: UISlider!
    @IBOutlet weak var ballWidthSlider: UISlider!
    @IBOutlet weak var ballSpeedSlider: UISlider!
    @IBOutlet weak var numberOfBallsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var selectedThemeSegmentedControl: UISegmentedControl!
    //Gets or sets the number of balls. The selectedSegmentIndex is offset due to index 0 meaning 1 ball.
    var numberOfBalls: Int {
        get {
            return numberOfBallsSegmentedControl.selectedSegmentIndex + 1
        }
        set {
            numberOfBallsSegmentedControl.selectedSegmentIndex = newValue - 1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        paddleWidthSlider.setValue(settings.paddleWidth!, animated: false)
        ballWidthSlider.setValue(settings.ballWidth!, animated: false)
        ballSpeedSlider.setValue(settings.ballSpeed!, animated: false)
        numberOfBalls = settings.numberOfBalls!
        selectedThemeSegmentedControl.selectedSegmentIndex = BreakoutThemeManager.getThemeIndex(settings.selectedTheme!.dynamicType.Name)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        settings.paddleWidth = paddleWidthSlider.value
        settings.ballWidth = ballWidthSlider.value
        settings.ballSpeed = ballSpeedSlider.value
        settings.numberOfBalls = numberOfBalls
        settings.selectedTheme = BreakoutThemeManager.getThemeInstance(selectedThemeSegmentedControl.selectedSegmentIndex)
        settings.save()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 5
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
