# 通过 GitHub 集成 SonarCloud - 最简单方案

## 🎯 这个方案的优势

✅ **无需安装任何本地工具**（不需要 sonar-scanner）  
✅ **自动分析** - 每次 push 到 GitHub 自动触发  
✅ **完全免费** - 公开仓库永久免费  
✅ **Java 和 C++ 同时分析** - 一次配置，分析所有代码

---

## 📋 操作步骤

### 步骤 1: 确保代码已推送到 GitHub

检查您的仓库：

- GitHub 仓库名称：`-Online-Learning-Platform`
- GitHub 用户名：`Sting6-6code`
- 仓库地址：`https://github.com/Sting6-6code/-Online-Learning-Platform`

确保最新代码已推送：

```bash
cd /Users/wangsiting/github_Siting/-Online-Learning-Platform
git status
git add .
git commit -m "Add SonarCloud configuration"
git push
```

---

### 步骤 2: 在 SonarCloud 导入 GitHub 仓库

1. **访问 SonarCloud**  
   https://sonarcloud.io

2. **点击右上角 "+" 按钮**  
   选择 "Analyze new project"

3. **选择 "From GitHub"**（而不是 Manually）

   - 如果尚未授权，点击 "GitHub" 授权 SonarCloud 访问您的仓库
   - 授权后，您会看到您的 GitHub 组织和仓库列表

4. **选择仓库**  
   找到并勾选 `-Online-Learning-Platform` 仓库

5. **点击 "Set Up"**

---

### 步骤 3: 配置分析

SonarCloud 会自动检测到：

- ✅ Java 项目（通过 `pom.xml`）
- ✅ C++ 项目（通过 `.cpp` 和 `.h` 文件）

**选择分析方法：**

- 选择 "GitHub Actions" (推荐)
- 或选择 "Automatic Analysis" (最简单，无需配置)

---

### 步骤 4: (推荐) 使用 GitHub Actions 自动分析

如果选择 GitHub Actions，SonarCloud 会提供配置文件。

我已经为您准备好了配置文件，请看下一节。

---

## 🔧 GitHub Actions 配置文件

创建文件 `.github/workflows/sonarcloud.yml`:

```yaml
name: SonarCloud Analysis

on:
  push:
    branches:
      - main
      - master
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  sonarcloud:
    name: SonarCloud Analysis
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0 # 完整历史记录，用于更好的分析

      # Java 项目分析
      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          java-version: "11"
          distribution: "temurin"

      - name: Cache Maven packages
        uses: actions/cache@v3
        with:
          path: ~/.m2
          key: ${{ runner.os }}-m2-${{ hashFiles('**/pom.xml') }}
          restore-keys: ${{ runner.os }}-m2

      - name: Build and analyze Java project
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        run: |
          cd Java_online_platform
          mvn clean verify sonar:sonar \
            -Dsonar.projectKey=Sting6-6code_-Online-Learning-Platform \
            -Dsonar.organization=sting6-6code \
            -Dsonar.host.url=https://sonarcloud.io

      # C++ 项目分析
      - name: Install sonar-scanner
        run: |
          wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip
          unzip -q sonar-scanner-cli-4.8.0.2856-linux.zip
          echo "${PWD}/sonar-scanner-4.8.0.2856-linux/bin" >> $GITHUB_PATH

      - name: Analyze C++ project
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        run: |
          cd Cpp_online_platform
          sonar-scanner \
            -Dsonar.projectKey=Sting6-6code_-Online-Learning-Platform-Cpp \
            -Dsonar.organization=sting6-6code \
            -Dsonar.host.url=https://sonarcloud.io \
            -Dsonar.sources=. \
            -Dsonar.inclusions=**/*.cpp,**/*.h \
            -Dsonar.exclusions=**/test_*.cpp,**/model_Main.cpp,model,test_* \
            -Dsonar.tests=. \
            -Dsonar.test.inclusions=**/test_*.cpp
```

---

### 步骤 5: 添加 SONAR_TOKEN 到 GitHub Secrets

1. **在 GitHub 仓库页面**  
   访问：`https://github.com/Sting6-6code/-Online-Learning-Platform/settings/secrets/actions`

2. **点击 "New repository secret"**

3. **添加 Secret**

   - Name: `SONAR_TOKEN`
   - Value: `352fc59b4650bca70ca4d2c8f273f5012948dcba`

4. **点击 "Add secret"**

---

### 步骤 6: 推送配置并触发分析

```bash
cd /Users/wangsiting/github_Siting/-Online-Learning-Platform

# 创建 GitHub Actions 目录
mkdir -p .github/workflows

# 创建配置文件（手动复制上面的 YAML 内容）

# 提交并推送
git add .github/workflows/sonarcloud.yml
git add Cpp_online_platform/sonar-project.properties
git add Cpp_online_platform/run-sonar-cpp.sh
git commit -m "Add SonarCloud GitHub Actions integration"
git push
```

推送后，GitHub Actions 会自动运行并分析代码！

---

## 📊 查看分析结果

### 方法 1: GitHub Actions 界面

访问：`https://github.com/Sting6-6code/-Online-Learning-Platform/actions`

### 方法 2: SonarCloud 仪表板

**Java 项目：**  
https://sonarcloud.io/project/overview?id=Sting6-6code_-Online-Learning-Platform

**C++ 项目：**  
https://sonarcloud.io/project/overview?id=Sting6-6code_-Online-Learning-Platform-Cpp

**所有项目：**  
https://sonarcloud.io/organizations/sting6-6code/projects

---

## 🎉 使用 "Automatic Analysis" (最简单)

如果您不想配置 GitHub Actions，可以使用自动分析：

1. 在 SonarCloud 导入仓库时
2. 选择 "Automatic Analysis"
3. SonarCloud 会在每次 push 后自动分析
4. **无需任何配置文件！**

**限制：**

- 自动分析不支持代码覆盖率
- 分析可能不如 GitHub Actions 详细

**推荐：**

- 对于 Java 项目：使用 Maven 插件（已配置）
- 对于 C++ 项目：使用 Automatic Analysis

---

## 🔍 两个项目的配置对比

| 项目 | 分析方式                    | 配置文件                            |
| ---- | --------------------------- | ----------------------------------- |
| Java | Maven 插件                  | `pom.xml` (已配置)                  |
| C++  | GitHub Actions 或 Automatic | `sonar-project.properties` (已创建) |

---

## 💡 总结

**最简单的方式（推荐给您）：**

1. ✅ Java 项目：已经成功分析过了，无需额外配置
2. ✅ C++ 项目：在 SonarCloud 导入仓库，选择 "Automatic Analysis"
3. ✅ 结果：两个项目都会自动分析，无需本地工具

**下一步：**

1. 访问 https://sonarcloud.io
2. 点击 "+" → "Analyze new project" → "From GitHub"
3. 选择您的仓库
4. 选择 "Automatic Analysis"
5. 完成！

---
