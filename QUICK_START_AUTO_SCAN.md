# 🚀 快速开始：自动 SonarCloud 扫描

## 仅需 4 步！

### 第 1 步: 在 SonarCloud 创建项目

1. 访问 https://sonarcloud.io 并登录
2. 点击 **"+"** → **"Analyze new project"**
3. 选择 **"GitHub"** → 授权并选择 `Online_platform_C-` 仓库
4. 点击 **"Set Up"** → 选择 **"With GitHub Actions"**

> 💡 如需详细步骤，查看 `CREATE_SONARCLOUD_PROJECT.md`

### 第 2 步: 添加 GitHub Secret

1. 打开 GitHub 仓库
2. **Settings** → **Secrets and variables** → **Actions**
3. 点击 **New repository secret**
4. 添加：
   - Name: `SONAR_TOKEN`
   - Value: `你的 SonarCloud Token`

> 💡 **获取 Token**: 在 [SonarCloud](https://sonarcloud.io) → My Account → Security → Generate Tokens

### 第 3 步: 推送工作流文件

```bash
# 进入项目目录
cd /path/to/your/project

# 添加文件并推送
git add .github/workflows/sonarcloud.yml
git add GITHUB_ACTIONS_SETUP.md QUICK_START_AUTO_SCAN.md
git commit -m "Add GitHub Actions for automatic SonarCloud scanning"
git push origin main
```

### 第 4 步: 验证

1. 访问 GitHub 仓库的 **Actions** 标签
2. 查看 "SonarCloud Analysis" 运行状态
3. 访问 [SonarCloud](https://sonarcloud.io/project/overview?id=Sting6-6code_-Online-Learning-Platform-Cpp) 查看结果

---

## ✅ 完成！

现在每次推送代码到 `main`/`master`/`develop` 分支，或创建 Pull Request 时，都会自动运行 SonarCloud 扫描！

---

## 📖 详细文档

查看 `GITHUB_ACTIONS_SETUP.md` 了解更多配置选项和故障排除。
