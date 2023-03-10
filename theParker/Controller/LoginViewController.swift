import Foundation
import UIKit
import Firebase
import EZYGradientView
import Lottie

class LoginViewController: UIViewController , UITextFieldDelegate{
    
    @IBOutlet var RootView: UIView!
    @IBOutlet weak var UserImage: UIImageView!
    @IBOutlet weak var signupCONPASS: UITextField!
    @IBOutlet weak var FirebaseLOGINbtn: UIButton!
    @IBOutlet weak var signupPASS: UITextField!
    @IBOutlet weak var firebasesignupBTN: UIButton!
    @IBOutlet weak var signupEmail: UITextField!
    @IBOutlet weak var signupNAme: UITextField!
    @IBOutlet weak var SIGNUPVIEW: UIView!
    @IBOutlet weak var Carconst: NSLayoutConstraint!
    @IBOutlet weak var CarLogoView: UIView!
    @IBOutlet weak var FBbtnView: UIButton!
    @IBOutlet weak var GooglebtnView: UIButton!
    @IBOutlet weak var T: UIView!
    @IBOutlet weak var H: UIView!
    @IBOutlet weak var EE: UIView!
    @IBOutlet weak var P: UIView!
    @IBOutlet weak var K: UIView!
    @IBOutlet weak var A: UIView!
    @IBOutlet weak var R: UIView!
    @IBOutlet weak var E: UIView!
    @IBOutlet weak var RR: UIView!
    @IBOutlet weak var gradientViewHeight: NSLayoutConstraint!
    @IBOutlet weak var MainLogin: UIButton!
    @IBOutlet weak var MainSIGn: UIButton!
    @IBOutlet weak var LGBTNView: UIView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var user: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var GradientView: UIView!
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    let googlepic: UIImage = UIImage(named:"search.png")!
    let facebookpic: UIImage = UIImage(named: "facebook.png")!
    
