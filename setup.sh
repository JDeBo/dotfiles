#!/usr/bin/env bash

set -e

# Function to print messages
log() {
    echo -e "\033[1;32m$@\033[0m"
}

# Update package index
log "Updating package index..."
sudo apt-get update

# Install Homebrew (Linuxbrew)
/home/linuxbrew/.linuxbrew/bin/brew --version &>/dev/null || {
    log "Installing Homebrew..."
    sudo apt-get install -y build-essential procps curl file git
    NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
}

# Install zsh
zsh --version &>/dev/null || {
    log "Installing zsh..."
    sudo apt-get install -y zsh
}

# Change default shell to zsh if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    log "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
fi

# Install Oh My Zsh
[ -d "$HOME/.oh-my-zsh" ] || {
    log "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Install unzip
unzip -v &>/dev/null || {
    log "Installing unzip..."
    sudo apt-get install -y unzip
}

# Install GitHub CLI
gh --version &>/dev/null || {
    log "Installing GitHub CLI..."
    type -p curl >/dev/null || sudo apt-get install curl -y
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
    sudo apt-add-repository https://cli.github.com/packages
    sudo apt-get update
    sudo apt-get install -y gh
}

# Install AWS CLI (latest)
aws --version &>/dev/null || {
    log "Installing AWS CLI (latest)..."
    tmpdir=$(mktemp -d)
    cd "$tmpdir"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    cd ~
    rm -rf "$tmpdir"
}

# Install Terraform (latest)
terraform --version &>/dev/null || {
    log "Installing Terraform (latest)..."
    brew tap hashicorp/tap
    brew install hashicorp/tap/terraform
}

log "All tools have been installed!"