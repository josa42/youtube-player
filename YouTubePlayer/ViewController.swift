//
//  ViewController.swift
//  YouTubePlayer
//
//  Created by Josa Gesell on 14.10.17.
//  Copyright © 2017 Josa Gesell. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation
import Swifter

class ViewController: NSViewController {

  @IBOutlet weak var playerView: AVPlayerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.startServer()
    
    let player = AVPlayer()
    self.playerView.player = player;
  }
  
  func playVideo(siteUrl: String) {
    
    let urlString = self.getVideo(url: siteUrl)
    print(urlString)
    
    guard let url = URL(string: urlString) else {
      print("failed?")
      return
    }
    
    self.playerView.player?.replaceCurrentItem(with: AVPlayerItem(url: url))
  }
  
  func getVideo(url: String) -> String{
    let process = Process()
    process.launchPath = "/usr/bin/env"
    process.arguments = ["youtube-dl", "--format", "mp4", "--get-url", url]
    
    let pipe = Pipe()
    process.standardOutput = pipe
    
    process.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
    
    return output!.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  override var representedObject: Any? {
    didSet {
    // Update the view, if already loaded.
    }
  }
  
  func startServer() {
    print("Server has starting...")
  
    let server = HttpServer()
    server["/pause"] = { request in
      self.playerView.player?.pause()
      return .ok(.html("Success"))
    }
    
    server["/play"] = { request in
      
      for (key, value) in request.queryParams {
        print("\(key) => \(value)")
        
        if (key == "url") {
          self.playVideo(siteUrl: value)
          break
        }
      }
      
      self.playerView.player?.play()
      return .ok(.html("Success"))
    }
  
    do {
      try server.start(9999, forceIPv4: true)
      print("Server has started ( port = \(try server.port()) )")
    } catch {
      print("Failed staring server")
    }
  }
}

