# NixOS Configuration - Naos

Bu repo, Hyprland, Caelestia Shell, Kitty ve diğer modern Linux araçları ile önceden yapılandırılmış bir NixOS sistemi içerir.

## 🚀 Hızlı Kurulum

### Ön Gereksinimler

1. **EFI Boot Partition**: Sisteminizde en az **300MB** EFI boot bölümü bulunmalıdır
2. **NixOS Live USB**: NixOS installer ile bootlayın
3. **İnternet Bağlantısı**: Kurulum sırasında internet gereklidir

### Kurulum Adımları

1. **Repository'yi klonlayın:**
   ```bash
   git clone https://github.com/dpentx/naosv2
   cd naosv2
   ```

2. **Kullanıcı adını değiştirin:**
   
   Konfigürasyondaki `asus` kullanıcı adını kendi kullanıcı adınızla değiştirin:
   
   ```bash
   # Tüm dosyalarda 'asus' kelimesini arayın
   grep -r "asus" . --include="*.nix"
   ```
   
   **Değiştirmeniz gereken dosyalar:**
   - `flake.nix` → `nixosConfigurations.asus` ve `home-manager.users.asus`
   - `nixos/configuration.nix` → `users.users.asus`
   - `home.nix` → `home.username` ve `home.homeDirectory`
   - `modules/hyprland.nix` → wallpaper yolu (`/home/asus/wallpaper/`)

3. **Hostname değiştirin (isteğe bağlı):**
   ```bash
   # nixos/configuration.nix içinde:
   networking.hostName = "YOUR_HOSTNAME";
   ```

4. **Sistem konfigürasyonunu uygulayın:**
   ```bash
   sudo nixos-rebuild switch --flake .#asus
   ```
   
   ⚠️ **Not**: `#asus` kısmını kendi flake configuration adınızla değiştirin.

## 📁 Proje Yapısı

```
naos/
├── flake.nix                      # Ana flake konfigürasyonu
├── flake.lock                     # Dependency kilit dosyası
├── nixos/
│   ├── configuration.nix          # Sistem konfigürasyonu
│   └── hardware-configuration.nix # Donanım konfigürasyonu
├── home.nix                       # Home Manager ana dosyası
└── modules/
    ├── hyprland.nix              # Hyprland window manager
    ├── terminal.nix              # Kitty terminal ayarları
    ├── launcher.nix              # Wofi launcher ayarları
    └── shell.nix                 # Zsh & Starship yapılandırması
```

## 🎨 Özellikler

### Desktop Environment
- **Hyprland**: Modern Wayland compositor
- **Caelestia Shell**: QuickShell tabanlı masaüstü ortamı
- **SDDM**: Display manager (Wayland desteği)
- **Nordic Cursor**: Şık cursor teması

### Tema & Görünüm
- **Catppuccin Mocha**: Koyu tema renk paleti
- **Papirus Icons**: Modern ikon paketi
- **JetBrains Mono Nerd Font**: Developer-friendly font
- **Transparent effects**: Blur ve transparency desteği

### Terminal & Shell
- **Kitty**: GPU-accelerated terminal (opacity: 0.8)
- **Zsh**: Modern shell with advanced completion
- **Starship**: Hızlı ve özelleştirilebilir prompt

### Uygulamalar
- **Microsoft Edge**: Web browser
- **Code Cursor**: AI-powered code editor
- **Spotify + Spicetify**: Müzik player (Catppuccin teması)
- **Thunar**: File manager
- **OnlyOffice**: Office suite

### Sistem Araçları
- **Dunst**: Notification daemon
- **SWWW**: Wallpaper manager
- **Grim + Slurp**: Screenshot tools
- **Wofi**: Application launcher
- **Bluetooth Audio Fix**: Özel bluetooth ses düzeltme scripti

## 🔧 Özelleştirme Kılavuzu

### Kullanıcı Adını Değiştirme

1. **flake.nix** - 2 yerde değiştirin:
   ```nix
   nixosConfigurations.YENI_HOSTNAME = nixpkgs.lib.nixosSystem {
     # ...
   };
   # ve
   home-manager.users.YENI_KULLANICI_ADI = {
   ```

2. **nixos/configuration.nix**:
   ```nix
   users.users.YENI_KULLANICI_ADI = {
     isNormalUser = true;
     description = "YENI_KULLANICI_ADI";
     # ...
   };
   ```

