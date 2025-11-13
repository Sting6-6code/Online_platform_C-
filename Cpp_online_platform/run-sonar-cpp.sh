#!/bin/bash

# SonarCloud 分析脚本 - C++ 项目
# 在线学习平台 C++ 实现

echo "═══════════════════════════════════════════════════════════"
echo "  C++ 项目 - SonarCloud 代码质量分析"
echo "═══════════════════════════════════════════════════════════"
echo ""

# SonarCloud 配置
SONAR_TOKEN="352fc59b4650bca70ca4d2c8f273f5012948dcba"
SONAR_ORG="sting6-6code"
SONAR_PROJECT_KEY="Sting6-6code_-Online-Learning-Platform-Cpp"

echo "📋 配置信息:"
echo "   Organization: $SONAR_ORG"
echo "   Project Key: $SONAR_PROJECT_KEY"
echo "   Host: https://sonarcloud.io"
echo ""

# 检查 sonar-scanner 是否安装
if ! command -v sonar-scanner &> /dev/null; then
    echo "❌ sonar-scanner 未安装"
    echo ""
    echo "请先安装 sonar-scanner:"
    echo ""
    echo "macOS (使用 Homebrew):"
    echo "  brew install sonar-scanner"
    echo ""
    echo "或下载："
    echo "  https://docs.sonarcloud.io/advanced-setup/ci-based-analysis/sonarscanner-cli/"
    echo ""
    exit 1
fi

echo "✅ sonar-scanner 已安装: $(sonar-scanner --version | head -1)"
echo ""

echo "🚀 开始代码分析..."
echo ""

# 运行 SonarCloud 分析
sonar-scanner \
  -Dsonar.token="$SONAR_TOKEN" \
  -Dsonar.organization="$SONAR_ORG" \
  -Dsonar.projectKey="$SONAR_PROJECT_KEY" \
  -Dsonar.projectName="Online Learning Platform - C++" \
  -Dsonar.projectVersion="1.0.0" \
  -Dsonar.host.url="https://sonarcloud.io" \
  -Dsonar.sources="." \
  -Dsonar.inclusions="**/*.cpp,**/*.h" \
  -Dsonar.exclusions="**/test_*.cpp,**/model_Main.cpp,model,test_*" \
  -Dsonar.tests="." \
  -Dsonar.test.inclusions="**/test_*.cpp" \
  -Dsonar.sourceEncoding="UTF-8"

if [ $? -eq 0 ]; then
    echo ""
    echo "═══════════════════════════════════════════════════════════"
    echo "  ✅ 分析完成！"
    echo "═══════════════════════════════════════════════════════════"
    echo ""
    echo "🎉 查看分析结果:"
    echo "   https://sonarcloud.io/project/overview?id=$SONAR_PROJECT_KEY"
    echo ""
    echo "或访问:"
    echo "   https://sonarcloud.io/organizations/$SONAR_ORG/projects"
    echo ""
else
    echo ""
    echo "❌ 分析失败，请检查错误信息"
    exit 1
fi

