{
  services.udev.enable = true;

  services.udev.extraHwdb = ''
    libwacom:name:Wacom HID 52D3*:input:*
      ID_INPUT=1
      ID_INPUT_TABLET=1
      ID_INPUT_JOYSTICK=0
    libwacom:name:Wacom HID 52D3 Pad:input:*
      ID_INPUT_TABLET_PAD=1
    libwacom:name:Wacom HID 52D3 Finger:input:*
      ID_INPUT_TOUCHSCREEN=1
  '';

  environment.etc."libwacom/isdv4-52d3.tablet".text = ''
    # Lenovo Yoga 7 14ARB7

    [Device]
    Name=Wacom HID 52D3
    ModelName=WACF2200
    DeviceMatch=i2c:056a:52d3
    Class=ISDV4
    IntegratedIn=Display;System
    Width=12
    Height=7

    [Features]
    Reversible=false
    Stylus=true
    Touch=true
    Ring=false
    Buttons=0
    BuiltIn=true
  '';
}
