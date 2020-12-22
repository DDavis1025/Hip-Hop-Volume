//
//  EditProfileVC.swift
//  VolumeiOS
//
//  Created by Dillon Davis on 5/12/20.
//  Copyright © 2020 Dillon Davis. All rights reserved.
//

import Foundation
import UIKit

struct EditPFStruct {
    static var photoDidChange:Bool? = false
    static var usernameDidChange:Bool? = false
    
    func updatePhotoBool(newBool: Bool) {
        EditPFStruct.self.photoDidChange = newBool
    }
    
    func updateUsernameBool(newBool: Bool) {
        EditPFStruct.self.usernameDidChange = newBool
    }
}

protocol UserInfoDelegateProtocol {
    func sendDataToProfileVC(myData: Bool)
    func sendUsernameToArtistPF(myString: String)
}


class EditProfileVC: Toolbar, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, MyDataSendingDelegateProtocol, EmailDelegateProtocol {
    
    var delegate: UserInfoDelegateProtocol? = nil
    
    func sendEmailToEditProfileVC(myData: Bool) {
        if myData {
          print("my data")
          if let userID = user_profile?.sub {
          print("user")
          var getUser = GetUsersById(id:userID)
          getUser.getAllPosts {
              let user = $0
              self.userInfoArr[1].value = user[0].email!
              DispatchQueue.main.async {
                  self.myTableView?.reloadData()
              }
              
           }
          }
        }
    }
    
    func sendDataToEditProfileVC(myData: Bool) {
          if myData {
            print("my data")
            if let userID = user_profile?.sub {
            print("user")
            var getUser = GetUsersById(id:userID)
            getUser.getAllPosts {
                if $0[0].username == nil {
                GETUser(id: userID, path: "getUserInfo").getAllById {
                     if let username = $0[0].username {
                     self.userInfoArr[0].value = username
                     DispatchQueue.main.async {
                         self.myTableView?.reloadData()
                     }
                     self.delegate?.sendUsernameToArtistPF(myString: username)
                  }
                }
                } else {
                let user = $0
                if let username = user[0].username {
                self.userInfoArr[0].value = username
                print("username from delegate \(user[0].username)")
                DispatchQueue.main.async {
                    self.myTableView?.reloadData()
                }
                self.delegate?.sendUsernameToArtistPF(myString: username)
              }
            }
          }
        }
      }
    }
    
    
    
    
    var user_profile = SessionManager.shared.profile
    var imageLoader:DownloadImage?
    var imageView = UIImageView()
    var button = UIButton()
    var save = UIButton()
    let pictureBool = EditPFStruct()
    var pictureAdded:Bool = false
    let updateUser = UpdateUserInfo()
    var photo:[UserPhoto]?
    var imagePH = UIImageView()
    var userInfoArr:[(title: String, value: String)] = []
    var myTableView:UITableView?
    var isPurchased:Bool?
    var dataUsage: DataUsage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePlaceHolder()
        addButton()
        getUserInfo()
        setProfileImage()
        addNavButtons()
        
