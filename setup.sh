#!/bin/bash
set -e
cd "$(dirname "$0")"

echo ""
echo "  ╔═══════════════════════════════════════╗"
echo "  ║     CheckBank Tutorial Setup          ║"
echo "  ╚═══════════════════════════════════════╝"
echo ""

echo "==> Installing Flutter dependencies..."
flutter pub get

echo ""
echo "==> Installing docs site dependencies..."
cd docs-site && npm install && cd ..

echo ""
echo "  ✅ Setup complete!"
echo ""
echo "  Next steps:"
echo "    1. Run ./start.sh to launch the tutorial"
echo "    2. Open the project in your IDE:"
echo "      VS Code:         code ."
echo "      Android Studio:  Open the CheckBank/ folder"
echo ""
echo "  Happy testing! 🔍"
