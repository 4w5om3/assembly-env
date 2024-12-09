# Hướng dẫn Cài đặt Môi trường Phát triển Assembly (Assembly Development Environment Setup)

[English Version](readme-en.md)

## Mục lục (Table of Contents)
- [Bắt đầu nhanh (Quick Start)](#bắt-đầu-nhanh)
- [Yêu cầu hệ thống (System Requirements)](#yêu-cầu-hệ-thống)
- [Hướng dẫn cài đặt (Installation Guide)](#hướng-dẫn-cài-đặt)
  - [Cài đặt trên Windows (Windows Setup)](#cài-đặt-trên-windows)
  - [Cài đặt trên Linux (Linux Setup)](#cài-đặt-trên-linux)
- [Kiểm tra môi trường (Testing Environment)](#kiểm-tra-môi-trường)
- [Các vấn đề thường gặp (Common Issues)](#các-vấn-đề-thường-gặp)

## Bắt đầu nhanh (Quick Start)
Nếu bạn đã có sẵn môi trường (If you already have the environment setup):
1. Cài đặt các gói cần thiết (Install required packages):
   - Cho Windows (WSL): Sử dụng lệnh của Debian/Ubuntu sau khi kết nối WSL
   - Cho Linux: Sử dụng package manager của bản phân phối của bạn
2. Clone repository: `git clone https://github.com/4w5om3/assembly-env.git`
3. Test môi trường: `make run FILE=div1`

## Yêu cầu hệ thống (System Requirements)

### Cho người dùng Windows (For Windows Users)
- Windows 10 trở lên (Windows 10 or above)
- Quyền Admin (Administrator privileges)
- Ít nhất 4GB disk space trống (recommended)

### Cho người dùng Linux (For Linux Users)
- Bất kỳ Linux distro nào
- Kiến thức cơ bản về command line (Basic command line knowledge)

## Hướng dẫn cài đặt (Installation Guide)

### Cài đặt trên Windows (Windows Setup)

1. **Cài đặt WSL (Install WSL)**
   - Mở PowerShell với quyền Admin (Run as Administrator)
   - Chạy lệnh (Run command): `wsl --install --no-distribution`
   - Restart máy tính khi được yêu cầu
   - Sau khi restart, chạy: `wsl --install -d Debian`
   - Setup username và password Linux khi được yêu cầu
   
   Note: Bạn có thể xem list các distro có sẵn bằng lệnh `wsl -l --online`

2. **Cài đặt VSCode (Install VSCode)**
   - Download VSCode từ [đây](https://code.visualstudio.com/download)
   - Install WSL extension trong VSCode
   - Connect to WSL:
     - Click vào icon Remote ở góc dưới bên trái
     - Chọn "Connect to WSL"
     
     ![Remote](./image/remote.png)

     ![Connect to WSL](./image/connect.png)

3. **Cài đặt các package cần thiết (trong WSL)**
   - Open VSCode
   - Connect to WSL (nếu chưa connect)
   - Open terminal trong VSCode (Ctrl + ` hoặc View -> Terminal)
   - Install packages:
     ```bash
     sudo apt update && sudo apt upgrade
     sudo apt install nasm binutils make git gcc
     ```

4. **Setup môi trường development**
   - Clone repository và chuyển đến project directory:
     ```bash
     git clone https://github.com/4w5om3/assembly-env.git
     cd assembly-env
     code .
     ```

### Cài đặt trên Linux (Linux Setup)

1. **Cài đặt VSCode (Install VSCode)**
   - Cho Debian/Ubuntu-based distros:
     ```bash
     sudo apt-get install wget gpg
     wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
     sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
     sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
     rm -f packages.microsoft.gpg
     sudo apt install apt-transport-https
     sudo apt update
     sudo apt install code
     ```
   
   - Cho Arch Linux:
     ```bash
     sudo pacman -S code
     ```
   
   - Cho Fedora:
     ```bash
     sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
     sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
     sudo dnf update
     sudo dnf install code
     ```

   Hoặc bạn có thể download và install VSCode trực tiếp từ [official website](https://code.visualstudio.com/download).

2. **Install các package cần thiết**
   Chọn distro của bạn và chạy các lệnh tương ứng:

   #### Ubuntu/Debian/Linux Mint
   ```bash
   sudo apt update && sudo apt upgrade
   sudo apt install nasm binutils make git gcc
   ```

   #### Arch Linux
   ```bash
   sudo pacman -Syy && sudo pacman -Syyu
   sudo pacman -S nasm binutils make git gcc
   ```

   #### Fedora
   ```bash
   sudo dnf update && sudo dnf upgrade
   sudo dnf install nasm binutils make git gcc
   ```

3. **Setup môi trường development**
   - Open VSCode
   - Open terminal trong VSCode (Ctrl + ` hoặc View -> Terminal)
   - Clone repository và chuyển đến project folder:
     ```bash
     git clone https://github.com/4w5om3/assembly-env.git
     cd assembly-env
     code .
     ```

## Các lệnh Linux cơ bản (Basic Linux Commands)

Dưới đây là một số command thiết yếu bạn sẽ cần:

### File và Directory Operations
```bash
# Create new file
touch filename.s

# Create new directory
mkdir folder_name

# Navigate directories
cd folder_name    # Go to folder
cd ..            # Go back
cd               # Go to home directory

# List directory contents
ls               # List files and folders
ls -la          # List with details and hidden files

# Remove files/directories
rm filename      # Remove a file
rm -r foldername # Remove folder and contents

# Copy và Move
cp file1 file2   # Copy file1 to file2
mv file1 file2   # Move/rename file1 to file2

# View file contents
cat filename     # Display file contents
nano filename    # Edit file with nano
code filename    # Open file in VSCode
```

## Kiểm tra môi trường (Testing Environment)

1. View available make commands:
   ```bash
   make help
   ```
   Command này sẽ show tất cả các lệnh có sẵn và cách sử dụng.

2. Run test program:
   ```bash
   make run FILE=div1
   ```
   Expected output:
   ```
   The quotient is 3
   The remainder is 1
   ```

3. Cleanup:
   ```bash
   make clean
   ```

## Các vấn đề thường gặp (Common Issues)

- Nếu terminal không show trong VSCode, press `Ctrl + `` hoặc vào View -> Terminal
- Đảm bảo type password Linux cẩn thận trong quá trình setup WSL (các ký tự sẽ không hiển thị)
- Nếu gặp permission issues, đảm bảo bạn đang run PowerShell với quyền Admin
- Đối với Windows users, đảm bảo bạn đang ở trong WSL terminal (nó sẽ show Linux username của bạn) khi run các command
