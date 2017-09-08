//
//  ViewController.swift
//  HZAlipayHomePage
//
//  Created by 韩兆华 on 2017/8/25.
//  Copyright © 2017年 韩兆华. All rights reserved.
//

/* 
 *  仿写支付宝首页实现效果
 *
 **/


import UIKit
import MJRefresh

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

class HeadSegue: UIStoryboardSegue {

    override func perform() {
        
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var coverNavView: UIView!
    
    @IBOutlet weak var mainNavView: UIView!
            
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var headerView: UIView!
    
    fileprivate var childVC: HeaderViewController?
    
    fileprivate var dataSorceNumber: Int = 10
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        builtUI()
        performSegue(withIdentifier: "head", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "head" {
            childVC = segue.destination as? HeaderViewController
            headerView = segue.destination.view
            headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 305)
            tableView.addSubview(headerView)
            addChildViewController(segue.destination)
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 305)
    }
    
    private func builtUI() {
        
        tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            guard let weak = self else {return}
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                // Put your code which should be executed with a delay here
                weak.tableView.mj_header.endRefreshing()
                weak.dataSorceNumber = 10
                weak.tableView.reloadData()
                
            })
        }
        // 由于顶部有305高度的tableHeaderView, 并且在设置的时候, 将tableView的scrollIndicatorInsets的top值设置为305, 所以需要忽略这部分高度, 才可以正常显示下拉刷新动画.
        tableView.mj_header.ignoredScrollViewContentInsetTop = -305
        
        tableView.mj_footer = MJRefreshAutoNormalFooter { [weak self] in
            guard let weak = self else {return}
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                
                weak.tableView.mj_footer.endRefreshing()
                weak.dataSorceNumber += 10
                weak.tableView.reloadData()
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY <= 0 {
            headerView.frame = CGRect(x: 0, y: offsetY, width: SCREEN_WIDTH, height: 305)
            coverNavView.alpha = 0
            mainNavView.alpha = 1
        } else if offsetY > 0 && offsetY < 95 {
            //处理透明度
            let alpha = (1 - offsetY / 95) > 0 ? (1 - offsetY / 95) : 0
            childVC?.changeAlpha(alpha: alpha)
            if alpha > 0.9 {
                coverNavView.alpha = 0
                mainNavView.alpha = alpha / 5
            } else {
                mainNavView.alpha = 0
                coverNavView.alpha = 1 - alpha
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSorceNumber
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = "\(indexPath.section)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 5
    }
    
    
}


