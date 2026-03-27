{config, pkgs, ...}:
{
 services.greetd = {
  enable = true;
  settings = {
   default_session = {
     command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd hyprland";
    }:
   };
  vt = "1";
 };
 security.pam.services.greetd {};
}
