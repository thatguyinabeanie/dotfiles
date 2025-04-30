#!/usr/bin/env nu

print "🟠 TouchID sudo."
if ( ("/etc/pam.d/sudo_local" | path type) != "file" ) {
  "auth       sufficient     pam_tid.so" | sudo tee /etc/pam.d/sudo
}
print "🔵 TouchID sudo enabled."

