//
//  TBIFileManager.swift
//  shanglvjia
//
//  Created by manman on 2018/9/4.
//  Copyright © 2018年 TBI. All rights reserved.
//

import UIKit
import SwiftDate

final class TBIFileManager: NSObject {
    
    private let storeFileFloderName:String = "TBIFile"
    
    
    static let shareInstance = TBIFileManager()
    
    private override init() {
        
    }
    
    
    
    
    
    /// 将String 写入 文档
    /// 默认写入 Document 文件中 以日期为文件夹名 和文件名
    /// 文件分布 年 月 日 秒 时间戳
    final public func writeTextToDefaultFile(text:String)->Bool {
        
        let fileFloderName = createStoreFileFloder()
        guard fileFloderName.isEmpty == false && text.isEmpty == false else {
            return false
        }
        let writeTextDateTime:String = Date().string(custom: "YYYY-MM-DD HH:mm:ss.sss")
        let fullText:String = writeTextDateTime + text
        
        write2File(text: fullText, filePath: fileFloderName)
        
        
        
//
//        BOOL existed = [fileManager fileExistsAtPath:rarFilePath isDirectory:&isDir];
//        BOOL dataExisted = [fileManager fileExistsAtPath:dataFilePath isDirectory:&dataIsDir];
//        if ( !(isDir == YES && existed == YES) ) {//如果文件夹不存在
//            [fileManager createDirectoryAtPath:rarFilePath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        if (!(dataIsDir == YES && dataExisted == YES) ) {
//            [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//
//
        
        
        
        
        
        
        
        
        //LogFileDocumentPath()
        
        
        
        
        return true
        
//
//
//
//        let StringPath: String = NSHomeDirectory() + "/Documents/RookieString.txt"
//        let stringInfo = "存储的String"
//        try! stringInfo.writeToFile(StringPath, atomically: true, encoding: NSUTF8StringEncoding)
//        print("String存储文件位置 : \\(StringPath)")
//        2).将Image保存到文件中
//        let imagePath:String = NSHomeDirectory() + "/Documents/String.png"
//        let image = UIImage(named: "1")
//        3).将数组保存到文件中
//        let imageData:NSData = UIImagePNGRepresentation(image!)!
//        imageData.writeToFile(imagePath, atomically: true)
//        4).将字典保存到文件中
//        let arr = NSArray(objects:"Rookie","YX","fight")
//        let arrayPath: String = NSHomeDirectory() + "/Documents/arr.plist"
//        arr.writeToFile(arrayPath, atomically: true)
    }
    
    
    private func createStoreFileFloder() -> String {
        let baseFilePath:String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first ?? ""
        let currentDateYear:String = Date().string(custom: "YYYY")
        let currentDateMonth:String = Date().string(custom: "MM")
        let currentDateDay:String = Date().string(custom: "DD")
        let fileName:String = Date().string(custom: "YYYY-MM-dd-HH-mm")
        let fullFileFolderPath = baseFilePath + "/" + storeFileFloderName + "/" + currentDateYear + "/" + currentDateMonth + "/" + currentDateDay + "/" + fileName + ".text"
        var isCreate:Bool = false
        let isExist = FileManager.default.fileExists(atPath: fullFileFolderPath)
        if !isExist  {
            isCreate = FileManager.default.createFile(atPath: fullFileFolderPath, contents:nil, attributes: nil)
            //FileManager.default.createfil
        }
        
        if isExist == true || isCreate == true {
            return fullFileFolderPath
        }
        
        return ""
        
    }
    
    
   private func write2File(text:String,filePath:String) {
        guard text.isEmpty == false && filePath.isEmpty == false else {
            return
        }
        let textCopy = text
        var isSuccess = true
        do {
            try textCopy.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
        }catch(let error) {
        printDebugLog(message: error)
        }
    }
    
    
    private func LogFileDocumentPath() {
        
        //获得当前程序的主目录
        let dirPath:String = NSHomeDirectory()
        printDebugLog(message: dirPath)
        let allDirPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.applicationDirectory, FileManager.SearchPathDomainMask.localDomainMask, true)
        for element in allDirPath {
            printDebugLog(message: "1")
            printDebugLog(message: element)
        }

        //获取沙盒内 所有文件
        let allDirPathNew =  FileManager.default.enumerator(atPath: dirPath)
        for element in allDirPathNew! {
            printDebugLog(message: "2")
            printDebugLog(message: element)
        }
//
        
        
        
    }
    

    
    
    
    

}
