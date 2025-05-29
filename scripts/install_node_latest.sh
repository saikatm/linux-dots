#!/bin/bash

# Auto-detect system architecture
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        DISTRO="linux-x64"
        ;;
    aarch64|arm64)
        DISTRO="linux-arm64"
        ;;
    armv7l)
        DISTRO="linux-armv7l"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

# Set Node.js Version
VERSION=v24.1.0
INSTALL_FOLDER=/usr/local/lib/nodejs
PACKAGE_NAME=node-$VERSION-$DISTRO

echo "🚀 Installing Node.js $VERSION for $DISTRO..."

# Download prebuilt binaries 
echo "📥 Downloading Node.js..."
curl -O https://nodejs.org/dist/$VERSION/$PACKAGE_NAME.tar.xz

# Verify download
if [ ! -f "$PACKAGE_NAME.tar.xz" ]; then
    echo "❌ Download failed. Exiting."
    exit 1
fi

# Create necessary folders, and extract binaries to install folder
echo "📁 Creating installation directory..."
sudo mkdir -p $INSTALL_FOLDER

echo "📦 Extracting Node.js..."
sudo tar -xJvf $PACKAGE_NAME.tar.xz -C $INSTALL_FOLDER

# Clean up downloaded file
rm $PACKAGE_NAME.tar.xz

# Update profile
FILE=~/.profile
BASHRC=~/.bashrc

# Add to PATH
NODE_PATH="$INSTALL_FOLDER/$PACKAGE_NAME/bin"

echo "🔧 Updating PATH in profile..."

# Add to .profile if it exists
if [ -f "$FILE" ]; then
    # Check if path is already added to avoid duplicates
    if ! grep -q "$NODE_PATH" "$FILE"; then
        echo "export PATH=$NODE_PATH:\$PATH" >> $FILE
        echo "✅ Updated ~/.profile"
    else
        echo "⚠️  PATH already exists in ~/.profile"
    fi
fi

# Add to .bashrc as well for interactive shells
if [ -f "$BASHRC" ]; then
    if ! grep -q "$NODE_PATH" "$BASHRC"; then
        echo "export PATH=$NODE_PATH:\$PATH" >> $BASHRC
        echo "✅ Updated ~/.bashrc"
    else
        echo "⚠️  PATH already exists in ~/.bashrc"
    fi
fi

# Reload environment
export PATH=$NODE_PATH:$PATH

echo ""
echo "🎉 Node.js installation complete!"
echo ""

# Run version reports
echo "📋 Version Information:"
echo "Node.js: $(node -v)"
echo "npm: $(npm -v)"
echo "npx: $(npx -v)"

echo ""
echo "💡 To use Node.js in new terminal sessions, either:"
echo "   1. Restart your terminal, or"
echo "   2. Run: source ~/.profile && source ~/.bashrc"
