# 🛠️ BHHK TOOLS

Multi-tool collection for Termux. 40+ tools working offline and online.

## 🚀 Installation

```bash
pkg install git -y
git clone https://github.com/arponshs/bhhk-tools.git
cd bhhk-tools
bash install.sh
```

## 🎯 Usage

**Interactive Menu:**
```bash
bhhk-tools
```

**Direct Commands:**
```bash
bhhk-tools b64enc "hello"
bhhk-tools b64dec "aGVsbG8="
bhhk-tools hash "password"
bhhk-tools md5 "text"
bhhk-tools pass 20
bhhk-tools uuid
bhhk-tools myip
bhhk-tools ip 8.8.8.8
```

## 📁 Tool Categories

### 🔐 Encoders / Decoders
- Base64 Encode/Decode
- HEX Encode/Decode
- URL Encode/Decode
- ROT13
- Text → Morse
- Text → Binary
- Reverse Text

### 🔑 Generators
- Password Generator
- Random String
- UUID Generator
- Random Number
- Random Color
- Hashtag Generator
- Hash (MD5/SHA1/SHA256)
- Lorem Ipsum

### 🔨 Converters
- Number Base (2/8/10/16)
- Case Converter
- Temperature (C/F/K)
- Unit Converter (km, kg, m, GB...)
- Number → Roman
- Text → Slug
- HEX → RGB
- Timestamp

### 📊 Analyzers
- Text Statistics
- Password Strength
- BD Phone Info
- Prime Checker
- Age Calculator
- BMI Calculator
- Percentage Calculator
- Word Frequency
- Fibonacci Sequence
- Multiplication Table

### 🌐 Web / Network
- IP Lookup
- My IP
- Domain Info
- URL Shortener
- Email Validator
- QR Code Generator
- Email Extractor
- URL Extractor

### 📱 Utilities
- Progress Bar
- Star Rating
- Dice Roller
- Coin Flip
- Text Repeater
- Date & Time
- Calculator
- Swap Case
- Remove Duplicates
- ASCII Art

## ✨ Features

- ✅ Fully offline (except web tools)
- ✅ No admin/bot required
- ✅ Works on any Termux device
- ✅ 40+ tools included
- ✅ Direct command mode
- ✅ Interactive menu
- ✅ Zero dependencies beyond curl, bc

## ⚠️ License

MIT License — Free for personal use.