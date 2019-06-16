//
//  ReviewViewController.swift
//  Mis recetas
//
//  Created by Alan Nevot on 13/8/17.
//  Copyright © 2017 Alan Nevot. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var ratingStackView: UIStackView!

    @IBOutlet var firstButton: UIButton!
    @IBOutlet var secondButton: UIButton!
    @IBOutlet var thirdButton: UIButton!

    var ratingSelected : String?


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)

        blurEffectView.frame = view.bounds

        backgroundImageView.addSubview(blurEffectView)

        let scale = CGAffineTransform(scaleX: 0.0, y: 0.0)
        let traslation = CGAffineTransform(translationX: 0.0, y: 500.0)

        //ratingStackView.transform = scale.concatenating(traslation) //Escalado combinado con traslación.
        firstButton.transform = scale.concatenating(traslation)
        secondButton.transform = scale.concatenating(traslation)
        thirdButton.transform = scale.concatenating(traslation)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        /*UIView.animate(withDuration: 0.5, delay: 0.0, options: [], animations: {

            self.ratingStackView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        }, completion: nil)*/

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: { 

            self.firstButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

        }, completion: {(success) in
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {

                self.secondButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            }, completion: {(success) in
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {

                    self.thirdButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

                }, completion: nil
            )})
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func ratingPressed(_ sender: UIButton) {

        switch sender.tag {
        case 1:
            ratingSelected = "dislike"
        case 2:
            ratingSelected = "good"
        case 3:
            ratingSelected = "great"
        default:
            break
        }

        performSegue(withIdentifier: "unwindToDetailView", sender: sender)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