        print("user profile username \(user_profile?.preferredUsername)")
        view.backgroundColor = UIColor.white
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
          checkForPremium(completion: {
            self.getDataUsage()
          })
//        photoDidUpdate()
    }
    
    func getDataUsage() {
        if let user_id = user_profile?.sub {
        GETDataUsage(user_id: user_id).getDataUsage(completion: {
            self.dataUsage = $0
            print("\(self.dataUsage) \(self.isPurchased)")
         })
      }
    }
    
    
    func getUserInfo() {
        if let userID = user_profile?.sub {
        var getUser = GetUsersById(id:userID)
            getUser.getAllPosts {
                let user = $0
                if user[0].username == nil {
                    GETUser(id: userID, path: "getUserInfo").getAllById {
                        self.userInfoArr.append((title: "Username:", value: $0[0].username ?? "undefined"))
                        self.userInfoArr.append((title: "Email:", value: user[0].email ?? "undefined"))
                        self.addTableView()
                    }
                } else {
                self.userInfoArr.append((title: "Username:", value: user[0].username ?? "undefined" ))
                self.userInfoArr.append((title: "Email:", value: user[0].email ?? "undefined"))
                self.addTableView()
                }
            }
        }
    }
    
    func checkForPremium(completion: @escaping(()->())) {
        print("checkForPurchase")
        if let user_id = user_profile?.sub {
        GETPremium(user_id: user_id).getPremium(completion: {
            print("\($0) premium user")
            if $0.count > 0 {
            if let status = $0[0].status {
            if status == "active" {
                self.isPurchased = true
                print("checkForPurchase isPurchased")
                let purchase = IsPremiumPurchased()
                purchase.updateIsPurchased(newBool: true)
                completion()
            } else {
                print("not purchased")
                completion()
                self.isPurchased = false
                let purchase = IsPremiumPurchased()
                purchase.updateIsPurchased(newBool: false)
            }
           }
            } else {
                completion()
                self.isPurchased = false
                let purchase = IsPremiumPurchased()
                purchase.updateIsPurchased(newBool: false)
            }
          })
        }
    }
    
    
    func photoDidUpdate() {
    let editPF = EditPFStruct()
    if EditPFStruct.photoDidChange! {
     if let profile = user_profile {
        print("hellur 2")
               GetUsersById(id: profile.sub).getAllPosts {
                   let photo = $0
                   self.imageLoader = DownloadImage()
                   self.imageLoader?.imageDidSet = { [weak self] image in
                       DispatchQueue.main.async {
                           self?.imageView.image = image
                           self?.view?.addSubview(self!.imageView)
                       }
                   }
                   self.imageLoader?.downloadImage(urlString: photo[0].picture!)
                   print("photo \(photo[0].picture)")
               }
         }
      }
        editPF.updatePhotoBool(newBool: false)
        
    }
    
    
    func setProfileImage() {
       if let profile = user_profile {
       GetUsersById(id: profile.sub).getAllPosts {
            let photo = $0
            self.imageLoader = DownloadImage()
            self.imageLoader?.imageDidSet = { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.view?.addSubview(self!.imageView)
                }
            }
        if let picture = photo[0].picture {
            self.imageLoader?.downloadImage(urlString: picture)
        }
        }
      }
        print("got image")
    }
    
    func imagePlaceHolder() {
        imageView.image = UIImage(named: "profile-placeholder-user")
        view.addSubview(imageView)
        setImageContraints()
    }
    
    func setImageContraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setImagePHContraints() {
        self.imagePH.translatesAutoresizingMaskIntoConstraints = false
        self.imagePH.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        self.imagePH.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.imagePH.widthAnchor.constraint(equalToConstant: 150).isActive = true
        self.imagePH.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func addButton() {
        button.setTitle("Change Photo", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font =  UIFont(name: "AppleSDGothicNeo-Regular", size: 14)
        
        view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5).isActive = true
        
        button.isUserInteractionEnabled = true
        
        button.addTarget(self, action:#selector(buttonClicked), for: .touchUpInside)
        
        
    }
    
    
    @objc func buttonClicked() {
        print("change photo clicked")
        showImagePickerController()
    }
    
    func addNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    }
    
    
    @objc func cancelTapped(sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func doneTapped(sender: UIBarButtonItem) {
        if pictureAdded {
            if let isPurchased = isPurchased, let overFree = dataUsage?.overFree, let overPremium = dataUsage?.overPremium  {
                if (isPurchased && !overFree) {
                    //show alert
                    showUpdateToPremium()
                } else if (isPurchased && !overPremium) {
                    //show alert
                    showOutOfPremiumData()
                } else {
                    userPhotoUpload()
                }
          }
        }

        self.navigationController?.popViewController(animated: true)

    }
//
    func showUpdateToPremium() {
        let alert = UIAlertController(title: "Alert", message: "You are out of upload data", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Upgrade To Premium", style: .default, handler: { (action: UIAlertAction!) in
              let premiumVC = UpgradeToPremium()
              self.navigationController?.pushViewController(premiumVC, animated: true)
              print("OK. updgrade to premium")
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("cancel clicked")
        }))

        present(alert, animated: true, completion: nil)

    }
    
    func showOutOfPremiumData() {
        let alert = UIAlertController(title: "Alert", message: "You are out of upload data", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                    print("OK tapped")

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


        }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    var components:URLComponents = {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "hiphopvolumebucket.s3.amazonaws.com"
        
        return component
    }()

    
    func userPhotoUpload() {
        var component = URLComponents()
        component.scheme = "https"
        component.host = "www.hiphopvolume.com"
        component.path = "/userImageUpload"
        let editPF = EditPFStruct()
        let imageToServer = ImageToServer()
        let user_id = user_profile?.sub
        if let user_id = user_id {
            imageToServer.imageUploadRequest(imageView: imageView, uploadUrl: component.url!, param: ["user_id":user_id]) {
                let getPhoto = GETUserPhotoByID(id: self.user_profile!.sub)
                getPhoto.getPhotoById {
                    var component2 = URLComponents()
                    component2.scheme = "https"
                    component2.host = "hiphopvolumebucket.s3.amazonaws.com"
                    self.photo = $0
                    if let photo_path = self.photo![0].path {
                    component2.path = "/\(photo_path)"
                    }
                    self.updateUser.updateUserInfo(parameters: ["picture": component2.url!.absoluteString], user_id: self.user_profile!.sub, completion: {
                        self.delegate?.sendDataToProfileVC(myData: true)
                        print("sendData")
                    })
    
//
                }
            }
          }
        }
        
    
    func addTableView() {
        
        self.myTableView = UITableView()
        
        
        self.myTableView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.myTableView?.register(PersonInformationTableViewCell.self, forCellReuseIdentifier: "PersonInformationTableViewCell")
        
        self.myTableView?.dataSource = self
        self.myTableView?.delegate = self
        
        myTableView?.delaysContentTouches = false
        self.view.addSubview(self.myTableView!)
        
        self.myTableView?.topAnchor.constraint(equalTo: self.button.bottomAnchor).isActive = true
        self.myTableView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        self.myTableView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        self.myTableView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
        myTableView?.layoutMargins = UIEdgeInsets.zero
        myTableView?.separatorInset = UIEdgeInsets.zero
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let usernameTextfield = UsernameTextField()
        let emailTextfield = EmailTextField()
        print("cell clicked")
        if userInfoArr[indexPath.row].title == "Username:" {
            print("username clicked")
            usernameTextfield.delegate = self
            navigationController?.pushViewController(usernameTextfield, animated: true)
        }
        if userInfoArr[indexPath.row].title == "Email:" {
            print("email clicked")
            emailTextfield.delegate = self
            navigationController?.pushViewController(emailTextfield, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userInfoArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonInformationTableViewCell") as! PersonInformationTableViewCell
        cell.setUpView(title: userInfoArr[indexPath.row].title, value: userInfoArr[indexPath.row].value)
        
        return cell
    }
    
    
    
    
    
    
}


extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = editedImage
            pictureAdded = true
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = originalImage
            pictureAdded = true
        }
        dismiss(animated: true, completion: nil)
    }
}

