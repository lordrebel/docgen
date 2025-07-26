#!/bin/bash
# 定义文件名
PANDOC_VERSION="3.7.0.2"
PANDOC_TAR="pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz"
PANDOC_URL="https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/${PANDOC_TAR}"

# 检查 tar 文件是否存在
if [ ! -f "${PANDOC_TAR}" ]; then
    echo "正在下载 pandoc ${PANDOC_VERSION}..."
    wget "${PANDOC_URL}"
    if [ $? -ne 0 ]; then
        echo "下载失败！"
        exit 1
    fi
else
    echo "发现已存在的 ${PANDOC_TAR}，跳过下载"
fi

# 创建目标目录（如果不存在）
mkdir -p ./pandoc

# 解压
echo "正在解压 ${PANDOC_TAR}..."
tar -xzf "${PANDOC_TAR}" -C ./pandoc --strip-components=1

if [ $? -eq 0 ]; then
    echo "pandoc 安装完成！"
else
    echo "解压失败！"
    exit 1
fi