    //var actInd:UIActivityIndicatorView!
    var window: UIWindow?
    var imagePicker:UIImagePickerController!
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        user.resignFirstResponder()
        pass.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    var animationPerformedOnce = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !animationPerformedOnce {
            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                self.Carconst.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
            }, completion: nil)
            
            animationPerformedOnce = true
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.isHidden = true
        self.SIGNUPVIEW.isHidden = true
        self.firebasesignupBTN.isHidden = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.animationsLOT()
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
        UIApplication.shared.endIgnoringInteractionEvents()
        })
        self.Carconst.constant -= view.bounds.width
        self.CarLogoView.backgroundColor = UIColor.clear
        /*self.GooglebtnView.imageView?.image = self.resizeImage(image: googlepic, targetSize: CGSize(width: 200.0,height: 200.0))*/
        self.GooglebtnView.setImage(self.resizeImage(image: self.googlepic, targetSize: CGSize(width: 40.0, height: 40.0)), for: .normal)
        self.FBbtnView.setImage(self.resizeImage(image: self.facebookpic, targetSize: CGSize(width: 40.0, height: 40.0)), for: .normal)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        if UIDevice().userInterfaceIdiom == .phone {
            let nativeHeight = UIScreen.main.nativeBounds.height
            if nativeHeight == 1136 {
                self.GradientView.frame.size.height = 250
                self.view.layoutIfNeeded()
            }
        }

        self.user.delegate = self
        self.pass.delegate = self
        self.addgrad()
        self.Logingrad()
        self.MainSIGn.alpha = 0.5
        
        self.UserImage.layer.borderWidth = 1
        self.UserImage.layer.masksToBounds = false
        self.UserImage.layer.borderColor = UIColor.black.cgColor
        self.UserImage.layer.cornerRadius = self.UserImage.frame.height/2
        self.UserImage.clipsToBounds = true

        
        // Do any additional setup after loading the view.
    }
    @IBAction func loginbtn(_ sender: Any) {
        
        if self.user.text == "" || self.pass.text == "" {
            self.alert(message: "Empty Fields!")
            return
        }
        
        self.actInd.startAnimating()
        self.actInd.isHidden = false
        self.FirebaseLOGINbtn.isHidden = true
        guard let email = user.text else { return }
        guard let pass = pass.text else { return }
        Auth.auth().signIn(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                
                
                self.user.text = ""
                self.pass.text = ""
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "slide") as! SWRevealViewController
                
                //updates the view controller
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
                
            } else {
                self.pass.text = ""
                print("Error logging in: \(error!.localizedDescription)")
                self.alert(message: "Error!, Either email or password is Incorrect")
                self.FirebaseLOGINbtn.isHidden = false
                self.actInd.isHidden = true
               // self.resetForm()
            }
        }
        
    }
    
    
    @IBAction func signUpFIrebase(_ sender: UIButton) {
        
        if self.signupNAme.text == "" || self.signupPASS.text == "" || self.signupEmail.text == "" || self.signupCONPASS.text == "" {
            self.alert(message: "Empty Field!")
            return
        }
        
        if self.signupPASS.text != self.signupCONPASS.text {
            self.alert(message: "Password didn't match!")
            return
        }
        
        
        guard let username = self.signupNAme.text else { return }
        guard let email = self.signupEmail.text else { return }
        guard let pass = self.signupPASS.text else { return }
        guard let image = self.UserImage.image else { return }
   
        self.actInd.startAnimating()
        self.actInd.isHidden = false
        self.firebasesignupBTN.isHidden = true
        
        //Authenticates the user using Firebase DB
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            //if there is no errors and there is user
            if error == nil && user != nil {
                //prints out to terminal and user sign up updated on firebase db
                print("User created!")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "slide") as! SWRevealViewController
                    
                    //updates the view controller
                    self.window?.rootViewController = controller
                    self.window?.makeKeyAndVisible()
                
                // uplod the profile pic to Firebase Storage
                self.uploadProfileImage(image) { url in
                    //check
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                print("User display name changed!")
                                
                                self.saveProfile(username: username,Email: email, profileImageURL: url!) { success in
                                    if success {
                                      
                                    } else {
                                        self.firebasesignupBTN.isHidden = false
                                        self.actInd.isHidden = true
                                        self.resetForm()
                                    }
                                }
                                
                            } else {
                                print("Error: \(error!.localizedDescription)")
                                self.firebasesignupBTN.isHidden = false
                                self.actInd.isHidden = true
                                self.resetForm()
                            }
                        }
                        
                    } else {
                        self.firebasesignupBTN.isHidden = false
                        self.actInd.isHidden = true
                        // Error unable to upload profile image
                        self.resetForm()
                    }
                    
                }
                
            } else {
                self.firebasesignupBTN.isHidden = false
                self.actInd.isHidden = true
                print("Error: \(error!.localizedDescription)")
                self.resetForm()
            }
        }
        
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error Signing Up: Try Again", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping (_ url:URL?)->()) {
        
        //refer to firebase storage and get user id, otherwise return
        guard let uid = Auth.auth().currentUser?.uid else { return }
        //store profile pic under user id = uid
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        //firebase needs image as data convert img to data
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            //if there are no errors and image in metadata
            if error == nil, metaData != nil {
                storageRef.downloadURL(completion: { (url, error) in
                    if let url = url {
                        completion(url)
                    } else {
                        completion(nil)
                    }
                })
                // success!
            } else {
                // failed
                completion(nil)
            }
        }
    }
    
    func saveProfile(username:String,Email:String ,profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let databaseRef = Database.database().reference().child("user/\(uid)")
        
        let userObject = [
            "Name": username,
            "Email" : Email,
            "photoURL": profileImageURL.absoluteString,
            "ArrayPins": [String("1"):"Blah blah"]
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
    
    
    @IBAction func mainLGNBTN(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.animationsLOT()
        })
        
        UIView.transition(with: firebasesignupBTN,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                        self?.firebasesignupBTN.isHidden = true
            }, completion: nil)
        
        UIView.transition(with: FirebaseLOGINbtn,
                          duration: 1.0,
                          options: .transitionFlipFromTop,
                          animations: { [weak self] in
                            self?.FirebaseLOGINbtn.isHidden = false
            }, completion: nil)
        
        UIView.transition(with: MainSIGn,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.MainSIGn.alpha = 0.5
                            self?.MainSIGn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            }, completion: nil)
        UIView.transition(with: MainLogin,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.MainLogin.alpha = 1.0
                            self?.MainLogin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
            }, completion: nil)
        
        UIView.transition(with: loginView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.loginView.isHidden = false
            }, completion: nil)
        UIView.transition(with: SIGNUPVIEW,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.SIGNUPVIEW.isHidden = true
            }, completion: nil)
        }
    
    @IBAction func mainSIGNBTN(_ sender: UIButton) {
        self.loginView.isHidden = true
        self.SIGNUPVIEW.isHidden = false
        
        UIView.transition(with: firebasesignupBTN,
                          duration: 1.0,
                          options: .transitionFlipFromTop,
                          animations: { [weak self] in
                            self?.firebasesignupBTN.isHidden = false
            }, completion: nil)
        
        UIView.transition(with: FirebaseLOGINbtn,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.FirebaseLOGINbtn.isHidden = true
            }, completion: nil)
        
        UIView.transition(with: MainLogin,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.MainLogin.alpha = 0.5
                            self?.MainLogin.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            }, completion: nil)
        UIView.transition(with: MainSIGn,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.MainSIGn.alpha = 1.0
                            self?.MainSIGn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
            }, completion: nil)
        
        UIView.transition(with: loginView,
                          duration: 0.2,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.loginView.isHidden = true
            }, completion: nil)
        UIView.transition(with: SIGNUPVIEW,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.SIGNUPVIEW.isHidden = false
            }, completion: nil)
    }
    
    @IBAction func ImagePIcker(_ sender: UIButton) {
        self.PickerIMG()
    }
    func PickerIMG(){
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    /*
 
 FACEBOOK AND GOOGLE LOGIN HERE
 
 */
    
    
    
    @IBAction func FBLogin(_ sender: Any) {
        
        
    }
    
    @IBAction func GoogleLogin(_ sender: Any) {
    }
    
    
}
    


extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension LoginViewController{
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
     
        return false
    }
 
    func animationsLOT(){
        let Tanimations = LOTAnimationView(name: "T")
        let Hanimations = LOTAnimationView(name: "H")
        let EEanimations = LOTAnimationView(name: "E")
        let Panimations = LOTAnimationView(name: "P")
        let Aanimations = LOTAnimationView(name: "A")
        let Ranimations = LOTAnimationView(name: "R")
        let Kanimations = LOTAnimationView(name: "K")
        let Eanimations = LOTAnimationView(name: "E")
        let RRanimations = LOTAnimationView(name: "R")
        
        
        self.lotanime(Tanimations, self.T)
        self.lotanime(Hanimations, self.H)
        self.lotanime(EEanimations, self.EE)
        self.lotanime(Panimations, self.P)
        self.lotanime(Aanimations, self.A)
        self.lotanime(RRanimations, self.RR)
        self.lotanime(Kanimations, self.K)
        self.lotanime(Eanimations, self.E)
        self.lotanime(Ranimations, self.R)
    }
    
    func lotanime(_ animations:LOTAnimationView,_ vview:UIView){
        animations.frame = CGRect(x: 0, y: -30, width: vview.frame.width, height: vview.frame.height * 2.5)
        animations.contentMode = .scaleAspectFit
        vview.addSubview(animations)
        animations.play()
        
    }
    
    func addgrad(){
        let gradientView = EZYGradientView()
        gradientView.frame = GradientView.bounds
        gradientView.firstColor = HextoUIColor.instance.hexString(hex: "#000000")
        gradientView.secondColor = HextoUIColor.instance.hexString(hex: "#4B0082")
        gradientView.angle?? = 180.0
        gradientView.colorRatio = 0.4
        gradientView.fadeIntensity = 1.0
        gradientView.isBlur = true
        gradientView.blurOpacity = 0.5
        self.GradientView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 1500)
        //self.GradientView.roundCorners(corners: [.bottomLeft], radius: 50)
        
         self.GradientView.insertSubview(gradientView, at: 0)
    }
    
    func Logingrad(){
        let gradientView = EZYGradientView()
        gradientView.frame = LGBTNView.bounds
        gradientView.firstColor = HextoUIColor.instance.hexString(hex: "#111111")
        gradientView.secondColor = HextoUIColor.instance.hexString(hex: "#4B0082")
        gradientView.angle?? = 90.0
        gradientView.colorRatio = 0.4
        gradientView.fadeIntensity = 1.5
        gradientView.isBlur = true
        gradientView.blurOpacity = 0.5
        //self.GradientView.roundCorners(corners: [.bottomLeft], radius: 50)
        
        self.LGBTNView.insertSubview(gradientView, at: 0)
    }
    
    func alert(message:String )
    {
        let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alertview.addAction(UIAlertAction(title: "Try Again!", style: .default, handler: {
            action in
            DispatchQueue.main.async {
                
                //  self.UISetup(enable: true)
            }
        }))
        self.present(alertview, animated: true, completion: nil)
        
    }
    
}

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.UserImage.image = pickedImage
        }

        picker.dismiss(animated: true, completion: nil)
    }
    
}


