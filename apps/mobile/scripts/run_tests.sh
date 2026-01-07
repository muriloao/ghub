#!/bin/bash

# GHub Mobile - Test Runner Script

set -e

echo "🧪 GHub Mobile - Running Unit Tests"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}📦 Installing dependencies...${NC}"
flutter pub get

echo ""
echo -e "${BLUE}🔨 Generating code (if needed)...${NC}"
dart run build_runner build --delete-conflicting-outputs || true

echo ""
echo -e "${BLUE}🔧 Generating mocks...${NC}"
dart run build_runner build --delete-conflicting-outputs

echo ""
echo -e "${BLUE}🧪 Running all unit tests...${NC}"

# Run tests with coverage if --coverage flag is passed
if [ "$1" = "--coverage" ]; then
    echo -e "${YELLOW}📊 Running tests with coverage...${NC}"
    flutter test --coverage
    
    echo ""
    echo -e "${BLUE}📈 Generating coverage report...${NC}"
    genhtml coverage/lcov.info -o coverage/html
    
    echo -e "${GREEN}✅ Coverage report generated in coverage/html/index.html${NC}"
else
    flutter test
fi

echo ""
echo -e "${GREEN}✅ All tests completed successfully!${NC}"
echo ""

# Test specific features
if [ "$1" = "--auth" ]; then
    echo -e "${BLUE}🔐 Running Auth tests only...${NC}"
    flutter test test/features/auth/
elif [ "$1" = "--games" ]; then
    echo -e "${BLUE}🎮 Running Games tests only...${NC}"
    flutter test test/features/games/
elif [ "$1" = "--core" ]; then
    echo -e "${BLUE}⚙️  Running Core tests only...${NC}"
    flutter test test/core/
elif [ "$1" = "--help" ]; then
    echo ""
    echo -e "${YELLOW}Usage:${NC}"
    echo "  ./scripts/run_tests.sh              # Run all tests"
    echo "  ./scripts/run_tests.sh --coverage   # Run tests with coverage"
    echo "  ./scripts/run_tests.sh --auth       # Run auth tests only"
    echo "  ./scripts/run_tests.sh --games      # Run games tests only"
    echo "  ./scripts/run_tests.sh --core       # Run core tests only"
    echo "  ./scripts/run_tests.sh --help       # Show this help"
    echo ""
fi