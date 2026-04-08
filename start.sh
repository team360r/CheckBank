#!/bin/bash
cd "$(dirname "$0")/docs-site"
echo ""
echo "  Starting CheckBank Tutorial..."
echo "  Tutorial will open at http://localhost:3000"
echo ""
echo "  In another terminal, run the Flutter app:"
echo "    flutter run"
echo ""
npm start
