//
//  AppDelegate.swift
//  YouTubePlayer
//
//  Created by Josa Gesell on 14.10.17.
//  Copyright © 2017 Josa Gesell. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if let window = NSApplication.shared.mainWindow {
      window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
      window.titlebarAppearsTransparent = true
      window.title = ""
    }
  }

  func applicationWillTerminate(_ aNotification: Notification) {}


}

