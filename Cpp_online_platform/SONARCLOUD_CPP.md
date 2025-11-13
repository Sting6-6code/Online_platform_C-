# C++ 项目 SonarCloud 配置指南

## 📋 概述

本文档说明如何为 C++ 在线学习平台项目配置 SonarCloud 代码质量分析。

---

## 🚀 快速开始

### 步骤 1: 安装 sonar-scanner

**macOS (使用 Homebrew):**

```bash
brew install sonar-scanner
```

**验证安装:**

```bash
sonar-scanner --version
```

应该看到类似输出：

```
INFO: Scanner configuration file: /usr/local/Cellar/sonar-scanner/...
INFO: SonarScanner 4.8.0.2856
```

---

### 步骤 2: 在 SonarCloud 创建 C++ 项目

1. 访问 https://sonarcloud.io
2. 登录您的账号 (GitHub: sting6-6code)
3. 点击 "+" → "Analyze new project"
4. 选择 "Manually"
5. 输入项目信息：
   - **Project key**: `Sting6-6code_-Online-Learning-Platform-Cpp`
   - **Display name**: `Online Learning Platform - C++`
6. 选择 "C++" 作为主要语言
7. 生成新的 Token：My Account → Security → Generate Tokens

---

### 步骤 3: 运行分析

**使用脚本（推荐）:**

```bash
cd /Users/wangsiting/github_Siting/-Online-Learning-Platform/Cpp_online_platform
chmod +x run-sonar-cpp.sh
./run-sonar-cpp.sh
```

**手动运行:**

```bash
sonar-scanner \
  -Dsonar.token="YOUR_TOKEN" \
  -Dsonar.organization="sting6-6code" \
  -Dsonar.projectKey="Sting6-6code_-Online-Learning-Platform-Cpp" \
  -Dsonar.projectName="Online Learning Platform - C++" \
  -Dsonar.host.url="https://sonarcloud.io"
```

---

## 📁 项目结构

```
Cpp_online_platform/
├── sonar-project.properties   # SonarCloud 配置文件
├── run-sonar-cpp.sh           # 分析脚本
├── *.cpp, *.h                 # C++ 源代码
├── test_*.cpp                 # 测试文件
└── model                      # 编译产物
```

---

## ⚙️ 配置说明

### sonar-project.properties

```properties
sonar.projectKey=Sting6-6code_-Online-Learning-Platform-Cpp
sonar.organization=sting6-6code

# 源代码目录
sonar.sources=.

# 包含的文件
sonar.inclusions=**/*.cpp,**/*.h

# 排除的文件
sonar.exclusions=**/test_*.cpp,**/model_Main.cpp,model,test_*

# 测试文件
sonar.test.inclusions=**/test_*.cpp
```

### 分析的文件

**包含:**

- 所有 `.cpp` 和 `.h` 文件（除了排除项）

**排除:**

- `test_*.cpp` - 测试文件
- `model_Main.cpp` - 主程序入口
- `model` 和 `test_*` - 编译产物

**分析的源文件（约 30+ 个）:**

- User.cpp/.h
- Student.cpp/.h
- Instructor.cpp/.h
- Administrator.cpp/.h
- Course.cpp/.h
- Enrollment.cpp/.h
- Lesson.cpp/.h
- VideoContent.cpp/.h
- CourseCategory.cpp/.h
- Assignment.cpp/.h
- Submission.cpp/.h
- Grade.cpp/.h
- Payment.cpp/.h
- Subscription.cpp/.h
- Refund.cpp/.h
- Utils.cpp/.h

---

## 🔍 高级配置（可选）

### 1. 生成编译数据库（推荐）

为了获得更准确的分析，可以生成 `compile_commands.json`:

```bash
# 使用 CMake 生成
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .

# 更新 sonar-project.properties
# sonar.cfamily.compile-commands=compile_commands.json
```

### 2. 添加代码覆盖率

如果有测试覆盖率报告（如 gcov/lcov）:

```properties
sonar.cfamily.coverage.reportPaths=coverage.xml
```

---

## 📊 查看分析结果

分析完成后访问：

**项目仪表板:**
https://sonarcloud.io/project/overview?id=Sting6-6code_-Online-Learning-Platform-Cpp

**组织项目列表:**
https://sonarcloud.io/organizations/sting6-6code/projects

### 报告内容

1. **代码质量评级** (A-E)

   - Reliability (可靠性)
   - Security (安全性)
   - Maintainability (可维护性)

2. **问题统计**

   - Bugs
   - Vulnerabilities
   - Code Smells
   - Security Hotspots

3. **代码度量**

   - 代码行数
   - 代码重复度
   - 技术债务

4. **C++ 特定检查**
   - 内存泄漏风险
   - 空指针解引用
   - 资源管理问题
   - 未初始化变量

---

## 🐛 故障排除

### 问题 1: sonar-scanner 命令未找到

**解决:**

```bash
brew install sonar-scanner
```

### 问题 2: Token 权限不足

**解决:**
确保使用的是有效的 Token，并且有分析权限。

### 问题 3: 分析时间过长

**解决:**
C++ 分析通常需要 1-3 分钟，这是正常的。

### 问题 4: 文件未被分析

**解决:**
检查 `sonar.inclusions` 和 `sonar.exclusions` 配置是否正确。

---

## 🎯 最佳实践

1. **定期运行分析**

   - 每次重要代码更改后运行
   - 可以集成到 CI/CD 流程

2. **修复高优先级问题**

   - 优先修复 Bugs 和 Vulnerabilities
   - 逐步改善 Code Smells

3. **设置质量门禁**

   - 在 SonarCloud 中配置质量标准
   - 确保新代码符合标准

4. **团队协作**
   - 邀请团队成员查看报告
   - 共同讨论和修复问题

---

## 📚 参考资料

- [SonarCloud C++ 文档](https://docs.sonarcloud.io/advanced-setup/languages/c-c-objective-c/)
- [sonar-scanner CLI 文档](https://docs.sonarcloud.io/advanced-setup/ci-based-analysis/sonarscanner-cli/)
- [C++ 代码质量最佳实践](https://docs.sonarcloud.io/improving/rules/)

---

## 🔄 与 Java 项目的区别

| 方面       | Java 项目       | C++ 项目                   |
| ---------- | --------------- | -------------------------- |
| 分析工具   | Maven 插件      | sonar-scanner CLI          |
| 配置文件   | pom.xml         | sonar-project.properties   |
| 代码覆盖率 | JaCoCo          | gcov/lcov                  |
| 编译信息   | 自动获取        | 需要 compile_commands.json |
| 运行命令   | mvn sonar:sonar | sonar-scanner              |

---

祝您使用愉快！🎉
