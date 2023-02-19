{
  services.openssh = {
    # Hardening, only allow authorized keys to be managed by the system account.
    authorizedKeysFiles = ["/etc/ssh/authorized_keys.d/%u"];
    settings = {
      AuthenticationMethods = "publickey";
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
      X11Forwarding = false;
    };
  };
}
