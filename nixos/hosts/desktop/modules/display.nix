{...}: {
  # Allow overclocking of Ultrawide monitor.
  services.xserver.deviceSection = ''
    Option "TearFree" "false"
    Option "VariableRefresh" "true"
    Option "ModeValidation" "AllowNonEdidModes"
  '';
  services.xserver.config = ''
    Section "Monitor"
      Identifier "DisplayPort-1"
      Modeline "3440x1440_115.00_rb2"  615.70  3440 3448 3480 3520  1440 1507 1515 1521 +hsync -vsync
      Option "PreferredMode" "3440x1440_115.00_rb2"
      Option "Primary" "true"
      VendorName "MSI"
      ModelName "MSI MAG341CQ"
    EndSection
  '';
}
