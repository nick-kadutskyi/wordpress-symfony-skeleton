#!/bin/bash
WP_DIR="./public-wp"
CONTENT_DIR="./src/WordPressContent"
WP_DEFAULT_PREFIX="wp-default-"
if [ ! -d "$WP_DIR" ]; then
  echo "Not in project root"
  exit 1
fi
if [ ! -e vendor/bin/wp ]; then
  echo "WP-CLI is not present at vendor/bin/wp"
  exit 1
fi
CURRENT_VERSION=$(vendor/bin/wp core version)
INSTALL_RESULT=$(vendor/bin/wp core download --force 2> /dev/null)
for d in public-wp/wp-content/themes/*/ ; do
  if [ -d "$d" ]; then
    THEME_NAME=$(basename "$d")
    THEME_DEST="$CONTENT_DIR/themes/$WP_DEFAULT_PREFIX$THEME_NAME"
    if [ -d "$THEME_DEST" ]; then
      rm -rf "$THEME_DEST"
    fi
    mv "$d" "$THEME_DEST"
  fi
done
for d in public-wp/wp-content/plugins/*/ ; do
  if [ -d "$d" ]; then
    PLUGIN_NAME=$(basename "$d")
    PLUGIN_DEST="$CONTENT_DIR/plugins/$WP_DEFAULT_PREFIX$PLUGIN_NAME"
    if [ -d "$PLUGIN_DEST" ]; then
      rm -rf "$PLUGIN_DEST"
    fi
    mv "$d" "$PLUGIN_DEST"
  fi
done
if [ -f "$WP_DIR/wp-content/plugins/hello.php" ]; then
  mv "$WP_DIR/wp-content/plugins/hello.php" "$CONTENT_DIR/plugins/${WP_DEFAULT_PREFIX}hello.php"
fi
ln -sfhn ../src/WordPressContent public-wp/content
echo "Installed $CURRENT_VERSION"
echo "$INSTALL_RESULT"

