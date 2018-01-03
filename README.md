
# AMHolderButton  swift 4, iOS 11

![ezgif-3-32e9f9344e](https://user-images.githubusercontent.com/17800816/33937652-80375b8c-e019-11e7-970b-8289bb089acf.gif)

### Storyboard
- Drag a UIButton onto your view.
- Change it's class to `AMHolderButton`
- Edit it's appearance using the custom properties in the Attributes Inspector
- Create the button as a property of it's View Controller
- In the `viewDidLoad()` method of your View Controller, set the button's `holdButtonCompletion` property to tell the button what to do when it's done animating.

For an example of creating a AMHoldButton in storyboard, check out the example project.

### Programatically
- Initialize the button
- Set the button's `holdButtonCompletion` property to tell the button what to do when it's done animating.

Example:
```swift 4
let bttn = AMHoldButton(frame: CGRect(x: 0, y: 0 , width: 200, height: 50), slideColor: UIColor.green, slideTextColor: UIColor.white, slideDuration: 1.0)
bttn.backgroundColor = UIColor.clear
bttn.setText("👍🏻")
bttn.setTextFont(UIFont.boldSystemFont(ofSize: 18))
bttn.textColor = UIColor.green
bttn.holdButtonCompletion = {() -> Void in
print("Hold button has completed!")
}
bttn.resetDuration = 0.2
bttn.borderWidth = 3.0
bttn.borderColor = UIColor.green
bttn.cornerRadius = bttn.frame.width / 2
self.view.addSubview(bttn)
```