3. **home.nix**:
   ```nix
   home.username = "YENI_KULLANICI_ADI";
   home.homeDirectory = "/home/YENI_KULLANICI_ADI";
   ```

4. **modules/hyprland.nix** - wallpaper yolunu güncelleyin:
   ```nix
   "swww img /home/YENI_KULLANICI_ADI/wallpaper/wallpaper.jpg"
   ```

### Yeniden Derleme

Değişiklik yaptıktan sonra:

```bash
sudo nixos-rebuild switch --flake .#YENI_HOSTNAME
```

## ⌨️ Önemli Kısayollar

### Temel Kısayollar
| Kısayol | Aksiyon |
|---------|---------|
| `Super + Q` | Terminal (Kitty) |
| `Super + E` | File Manager (Thunar) |
| `Super + R` | App Launcher (Wofi) |
| `Super + Space` | Fuzzel launcher |
| `Super + C` | Close window |
| `Super + M` | Exit Hyprland |

### Screenshot
| Kısayol | Aksiyon |
|---------|---------|
| `Super + S` | Hyprshot region |
| `Super + Print` | Grim region to clipboard |
| `Print` | Full screen to clipboard |
| `Super + Shift + S` | Save to ~/Pictures/Screenshots/ |

### Sistem Kontrolleri
| Kısayol | Aksiyon |
|---------|---------|
| `Super + Shift + A` | Pavucontrol (Ses) |
| `Super + Shift + B` | Blueman (Bluetooth) |
| `Super + Shift + N` | Network Manager |
| `Super + Shift + Q` | Caelestia Shell restart |

### Media Controls
- **Volume**: `XF86Audio` tuşları veya `Super + Equals/Minus`
- **Brightness**: `XF86MonBrightness` tuşları
- **Media**: `XF86AudioPlay/Next/Previous`

## 💻 Sistem Gereksinimleri

- **GPU**: NVIDIA (stable driver)
- **CPU**: Intel (mikrocode güncellemeleri dahil)
- **Audio**: PipeWire + PulseAudio compatibility
- **Bluetooth**: BlueZ with A2DP support
- **Kernel**: Linux Zen

## 🐛 Sorun Giderme

### Boot Problemi
```bash
# EFI partition boyutunu kontrol edin
lsblk
# En az 300MB olmalı
```

### Flake Güncellemeleri
```bash
# Flake'i güncelleyin
nix flake update

# Cache'i temizleyin
sudo nix-collect-garbage -d
```

### Caelestia Shell Sorunları
```bash
# Shell'i yeniden başlatın
pkill quickshell && sleep 0.1 && quickshell &

# Veya kısayol ile
Super + Shift + Q
```

### Bluetooth Ses Sorunları
```bash
# Bluetooth ses scripti çalıştırın
~/.config/scripts/bluetooth-audio-fix.sh fix

# Veya kısayol ile ses kontrolü
Super + Equals/Minus
```

### Wallpaper Ayarları
```bash
# Wallpaper dizini oluşturun
mkdir -p ~/wallpaper/
# wallpaper.jpg dosyanızı buraya koyun
```

## 🌟 Özel Özellikler

### Caelestia Shell
- QuickShell tabanlı modern masaüstü ortamı
- Sistem durumu göstergeleri
- Özelleştirilebilir bar ve widget'lar

### Bluetooth Audio Fix
- A2DP profil otomatik geçişi
- Ses seviyesi bildirimleri
- QuickShell entegrasyonu

### Spicetify Integration
- Spotify için Catppuccin Mocha teması
- Adblock, shuffle+ extensions
- Rotating cover art

## 📝 Sistem Bilgileri

- **NixOS Version**: 25.05 (unstable)
- **Window Manager**: Hyprland
- **Display Manager**: SDDM (Wayland)
- **Audio**: PipeWire
- **Theme**: Catppuccin Mocha
- **Font**: JetBrains Mono Nerd Font
- **Locale**: Turkish (TR)

---

**⚠️ Önemli Notlar:**
- Kurulum öncesi mevcut sisteminizin yedeğini alın
- NVIDIA GPU gereklidir (stable driver kullanılıyor)
- Caelestia Shell için QuickShell dependency'si otomatik yüklenir
- Bluetooth cihazlar için özel ses düzeltme scripti dahildir
