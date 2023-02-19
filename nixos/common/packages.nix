{pkgs, ...}: {
  # List of system profile packages.
  environment.systemPackages = with pkgs; [
    # Management
    fd
    git
    htop
    neofetch
    neovim
    openssl
    psmisc # provides: killall, pstree, etc.
    ripgrep # provides: rg
    rsync
    tree
    wget

    # Compression & De-compression
    atool # provides: apack, aunpack, acat, etc.
    bzip2
    gnutar # provides: tar
    gzip
    lz4
    lzip
    p7zip # provides: 7z
    xz
    zip
    unzip
    zstd

    # Data formatters
    libxml2 # provides: xmllint
    jq
    yq-go

    # Networking
    iperf
    nmap

    # Hardware
    ethtool
    lshw
    lsof
    pciutils # provides: lspci
    smartmontools # provides: smartctl, etc.
    usbutils # provides: lsusb
  ];
}
