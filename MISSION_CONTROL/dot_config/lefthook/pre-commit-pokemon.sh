#!/bin/bash

# Print a Pokémon pixel art and a fun message for pre-commit
if command -v pokeget >/dev/null 2>&1; then
  echo -e "\033[1;36m==========================================================\033[0m"
  pokeget random --hide-name
  echo -e "\033[1;36m==========================================================\033[0m"
  echo -e "\033[1;35m✨ Pre-commit: Pokémon wishes you happy coding! ✨\033[0m"
  echo -e "\033[1;34mGotta commit 'em all!\033[0m"
  echo
else
  echo "=========================================================="
  echo "  Pre-commit: Pokémon wishes you happy coding!  "
  echo "=========================================================="
  echo
fi

exit 0
