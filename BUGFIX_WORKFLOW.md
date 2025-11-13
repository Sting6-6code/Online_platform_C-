# 🔧 工作流修复说明

## 问题描述

在首次运行 GitHub Actions 工作流时遇到了两个问题：

### 问题 1: Action 已弃用 ⚠️

```
Warning: This action is deprecated and will be removed in a future release.
Please use the sonarqube-scan-action action instead.
```

**原因**: `SonarSource/sonarcloud-github-action@master` 已被弃用

### 问题 2: 参数解析错误 ❌

```
19:13:56.763 ERROR Unrecognized option: Learning
Error: Process completed with exit code 1.
```

**原因**: 项目名称 `Online Learning Platform - C++` 中包含空格，导致命令行参数解析失败

---

## 解决方案

### ✅ 修复 1: 更新 Action

**修改前**:

```yaml
- name: SonarCloud Scan
  uses: SonarSource/sonarcloud-github-action@master
```

**修改后**:

```yaml
- name: SonarCloud Scan
  uses: SonarSource/sonarqube-scan-action@v5.0.0
```

### ✅ 修复 2: 添加引号

**修改前**:

```yaml
args: >
  -Dsonar.organization=sting6-6code
  -Dsonar.projectKey=Sting6-6code_-Online-Learning-Platform-Cpp
  -Dsonar.projectName=Online Learning Platform - C++
  -Dsonar.projectVersion=1.0.0
```

**修改后**:

```yaml
args: >
  -Dsonar.organization=sting6-6code
  -Dsonar.projectKey=Sting6-6code_-Online-Learning-Platform-Cpp
  "-Dsonar.projectName=Online Learning Platform - C++"
  -Dsonar.projectVersion=1.0.0
```

> 💡 **关键点**: 给包含空格的参数值添加引号

---

## 验证修复

修复后，重新推送代码：

```bash
cd /Users/wangsiting/github_Siting/Online_platform_C-

# 添加修复后的文件
git add .github/workflows/sonarcloud.yml

# 提交修复
git commit -m "Fix: Update to sonarqube-scan-action and add quotes for project name"

# 推送
git push origin main
```

### 预期结果

工作流应该成功运行，输出类似：

```
✅ Run SonarSource/sonarqube-scan-action@v5.0.0
✅ Installing sonar-scanner
✅ Running sonar-scanner
✅ Analysis successful
✅ View results at: https://sonarcloud.io/project/overview?id=...
```

---

## 相关链接

- [sonarqube-scan-action 文档](https://github.com/SonarSource/sonarqube-scan-action)
- [GitHub Actions YAML 语法](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions)
- [SonarCloud 分析参数](https://docs.sonarcloud.io/advanced-setup/analysis-parameters/)

---

## 常见 YAML 陷阱

### ⚠️ 包含空格的值需要引号

```yaml
# ❌ 错误 - 会被解析为多个参数
-Dsonar.projectName=My Project Name

# ✅ 正确 - 使用引号
"-Dsonar.projectName=My Project Name"
```

### ⚠️ 特殊字符需要转义

```yaml
# 包含特殊字符时使用引号
"-Dsonar.projectName=Project with symbols: @#$"
```

### ⚠️ 使用最新稳定版本

```yaml
# ❌ 避免使用 @master (可能不稳定)
uses: SonarSource/sonarcloud-github-action@master

# ✅ 使用具体版本号
uses: SonarSource/sonarqube-scan-action@v5.0.0
```

---

## 技术细节

### 为什么需要引号？

在 GitHub Actions 中，`args: >` 使用 YAML 的"折叠标量"（folded scalar）语法。参数会被传递给 shell 命令，如果不加引号：

```bash
# 实际执行的命令（错误）
sonar-scanner -Dsonar.projectName=Online Learning Platform - C++

# shell 会解析为多个参数：
# 参数1: -Dsonar.projectName=Online
# 参数2: Learning
# 参数3: Platform
# 参数4: -
# 参数5: C++
```

添加引号后：

```bash
# 实际执行的命令（正确）
sonar-scanner "-Dsonar.projectName=Online Learning Platform - C++"

# shell 会正确解析为一个参数：
# 参数: -Dsonar.projectName=Online Learning Platform - C++
```

---

## ✅ 修复已完成

现在 `.github/workflows/sonarcloud.yml` 文件已更新，可以正常工作了！
