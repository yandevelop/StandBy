# StandBy

This project was initially intended to be a recreation of iOS 17's [StandBy mode](https://support.apple.com/en-gb/guide/iphone/iph878d77632/ios).<br>
Due to the implementation being unfinished, this tweak doesn't work as intended.<br>

If you want to make it work, I would recommend creating a UIWindow and make it visible once the device is locked and in landscape mode.
Currently the implementation only adds a UIViewController to CSProudLockViewController once the device rotates but this is not an efficient approach.
Development was made on iPhone X running iOS 14.3.

Below you can find working examples of what this tweak was intended to be.

<img src="https://raw.githubusercontent.com/yandevelop/StandyBy/master/Resources/IMG_9086.jpg" width=400 style="transform: rotate(90deg);">
<img src="https://raw.githubusercontent.com/yandevelop/StandyBy/master/Resources/IMG_9089.jpg" width=400 style="transform: rotate(90deg);">
<img src="https://raw.githubusercontent.com/yandevelop/StandyBy/master/Resources/IMG_9090.jpg" width=400 style="transform: rotate(90deg);">