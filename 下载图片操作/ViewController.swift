//
//  ViewController.swift
//  下载图片操作
//
//  Created by 王志盼 on 15/11/3.
//  Copyright © 2015年 王志盼. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ZYDownloadImageOperationDelegate {
    
    let identifier = "DownloadImageCell"
    let apps: Array<ZYApp> = ZYApp.getApps()
    lazy var queue: NSOperationQueue = NSOperationQueue()
    /*
     key:图片的url  values: 相对应的operation对象  （判断该operation下载操作是否正在执行，当同一个url地址的图片正在下载，那么不需要再次下载，以免重复下载，当下载操作执行完，需要移除）
    */
    lazy var operations = Dictionary<String, ZYDownloadImageOperation>()
    
    /*
      key:图片的url  values: 相对应的图片        （缓存，当下载操作完成，需要将所下载的图片放到缓存中，以免同一个url地址的图片重复下载）
    */
    lazy var images = Dictionary<String, UIImage>()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupTableView();
        self.setupQueue();
    }
    
    //MARK:- setup系列方法
    private func setupTableView()
    {
        
        self.tableView.rowHeight = 70;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    private func setupQueue()
    {
        self.queue.maxConcurrentOperationCount = 3;
    }
    
    //MARK:- UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.apps.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(identifier)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: identifier)
        }
        let app = self.apps[indexPath.row]
        cell!.textLabel?.text = app.name
        cell!.detailTextLabel?.text = app.download
        let image: UIImage? = self.images[app.icon!]
//        print("1:   \(app.icon!)")
        if (image != nil) {
            cell!.imageView?.image = image
        }
        else {
            cell!.imageView?.image = UIImage(named: "TestMam")
            var operation: ZYDownloadImageOperation? = self.operations[app.icon!]
            
            if (operation == nil) {
                operation = ZYDownloadImageOperation()
                operation?.url = app.icon!
                operation?.indexPath = indexPath
                operation?.delegate = self;
                
                self.queue.addOperation(operation!)
                self.operations[app.icon!] = operation      //加入字典，表示正在执行此次操作
            }
        }
        return cell!;
    }

    //MARK:- ZYDownloadImageOperationDelegate
    func downloadImageOperation(operation: ZYDownloadImageOperation, didFinishDownloadImage image: UIImage)
    {
        self.operations.removeValueForKey(operation.url)       //下载操作完成，所以把它清掉，表示没有正在下载
        self.images[operation.url] = image                  //下载完毕，放入缓存，免得重复下载
//        print("2:   \(operation.url)")
        self.tableView.reloadRowsAtIndexPaths([operation.indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    //MARK:- UIScrollView
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.queue.suspended = true      //在拖拽的时候，停止队列下载
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.queue.suspended = false    //在停止拖拽的时候，开始队列下载
    }
}