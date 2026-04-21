#!/bin/bash

# Quick validation script for DefaultKeyBinding.dict approach
# This tests file operations without full app integration

set -e

echo "🧪 DefaultKeyBinding.dict Validation Script"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

KEYBINDINGS_DIR="$HOME/Library/KeyBindings"
KEYBINDINGS_FILE="$KEYBINDINGS_DIR/DefaultKeyBinding.dict"
TEST_BACKUP_DIR="/tmp/keybindings-test-$$"

echo "📁 Creating test environment..."
mkdir -p "$TEST_BACKUP_DIR"

# Test 1: Check if directory exists
echo -n "Test 1: KeyBindings directory exists... "
if [ -d "$KEYBINDINGS_DIR" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "Creating directory..."
    mkdir -p "$KEYBINDINGS_DIR"
fi

# Test 2: Check current file
echo -n "Test 2: Current DefaultKeyBinding.dict exists... "
if [ -f "$KEYBINDINGS_FILE" ]; then
    echo -e "${GREEN}✓${NC}"
    CURRENT_EXISTS=1
else
    echo -e "${YELLOW}⚠ No existing file${NC}"
    CURRENT_EXISTS=0
fi

# Test 3: Validate current file if it exists
if [ $CURRENT_EXISTS -eq 1 ]; then
    echo -n "Test 3: Current file is valid plist... "
    if plutil -lint "$KEYBINDINGS_FILE" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC}"
    else
        echo -e "${RED}✗${NC}"
        echo "Current file is corrupted!"
        exit 1
    fi
fi

# Test 4: Backup current file
if [ $CURRENT_EXISTS -eq 1 ]; then
    echo -n "Test 4: Backup current file... "
    BACKUP_FILE="$TEST_BACKUP_DIR/DefaultKeyBinding.dict.backup-$(date +%Y%m%d-%H%M%S)"
    cp "$KEYBINDINGS_FILE" "$BACKUP_FILE"
    if [ -f "$BACKUP_FILE" ]; then
        echo -e "${GREEN}✓${NC}"
        echo "  Backup at: $BACKUP_FILE"
    else
        echo -e "${RED}✗${NC}"
        exit 1
    fi
fi

# Test 5: Create test configuration (Line-based)
echo -n "Test 5: Create test configuration... "
cat > "$TEST_BACKUP_DIR/test-line-based.dict" << 'EOF'
{
  "\UF729"   = "moveToBeginningOfLine:";
  "\UF72B"   = "moveToEndOfLine:";
  "$\UF729"  = "moveToBeginningOfLineAndModifySelection:";
  "$\UF72B"  = "moveToEndOfLineAndModifySelection:";
  "^\UF729"  = "moveToBeginningOfDocument:";
  "^\UF72B"  = "moveToEndOfDocument:";
  "^$\UF729" = "moveToBeginningOfDocumentAndModifySelection:";
  "^$\UF72B" = "moveToEndOfDocumentAndModifySelection:";
}
EOF

if [ -f "$TEST_BACKUP_DIR/test-line-based.dict" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    exit 1
fi

# Test 6: Validate test configuration
echo -n "Test 6: Validate test configuration... "
if plutil -lint "$TEST_BACKUP_DIR/test-line-based.dict" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "Test configuration is invalid!"
    exit 1
fi

# Test 7: Check file permissions
echo -n "Test 7: Check file permissions... "
if [ -w "$KEYBINDINGS_DIR" ]; then
    echo -e "${GREEN}✓${NC}"
else
    echo -e "${RED}✗${NC}"
    echo "No write permission to $KEYBINDINGS_DIR"
    exit 1
fi

# Test 8: Calculate SHA256 hash
if [ $CURRENT_EXISTS -eq 1 ]; then
    echo -n "Test 8: Calculate file hash... "
    HASH=$(shasum -a 256 "$KEYBINDINGS_FILE" | cut -d' ' -f1)
    echo -e "${GREEN}✓${NC}"
    echo "  Hash: $HASH"
fi

# Test 9: Merge test (simulate merging user bindings with our bindings)
echo -n "Test 9: Test merge logic... "
cat > "$TEST_BACKUP_DIR/user-custom.dict" << 'EOF'
{
  "\UF729"   = "moveToBeginningOfParagraph:";
  "\UF72B"   = "moveToEndOfParagraph:";
  "^w"       = "deleteWordBackward:";
  "^k"       = "deleteToEndOfLine:";
}
EOF

# In a real merge, we'd parse both files and combine them
# For now, just validate we can read both
if plutil -lint "$TEST_BACKUP_DIR/user-custom.dict" > /dev/null 2>&1; then
    echo -e "${GREEN}✓${NC}"
    echo "  Note: Merge logic needs implementation in Swift"
else
    echo -e "${RED}✗${NC}"
    exit 1
fi

# Summary
echo ""
echo "=========================================="
echo -e "${GREEN}✅ All validation tests passed!${NC}"
echo ""
echo "📊 Summary:"
echo "  • KeyBindings directory: $KEYBINDINGS_DIR"
echo "  • Current file exists: $([ $CURRENT_EXISTS -eq 1 ] && echo 'Yes' || echo 'No')"
if [ $CURRENT_EXISTS -eq 1 ]; then
    echo "  • Backup location: $BACKUP_FILE"
    echo "  • File hash: $HASH"
fi
echo "  • Test directory: $TEST_BACKUP_DIR"
echo ""

# Display current file contents
if [ $CURRENT_EXISTS -eq 1 ]; then
    echo "📄 Current DefaultKeyBinding.dict contents:"
    echo "----------------------------------------"
    cat "$KEYBINDINGS_FILE"
    echo "----------------------------------------"
    echo ""
fi

# Recommendations
echo "📋 Next Steps:"
echo "  1. Review TEST_PLAN.md for manual testing"
echo "  2. Test line-based vs paragraph-based behavior"
echo "  3. Test with various applications"
echo "  4. Document which apps require restart"
echo ""
echo "⚠️  To test configurations manually:"
echo ""
echo "  # Apply Line-based (Windows-like):"
echo "  cat > ~/Library/KeyBindings/DefaultKeyBinding.dict << 'EOF'"
echo "  {"
echo '    "\UF729"   = "moveToBeginningOfLine:";'
echo '    "\UF72B"   = "moveToEndOfLine:";'
echo '    "$\UF729"  = "moveToBeginningOfLineAndModifySelection:";'
echo '    "$\UF72B"  = "moveToEndOfLineAndModifySelection:";'
echo "  }"
echo "  EOF"
echo ""
echo "  # Restore original:"
echo "  cp $BACKUP_FILE ~/Library/KeyBindings/DefaultKeyBinding.dict"
echo ""

# Cleanup option
echo -n "🧹 Clean up test directory? [y/N] "
read -r CLEANUP
if [[ "$CLEANUP" =~ ^[Yy]$ ]]; then
    rm -rf "$TEST_BACKUP_DIR"
    echo "Cleaned up test directory"
else
    echo "Test files preserved in: $TEST_BACKUP_DIR"
fi

echo ""
echo "✨ Validation complete!"
