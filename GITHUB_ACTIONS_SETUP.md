# GitHub Actions 自动 SonarCloud 扫描设置指南

## 📋 概述

本指南将帮助你配置 GitHub Actions，实现代码推送到 GitHub 后自动触发 SonarCloud 扫描。

---

## 🚀 设置步骤

### 步骤 1: 配置 GitHub Secrets

你需要在 GitHub 仓库中添加 SonarCloud Token。

#### 1.1 添加 SONAR_TOKEN

1. 打开你的 GitHub 仓库
2. 点击 **Settings** (设置)
3. 在左侧菜单中找到 **Secrets and variables** → **Actions**
4. 点击 **New repository secret** (新建仓库密钥)
5. 添加以下密钥：

   - **Name**: `SONAR_TOKEN`
   - **Value**: `你的 SonarCloud Token`（从下方"步骤 2"获取）

   > ⚠️ **重要提示**: Token 是敏感信息，只能添加到 GitHub Secrets，不要泄露或提交到代码仓库。

#### 1.2 验证 GITHUB_TOKEN

`GITHUB_TOKEN` 是 GitHub Actions 自动提供的，无需手动添加。

---

### 步骤 2: 生成新的 SonarCloud Token (如果需要)

如果你需要生成新的 Token：

1. 访问 [SonarCloud](https://sonarcloud.io)
2. 登录你的账号
3. 点击右上角头像 → **My Account**
4. 选择 **Security** 标签
5. 在 **Generate Tokens** 部分：
   - 输入 Token 名称 (例如: `github-actions-token`)
   - 点击 **Generate**
6. 复制生成的 Token
7. 将其添加到 GitHub Secrets (参见步骤 1.1)

---

### 步骤 3: 推送工作流文件到 GitHub

现在你需要将新创建的 GitHub Actions 工作流文件推送到 GitHub：

```bash
# 进入项目目录
cd /path/to/your/project

# 查看更改
git status

# 添加工作流文件
git add .github/workflows/sonarcloud.yml

# 添加本设置指南
git add GITHUB_ACTIONS_SETUP.md QUICK_START_AUTO_SCAN.md

# 提交更改
git commit -m "Add GitHub Actions workflow for automatic SonarCloud scanning"

# 推送到 GitHub
git push origin main
```

---

## 🔍 工作流说明

### 触发条件

工作流将在以下情况自动运行：

1. **推送到主分支** (`main`, `master`, `develop`)
2. **创建或更新 Pull Request**

### 工作流内容

创建的 `.github/workflows/sonarcloud.yml` 文件包含以下步骤：

1. **Checkout 代码**: 获取仓库代码
2. **安装依赖**: 安装 C++ 编译工具
3. **构建项目** (可选): 生成编译信息
4. **SonarCloud 扫描**: 使用 `sonarqube-scan-action@v5.0.0` 执行代码质量分析

> 📝 **注意**: 工作流使用最新的 `sonarqube-scan-action` (旧版 `sonarcloud-github-action` 已弃用)

---

## ✅ 验证设置

### 方法 1: 查看 GitHub Actions 运行状态

1. 推送代码后，访问你的 GitHub 仓库
2. 点击 **Actions** 标签
3. 你应该看到 "SonarCloud Analysis" 工作流正在运行
4. 点击查看详细日志

### 方法 2: 查看 SonarCloud 结果

1. 访问 [SonarCloud 项目页面](https://sonarcloud.io/project/overview?id=Sting6-6code_-Online-Learning-Platform-Cpp)
2. 查看最新的分析结果
3. 每次推送后应该会有新的分析记录

---

## 🎯 工作流执行流程

```
代码推送到 GitHub
    ↓
触发 GitHub Actions
    ↓
检出代码
    ↓
安装编译工具
    ↓
执行 SonarCloud 扫描
    ↓
上传分析结果到 SonarCloud
    ↓
在 PR 中显示质量报告 (如果是 PR)
```

---

## 🔧 高级配置 (可选)

### 1. 启用编译命令生成

如果你想要更精确的 C++ 分析，可以启用构建步骤：

在 `.github/workflows/sonarcloud.yml` 中取消注释以下部分：

```yaml
- name: Build project
  working-directory: ./Cpp_online_platform
  run: |
    cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .
    make
```

### 2. 添加代码覆盖率

如果你有测试覆盖率：

1. 生成覆盖率报告 (使用 gcov/lcov)
2. 在工作流中添加上传步骤
3. 在 `sonar-project.properties` 中配置：
   ```properties
   sonar.cfamily.coverage.reportPaths=coverage.xml
   ```

### 3. 自定义分支

如果你有其他分支需要扫描，修改 `sonarcloud.yml` 中的：

```yaml
on:
  push:
    branches:
      - main
      - master
      - develop
      - feature/* # 添加更多分支
```

### 4. 设置质量门禁

在 SonarCloud 中配置质量门禁，确保代码质量标准：

1. 访问 SonarCloud 项目
2. 进入 **Quality Gates**
3. 配置你的质量标准
4. 如果代码不符合标准，GitHub Actions 将失败

---

## 🐛 故障排除

### 问题 1: 工作流运行失败 - "SONAR_TOKEN not found"

**原因**: GitHub Secrets 中没有配置 SONAR_TOKEN

**解决**:

1. 按照"步骤 1"添加 SONAR_TOKEN 到 GitHub Secrets
2. 重新运行工作流

### 问题 2: SonarCloud 扫描失败 - "Project not found"

**原因**: SonarCloud 项目配置不正确

**解决**:

1. 确认 `sonar-project.properties` 中的项目信息正确
2. 确认 SonarCloud 上已创建该项目
3. 项目 Key: `Sting6-6code_-Online-Learning-Platform-Cpp`
4. 组织: `sting6-6code`

### 问题 3: 工作流没有自动触发

**原因**: 工作流文件位置不正确或触发条件不匹配

**解决**:

1. 确认文件路径: `.github/workflows/sonarcloud.yml`
2. 确认推送到了正确的分支 (main/master/develop)
3. 检查 Actions 是否在仓库设置中被启用

### 问题 4: "Resource not accessible by integration"

**原因**: 工作流权限不足

**解决**:
在仓库设置中启用 Actions 权限：

1. Settings → Actions → General
2. Workflow permissions
3. 选择 "Read and write permissions"

---

## 📊 查看分析结果

### GitHub 中查看

- **Pull Request**: SonarCloud 会自动在 PR 中添加评论，显示代码质量状态
- **Checks**: 在 PR 的 Checks 标签中查看详细状态

### SonarCloud 中查看

访问项目仪表板：

- **项目地址**: https://sonarcloud.io/project/overview?id=Sting6-6code_-Online-Learning-Platform-Cpp
- **组织项目列表**: https://sonarcloud.io/organizations/sting6-6code/projects

分析内容包括：

- 🐛 Bugs (错误)
- 🔒 Vulnerabilities (安全漏洞)
- 💡 Code Smells (代码异味)
- 📊 Coverage (覆盖率)
- 🔄 Duplications (重复代码)
- 📈 Metrics (代码度量)

---

## 🎯 最佳实践

1. **每次提交前本地测试**: 在推送前确保代码可以编译
2. **及时修复问题**: 关注 SonarCloud 报告的问题并及时修复
3. **使用 Pre-commit Hooks**: 在提交前运行基本检查
4. **设置质量目标**: 在 SonarCloud 中定义你的质量标准
5. **团队协作**: 邀请团队成员查看和讨论代码质量问题

---

## 📚 相关文档

- [GitHub Actions 官方文档](https://docs.github.com/en/actions)
- [SonarCloud GitHub Integration](https://docs.sonarcloud.io/advanced-setup/ci-based-analysis/github-integration/)
- [SonarCloud C++ 分析](https://docs.sonarcloud.io/advanced-setup/languages/c-c-objective-c/)

---

## 🔄 与手动扫描的区别

| 方面     | 手动扫描                 | 自动扫描 (GitHub Actions)    |
| -------- | ------------------------ | ---------------------------- |
| 触发方式 | 手动运行 `sonar-scanner` | 代码推送自动触发             |
| 运行环境 | 本地机器                 | GitHub 云端服务器            |
| 配置     | 本地 Token               | GitHub Secrets               |
| PR 集成  | 无                       | 自动在 PR 中显示质量报告     |
| 团队协作 | 需要每个人手动运行       | 所有人推送代码都自动分析     |
| 持续集成 | 需手动维护               | 自动化，零维护               |
| 质量门禁 | 无强制                   | 可以阻止不符合标准的代码合并 |

---

## ✅ 完成检查清单

在完成设置后，请确认：

- [ ] `.github/workflows/sonarcloud.yml` 文件已创建
- [ ] `SONAR_TOKEN` 已添加到 GitHub Secrets
- [ ] `sonar-project.properties` 配置正确
- [ ] 工作流文件已推送到 GitHub
- [ ] GitHub Actions 标签中可以看到工作流
- [ ] 第一次扫描已成功运行
- [ ] SonarCloud 上可以看到分析结果
- [ ] PR 中可以看到 SonarCloud 的评论

---

🎉 **恭喜！你已经成功配置了自动 SonarCloud 扫描！**

现在每次你推送代码到 GitHub，SonarCloud 都会自动分析你的代码质量。
