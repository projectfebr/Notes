//
//  PlayerViewController.swift
//  Notes
//
//  Created by Aleksandr Bolotov on 17.07.2022.
//

import UIKit

class PlayerViewController: UIViewController {
    var timerIsOn = false
    var timer = Timer()
    var timeRemaining = 1500

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var pauseButton: UIButton! {
        didSet {
            pauseButton.setTitle("", for: .normal)
        }
    }
    @IBOutlet weak var stopButton: UIButton! {
        didSet {
            stopButton.setTitle("", for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "60:00"
    }

    @IBAction func playButtonTap(_ sender: Any) {
        if !timerIsOn {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,      selector: #selector(timerRunning), userInfo: nil, repeats: true)
        }
        timerIsOn = true
    }

    @IBAction func pauseButtonTap(_ sender: Any) {
        timer.invalidate()
        timerIsOn = false
    }

    @IBAction func stopButtonTap(_ sender: Any) {
        timer.invalidate()
        timeRemaining = 1500
        timeLabel.text = "25:00"
        timerIsOn = false
    }

    @objc func timerRunning() {
        timeRemaining -= 1
        let minutesLeft = Int(timeRemaining) / 60 % 60
        let secondsLeft = Int(timeRemaining) % 60
        timeLabel.text = "\(minutesLeft):\(secondsLeft)"
    }
}
