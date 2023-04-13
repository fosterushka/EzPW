#!/bin/bash

# Function to generate random password
generate_password() {
  local length=$(( RANDOM % 25 + 8 ))  # Random password length between 8 and 32
  local password=$(openssl rand -base64 48 | tr -dc 'a-zA-Z0-9~!@$=-' | fold -w "$length" | head -n 1)
  echo "$password"
}

# Function to save password to file
save_password() {
  local website="$1"
  local password="$2"
  local fileName="passwords.txt"
  if [[ -e "$fileName" ]]; then
    echo "File already exists. Appending password to the file."
  else
    echo "File does not exist. Creating file."
    touch "$fileName"
  fi
  echo "Website: $website | Password: $password" >> "$fileName"
  echo "Password saved to $fileName."
}

# Display all saved passwords on first run
fileName="passwords.txt"
if [[ -e "$fileName" ]]; then
  echo "Saved passwords:"
  cat "$fileName"
  echo
fi

read -p "Enter the website name: " website
password=$(generate_password)

echo "You just generated a new password for $website: $password"

read -p "Do you want to save the password to a file? (yes/no): " savePassword

if [[ "$savePassword" == "yes" ]]; then
  save_password "$website" "$password"
fi

exit 0
