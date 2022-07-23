//
//  LikeTableCell.swift
//  PlugSpace
//
//  Created by MAC on 18/11/21.
//

import UIKit

class LikeTableCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setAfter { [self] in
            imgProfile.setCornerRadius(imgProfile.frame.height / 2)
        }
    }

    //MARK:- Method
    
    func setData(data:likeDetailsModel)  {
        imgProfile.sd_setImage(with: URL(string: data.profile), placeholderImage: UIImage(named: "img_nt_1"), options: .retryFailed)
        lblName.text = data.name + ", \(data.age)"
        if (!data.jobTitle.isEmpty && !data.comment.isEmpty) {
            lblName.text = "\(lblName.text ?? ""), \(data.jobTitle)"
        }
        lblProfession.text = data.comment.isEmpty ? data.jobTitle : data.comment
        lblTime.text = data.dateTime
    }
    
    
    
    func setDataForSavedProfile(data:SavedProfileModel)  {
        imgProfile.sd_setImage(with: URL(string: data.profile), placeholderImage: UIImage(named: "img_nt_1"), options: .retryFailed)
        lblName.text = data.name
        lblProfession.text =  data.age + " Years"//data.comment.isEmpty ? data.jobTitle : data.comment
        lblTime.text = ""//getFormattedDate(string: data.dateTime, formatter: "MMM dd,yyyy")
        
        
        
    }
    
    
    
    
    


     func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let date: Date? = dateFormatterGet.date(from: string)
      //  print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        
        return dateFormatterPrint.string(from: date ?? Date());
    }

}
