#!/usr/bin/env nu

print "🟠 Rebuilding bat themes..."
bat cache --build | save --append /dev/null
print "🔵 Rebuilt bat themes."
