{ pkgs, ... }:

{
  home.packages = with pkgs; [
    #fira-code
    #fira-code-symbols
    font-awesome
    #liberation_ttf
    #mplus-outline-fonts
    nerdfonts
    #noto-fonts
    #noto-fonts-emoji
    #proggyfonts
  ];
}

