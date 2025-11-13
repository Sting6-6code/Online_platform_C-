# 🔧 在 SonarCloud 创建项目

## ❌ 问题

GitHub Actions 运行时报错：

```
ERROR Could not find a default branch for project with key
'Sting6-6code_-Online-Learning-Platform-Cpp'. Make sure project exists.
```

## ✅ 解决方案

需要先在 SonarCloud 上创建项目。

---

## 方法 1: 自动导入 GitHub 仓库（最简单）⭐

### 步骤 1: 访问 SonarCloud

1. 打开 https://sonarcloud.io
2. 使用 GitHub 账号登录

### 步骤 2: 导入 GitHub 仓库

1. 点击右上角 **"+"** → **"Analyze new project"**
2. 选择 **"GitHub"** 标签
3. 如果首次使用，需要授权 SonarCloud 访问 GitHub：
   - 点击 **"Install GitHub App"**
   - 选择你的 GitHub 账号/组织
   - 选择要分析的仓库（`Online_platform_C-` 或选择所有仓库）
   - 点击 **"Install"** 授权
4. 返回 SonarCloud，在仓库列表中找到 `Online_platform_C-`
5. 勾选该仓库
6. 点击 **"Set Up"**

### 步骤 3: 配置项目

SonarCloud 会自动：

- 生成项目 Key: `你的GitHub用户名_Online_platform_C-`
- 设置组织
- 创建项目

### 步骤 4: 选择分析方式

1. 选择 **"With GitHub Actions"**
2. SonarCloud 会显示配置说明
3. 你已经完成了配置，点击 **"Continue"**

### 步骤 5: 等待首次分析

1. 返回 GitHub 仓库
2. GitHub Actions 会自动触发（如果已推送工作流文件）
3. 或者手动触发：在 GitHub Actions 页面点击工作流 → **"Run workflow"**

---

## 方法 2: 手动创建项目

### 步骤 1: 创建项目

1. 访问 https://sonarcloud.io
2. 点击 **"+"** → **"Analyze new project"**
3. 选择 **"Manually"**

### 步骤 2: 填写项目信息

**重要**：必须使用与工作流中完全相同的信息！

- **Organization**: `sting6-6code`（你的组织名）
- **Project key**: `Sting6-6code_-Online-Learning-Platform-Cpp`
- **Display name**: `Online Learning Platform - C++`

### 步骤 3: 选择 "Previous version"

- 选择 **"Previous version"**（因为这是历史项目的继续）

### 步骤 4: 完成创建

点击 **"Create project"**

---

## 验证项目 Key 是否匹配

### 检查工作流中的配置

查看 `.github/workflows/sonarcloud.yml`:

```yaml
args: >
  -Dsonar.organization=sting6-6code
  -Dsonar.projectKey=Sting6-6code_-Online-Learning-Platform-Cpp
```

### 检查 sonar-project.properties

查看 `Cpp_online_platform/sonar-project.properties`:

```properties
sonar.projectKey=Sting6-6code_-Online-Learning-Platform-Cpp
sonar.organization=sting6-6code
```

**确保三个地方的 `projectKey` 和 `organization` 完全一致！**

---

## 🔍 常见问题

### Q1: 找不到我的组织？

**解决**:

1. 访问 https://sonarcloud.io/account/organizations
2. 查看你的组织列表
3. 如果没有组织，需要先创建一个
4. 记下组织的 Key（通常是小写字母）

### Q2: GitHub 导入时看不到我的仓库？

**解决**:

1. 确认已授权 SonarCloud 访问该仓库
2. 访问 GitHub Settings → Applications → SonarCloud
3. 如果是 Organization 仓库，需要 Organization 管理员授权
4. 重新授权或调整权限

### Q3: 项目 Key 可以包含中文或特殊字符吗？

**回答**: 不行。项目 Key 只能包含：

- 字母 (a-z, A-Z)
- 数字 (0-9)
- 下划线 (\_)
- 连字符 (-)
- 点号 (.)
- 冒号 (:)

### Q4: 如何查看已存在的项目？

**方法**:

1. 访问 https://sonarcloud.io/projects
2. 或访问你的组织页面：https://sonarcloud.io/organizations/sting6-6code/projects
3. 查看所有已创建的项目

---

## 推荐做法：使用自动导入

**为什么推荐方法 1（自动导入）？**

✅ **优点**:

- 自动配置正确的项目 Key
- 自动关联 GitHub 仓库
- 可以在 Pull Request 中看到代码质量报告
- 自动同步权限和设置

❌ **手动创建的缺点**:

- 需要手动确保 Key 匹配
- 可能缺少 GitHub 集成功能
- 配置更复杂

---

## 🚀 完成后

项目创建后：

1. **重新运行 GitHub Actions**:

   - 访问 GitHub → Actions
   - 点击失败的工作流
   - 点击 **"Re-run all jobs"**

2. **查看分析结果**:

   - 访问 https://sonarcloud.io/project/overview?id=Sting6-6code_-Online-Learning-Platform-Cpp
   - 查看代码质量报告

3. **配置质量门禁**（可选）:
   - 在 SonarCloud 项目中设置质量标准
   - 不符合标准的代码将无法通过 CI

---

## 📝 记住

- **项目 Key 在三个地方必须一致**：

  1. SonarCloud 项目设置
  2. `.github/workflows/sonarcloud.yml`
  3. `Cpp_online_platform/sonar-project.properties`

- **Organization 也必须一致**

- **首次分析需要时间**，通常 2-5 分钟

---

## ✅ 检查清单

完成以下步骤后，GitHub Actions 应该可以成功运行：

- [ ] 在 SonarCloud 上创建了项目
- [ ] 项目 Key 为：`Sting6-6code_-Online-Learning-Platform-Cpp`
- [ ] Organization 为：`sting6-6code`
- [ ] GitHub Secret `SONAR_TOKEN` 已添加
- [ ] 重新运行 GitHub Actions
- [ ] 工作流运行成功
- [ ] 可以在 SonarCloud 查看分析结果

---

🎉 **完成这些步骤后，自动扫描就可以正常工作了！**
