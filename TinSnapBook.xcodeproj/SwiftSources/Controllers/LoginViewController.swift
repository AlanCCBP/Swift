/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    var activityIndicator : UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Descomenta esta linea para probar que Parse funciona correctamente
        //self.testParseSave()

        /*let user = PFObject(className: "Users")

        user["name"] = "Alan"

        user.saveInBackground { (success, error) in

            if success {
                print("El usuario se ha guardado correctamente en Parse.")
            }
            else if error != nil {
                print(error!.localizedDescription)
            }
            else
            {
                print("Error desconocido.")
            }
        }*/

        let query = PFQuery(className: "Users")

        query.getObjectInBackground(withId: "Ft4c2LfZDB") { (object, error) in

            if error != nil {
                print(error!.localizedDescription)
            }
            else
            {
                if let user = object {
                    user["name"] = "Alan Carlos"
                    user.saveInBackground(block: { (success, error) in

                        if success {
                            print("Hemos modificado el usuario correctamente en Parse.")
                        }
                        else if error != nil {
                            print(error!.localizedDescription)
                        }
                        else
                        {
                            print("Error desconocido.")
                        }
                    })
                    print(user)
                    print("Nombre del usuario: \(user["name"]!).")
                }
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        self.navigationController?.navigationBar.isHidden = true
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "goToMainVC", sender: nil)
        }
    }
    
    /*func testParseSave() {
        let testObject = PFObject(className: "Prueba")
        testObject["name"] = "bar"
        testObject.saveInBackground { (success, error) -> Void in
            if success {
                print("El objeto se ha guardado en Parse correctamente.")
            } else {
                if error != nil {
                    print ("Ocurrió el siguiente error: \(error!)")
                } else {
                    print ("Error")
                }
            }
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func checkInfoCompleted () -> Bool {

        var completed = true

        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            completed = false
        }

        return completed
    }

    @IBAction func signUpPressed(_ sender: UIButton) {

        if checkInfoCompleted() {

            //Procedemos a registrar al usuario.

            self.startActivityIndicator()

            let user = PFUser()

            user.username = self.emailTextField.text
            user.email = self.emailTextField.text
            user.password = self.passwordTextField.text

            let acl = PFACL()

            acl.getPublicReadAccess = true
            acl.getPublicWriteAccess = true

            user.acl = acl

            user.signUpInBackground(block: { (success, error) in

                self.stopActivityIndicator()

                if error != nil {

                    var errorMessage = "Inténtalo de nuevo, ha ocurrido un error."

                    if let parseError = error?.localizedDescription {
                        errorMessage = parseError
                    }

                    self.createAlert(title: "Error de registro", message: errorMessage)
                }
                else
                {
                    print("Usuario registrado correctamente.")
                    self.performSegue(withIdentifier: "goToMainVC", sender: nil)
                }
            })
        }
    }

    func createAlert (title: String, message: String) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)

        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func signInPressed(_ sender: UIButton) {

        if checkInfoCompleted() {
            //Procedemos a logonear al usuario.

            self.startActivityIndicator()

            PFUser.logInWithUsername(inBackground: self.emailTextField.text!, password: self.passwordTextField.text!, block: { (user, error) in

                self.stopActivityIndicator()

                if error != nil {

                    var errorMessage = "Inténtalo de nuevo, ha ocurrido un error."

                    if let parseError = error?.localizedDescription {
                        errorMessage = parseError
                    }

                    self.createAlert(title: "Error de login", message: errorMessage)

                }
                else
                {
                    print("Hemos ingresado correctamente.")
                    self.performSegue(withIdentifier: "goToMainVC", sender: self)
                }
            })
        }
    }

    func startActivityIndicator() {

        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = .gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

    }

    func stopActivityIndicator() {

        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()

    }

    @IBAction func recoverPassword(_ sender: UIButton) {

        let alertController = UIAlertController(title: "Recuperar contraseña", message: "Introduce tu email de registro en TinSnapBook", preferredStyle: .alert)

        alertController.addTextField { (textField) in

            textField.placeholder = "ejemplo@dominio.com"

            let okAction = UIAlertAction(title: "Recuperar contraseña", style: .default, handler: { (action) in

                let theEmailTextField = alertController.textFields![0] as UITextField

                PFUser.requestPasswordResetForEmail(inBackground: theEmailTextField.text!, block: { (success, error) in

                    if error != nil {

                        var errorMessage = "Ha ocurrido un error al recuperar la contraseña."

                        if let parseError = error?.localizedDescription {
                            errorMessage = parseError
                        }

                        self.createAlert(title: "Error de recuperación de contraseña", message: errorMessage)

                    }
                    else
                    {
                        self.createAlert(title: "Contraseña recuperada", message: "Revisa tu bandeja de entrada de \(theEmailTextField.text!) y sigue las instrucciones.")
                    }
                })
            })

            let cancelAction = UIAlertAction(title: "Ahora no", style: .cancel, handler: nil)

            alertController.addAction(okAction)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension LoginViewController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
