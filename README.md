# surge-rules

个人 Surge 规则集与模块仓库。仓库结构参考
[Loyalsoldier/surge-rules](https://github.com/Loyalsoldier/surge-rules)：

- `main` 分支保存规则源、模块和生成脚本。
- GitHub Actions 每天生成 Surge 可直接引用的文件。
- `release` 分支只保存生成结果。

## 添加规则

编辑 `source/` 下对应文件：

```text
# 精确匹配
example.com

# 匹配域名及其所有子域名
.example.org
```

三个分类分别为：

- `direct.txt`：直连
- `proxy.txt`：代理
- `reject.txt`：拒绝

提交到 `main` 后，Actions 会生成两套文件：

- `release/<name>.txt`：`DOMAIN-SET`
- `release/ruleset/<name>.txt`：`RULE-SET`

## Surge 引用示例

仓库转为公开后，可使用以下地址：

```ini
[Rule]
RULE-SET,https://raw.githubusercontent.com/TylerJackk/surge-rules/release/ruleset/reject.txt,REJECT
RULE-SET,https://raw.githubusercontent.com/TylerJackk/surge-rules/release/ruleset/direct.txt,DIRECT
RULE-SET,https://raw.githubusercontent.com/TylerJackk/surge-rules/release/ruleset/proxy.txt,PROXY
FINAL,PROXY
```

也可以使用 jsDelivr：

```text
https://cdn.jsdelivr.net/gh/TylerJackk/surge-rules@release/ruleset/proxy.txt
```

## 本地生成

```bash
./scripts/build.sh
```

生成结果位于 `publish/`，该目录不会提交到 `main`。

## 模块

把 `.sgmodule` 文件放入 `modules/`。构建时它们会原样复制到
`release/modules/`。

## 安全说明

不要把代理密码、UUID、私钥、订阅 Token 或真实节点写入本仓库。节点订阅应由带鉴权的独立 HTTPS 服务提供。
