class AppDelegate
  attr_accessor :track

  def applicationDidFinishLaunching(notification)
    self.track = Track.new

    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [280, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless

    @textField = NSTextField.alloc.initWithFrame([[90, 318], [100, 22]])
    @textField.stringValue = '5'
    @textField.alignment = NSCenterTextAlignment
    @textField.bezelStyle = NSTextFieldRoundedBezel
    @textField.target = self
    @textField.action = 'takeFloatValueForVolumeFrom:'
    @textField.translatesAutoresizingMaskIntoConstraints = false
    @textField.formatter = NSNumberFormatter.new.tap do |f|
      f.minimum = 0
      f.maximum = 11
      f.allowsFloats = true
      f.localizesFormat = true
      f.minimumFractionDigits = 0
      f.maximumFractionDigits = 2
    end
    @mainWindow.contentView.addSubview(@textField)

    @slider = NSSlider.alloc.initWithFrame([[129, 62], [22, 236]])
    @slider.minValue = 0
    @slider.maxValue = 11
    @slider.intValue = 5
    @slider.target = self
    @slider.action = 'takeFloatValueForVolumeFrom:'
    @slider.translatesAutoresizingMaskIntoConstraints = false
    @mainWindow.contentView.addSubview(@slider)

    @button = NSButton.alloc.initWithFrame([[90, 20], [100, 22]])
    @button.title = 'Mute'
    @button.bezelStyle = NSTexturedRoundedBezelStyle
    @button.target = self
    @button.action = 'mute'
    @button.translatesAutoresizingMaskIntoConstraints = false
    @mainWindow.contentView.addSubview(@button)

    constraints = []
    views = {'text' => @textField, 'slider' => @slider, 'button' => @button, 'superview' => @mainWindow.contentView}
    constraints += NSLayoutConstraint.constraintsWithVisualFormat('H:|-(>=20)-[text(==100)]-(>=20)-|',
      options: NSLayoutFormatAlignAllCenterY,
      metrics: nil,
      views: views
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat('H:|-(>=20)-[slider(==22)]-(>=20)-|',
      options: NSLayoutFormatAlignAllCenterY,
      metrics: nil,
      views: views
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat('H:|-(>=20)-[button(==100)]-(>=20)-|',
      options: NSLayoutFormatAlignAllCenterY,
      metrics: nil,
      views: views
    )
    constraints += NSLayoutConstraint.constraintsWithVisualFormat('V:|-(==20)-[text(==22)]-(==20)-[slider(>=100)]-(==20)-[button(==22)]-(==20)-|',
      options: NSLayoutFormatAlignAllCenterX,
      metrics: nil,
      views: views
    )
    constraints += [
      NSLayoutConstraint.constraintWithItem(@textField,
        attribute: NSLayoutAttributeCenterX,
        relatedBy: NSLayoutRelationEqual,
        toItem: @mainWindow.contentView,
        attribute: NSLayoutAttributeCenterX,
        multiplier: 1,
        constant: 0
      ),
      NSLayoutConstraint.constraintWithItem(@slider,
        attribute: NSLayoutAttributeCenterX,
        relatedBy: NSLayoutRelationEqual,
        toItem: @mainWindow.contentView,
        attribute: NSLayoutAttributeCenterX,
        multiplier: 1,
        constant: 0
      ),
      NSLayoutConstraint.constraintWithItem(@button,
        attribute: NSLayoutAttributeCenterX,
        relatedBy: NSLayoutRelationEqual,
        toItem: @mainWindow.contentView,
        attribute: NSLayoutAttributeCenterX,
        multiplier: 1,
        constant: 0
      )
    ]
    @mainWindow.contentView.addConstraints(constraints)
  end

  def mute
    self.track.volume = 0.0
    self.updateUserInterface
  end

  def takeFloatValueForVolumeFrom(sender)
    self.track.volume = sender.floatValue
    self.updateUserInterface
  end

  def updateUserInterface
    @textField.floatValue = self.track.volume
    @slider.floatValue = self.track.volume
  end
end
