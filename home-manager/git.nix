{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Ajit Krishna";
      user.email = "ajit@clarionhealth.com";
      rerere = {
        autoUpdate = true;
        enabled = true;
      };
      pull.rebase = true;
    };
  };
}
