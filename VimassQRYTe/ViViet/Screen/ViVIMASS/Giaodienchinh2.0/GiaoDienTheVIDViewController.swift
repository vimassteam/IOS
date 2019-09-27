//
//  GiaoDienTheVIDViewController.swift
//  ViViMASS
//
//  Created by Nguyen Van Tam on 8/23/19.
//

import UIKit

class GiaoDienTheVIDViewController: GiaoDichViewController {
    private let TAG = "GiaoDienQRYTeViewController"
    private let arrOptions = ["Sao kê ví" , "Điểm mượn, trả thẻ y tế" , "Điểm nhận thanh toán thẻ y tế"]
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addTitleView("Tra cứu QR")
        
        let btnRight = UIBarButtonItem(title: "Hướng dẫn", style: .plain, target: self, action: #selector(suKienChonHuongDan))
        self.navigationItem.rightBarButtonItem = btnRight
        
        self.tableView.tableFooterView = UIView(frame: .zero)
        self.tableView.register(UINib(nibName: "DanhSachViVimassCell", bundle: nil), forCellReuseIdentifier: "DanhSachViVimassCell")
    }

    @objc func suKienChonHuongDan() {
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GiaoDienTheVIDViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DanhSachViVimassCell", for: indexPath) as! DanhSachViVimassCell
        cell.lblTitle.text = arrOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hienThiHopThoaiMotNutBamKieu(0, cauThongBao: "Chức năng đang được phát triển")
    }
}