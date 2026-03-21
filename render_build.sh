#!/bin/bash
set -e  # Stop immediately if any command fails

echo "Cloning Flutter stable..."
git clone https://github.com/flutter/flutter.git -b stable

echo "Adding Flutter to PATH..."
export PATH="$PATH:$PWD/flutter/bin"

echo "Enabling web support..."
flutter config --enable-web

echo "Going into the view folder..."
cd view

echo "Getting dependencies..."
flutter pub get

echo "Building Flutter Web release..."
flutter build web --release

echo "Flutter Web build complete!"