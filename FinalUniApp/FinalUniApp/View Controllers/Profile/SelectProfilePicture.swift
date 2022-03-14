//
//  ChangePP.swift


import UIKit
import Firebase
import FirebaseStorage

extension EditProfilePage: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @objc func ChangeProfileImage() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
        imagePicked = "ProfileImage"
        profilepressed = true
        present(picker, animated: true, completion: nil)
        }
    }
    
    @objc func SelectImage1(gesture: UITapGestureRecognizer) {
        imagePicked = "Picture1"
        pressed1 = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func SelectImage2(gesture: UITapGestureRecognizer) {
        imagePicked = "Picture2"
        pressed2 = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func SelectImage3(gesture: UITapGestureRecognizer) {
        imagePicked = "Picture3"
        pressed3 = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let originalImage = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
            }
        if let selectedImage = selectedImageFromPicker {
            
            if imagePicked == "ProfileImage" {
                profileImage.image = selectedImage
                //uploadData(destination: "ProfilePicUrl", image: profileImage)
                
            } else if imagePicked == "Picture1" {
                Picture1.image = selectedImage
                //uploadData(destination: "Picture1", image: Picture1)
            }
            else if imagePicked == "Picture2" {
                Picture2.image = selectedImage
                //uploadData(destination: "Picture2", image: Picture2)
            }
            else if imagePicked == "Picture3" {
                Picture3.image = selectedImage
                //uploadData(destination: "Picture3", image: Picture3)
            }
        }
        dismiss(animated: true, completion: nil)
        }
 
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func showError() {
      let alertController = UIAlertController(title: "Something Went Wrong", message: "Try again Later", preferredStyle: .alert)
      let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
      alertController.addAction(defaultAction)
      self.present(alertController, animated: true, completion: nil)
    }
    
    
    
}
   



