#!/bin/bash

function generate_password() {
  local length=$(( RANDOM % 25 + 8 ))  # Random password length between 8 and 32
  local password=$(openssl rand -base64 48 | tr -dc 'a-zA-Z0-9~!@$=-' | fold -w "$length" | head -n 1)
  echo "$password"
}

function save_password() {
  local website="$1"
  local password="$2"
  local fileName="passwords.txt"
  if [[ -e "$fileName" ]]; then
    echo "File already exists. Appending password to the file."
  else
    echo "File does not exist. Creating file."
    touch "$fileName"
  fi
  echo "[host: $website | password: $password]" >> "$fileName"
  echo "Password saved to $fileName."
}

fileName="passwords.txt"
if [[ -e "$fileName" ]]; then
  echo "Saved passwords:"
  cat "$fileName" | sed -e 's/password: //g'
  echo
fi

echo "1. Add password"
echo "2. List of saved websites"
echo "3. Get password by website hostname"
echo "4. Exit"

read -p "Enter your choice: " choice

while [[ $choice != 4 ]]; do
  case $choice in
    1)
      echo "Do you want to generate a password or enter one manually?"
      echo "1. Generate password"
      echo "2. Enter password manually"
      read -p "Enter your choice: " passwordChoice
      case $passwordChoice in
        1)
          password=$(generate_password)
          ;;
        2)
          echo "Enter the password: "
          read password
          ;;
        *)
          echo "Invalid choice."
          ;;
      esac
      read -p "Enter the website name: " website
      save_password "$website" "$password"
      ;;
    2)
      echo "List of saved websites:"
      grep -o "\[host: [^ ]*" "$fileName" | sed -e 's/\[host: //g'
      ;;
    3)
      echo "Enter the website hostname: "
      read hostname
      password=$(grep "\[host: $hostname " "$fileName" | sed -e 's/.* | password: //g')
      if [[ -n "$password" ]]; then
        echo "The password for $hostname is $password."
      else
        echo "No password found for $hostname."
      fi
      ;;
    *)
      echo "Invalid choice."
      ;;
  esac

  echo
  echo "1. Add password"
  echo "2. List of saved websites"
  echo "3. Get password by website hostname"
  echo "4. Exit"

  read -p "Enter your choice: " choice
done

echo "Goodbye!"
