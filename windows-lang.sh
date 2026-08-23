#!/usr/bin/env bash

LANG_DIR="$HOME/.windows-lang"
mkdir -p "$LANG_DIR"

case $1 in
    list)
        echo "可用语言列表："
        for f in "$LANG_DIR"/*.lang; do
            [ -f "$f" ] || continue
            code=$(basename "$f" .lang)
            name=$(grep "^LANG_NAME=" "$f" | cut -d'"' -f2)
            current=""
            [ -f "$LANG_DIR/lang.conf" ] && [ "$(cat "$LANG_DIR/lang.conf")" = "$code" ] && current=" (当前)"
            echo "  $code - $name$current"
        done
        ;;
    set)
        if [ -z "$2" ]; then
            echo "用法: windows-lang set <语言代码>"
            echo "示例: windows-lang set en-US"
            exit 1
        fi
        if [ ! -f "$LANG_DIR/$2.lang" ]; then
            echo "错误：语言 '$2' 不存在"
            echo "可用语言："
            for f in "$LANG_DIR"/*.lang; do
                [ -f "$f" ] && basename "$f" .lang
            done
            exit 1
        fi
        echo "$2" > "$LANG_DIR/lang.conf"
        echo "语言已切换为：$(grep "^LANG_NAME=" "$LANG_DIR/$2.lang" | cut -d'"' -f2)"
        ;;
    current)
        if [ -f "$LANG_DIR/lang.conf" ]; then
            code=$(cat "$LANG_DIR/lang.conf")
            name=$(grep "^LANG_NAME=" "$LANG_DIR/$code.lang" | cut -d'"' -f2)
            echo "当前语言：$code - $name"
        else
            echo "当前语言：zh-CN - 简体中文 (默认)"
        fi
        ;;
    create|add)
        echo "创建语言包功能已集成到主脚本，请使用 windows lang add 或直接编辑 $LANG_DIR/"
        ;;
    *)
        echo "用法: windows-lang {list|set|current}"
        echo "  list     列出所有可用语言"
        echo "  set      切换语言 (如: windows-lang set en-US)"
        echo "  current  显示当前语言"
        ;;
esac
