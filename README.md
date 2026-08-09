# Surge 自用配置

参考 [Rabbit-Spec/Surge](https://github.com/Rabbit-Spec/Surge) 组织的个人 Surge
配置仓库，包含完整配置、自动同步规则、手动规则和模块。

## 目录

```text
Conf/Spec/Surge.conf              完整配置
Rules/*.list                      Surge 规则集
Rules/Manual/*.txt                手动追加或排除规则
Module/Spec/General.sgmodule      个人通用模块
scripts/update-rules.sh           上游规则同步脚本
.github/workflows/update-rules.yml 每日自动更新
```

## 使用配置

1. 将仓库设为公开，否则 Surge 无法匿名下载 GitHub Raw 文件。
2. 打开 `Conf/Spec/Surge.conf`，把 `你的订阅地址` 替换为机场提供的 Surge
   订阅地址。
3. 在 Surge 中选择“从 URL 下载配置”，使用：

```text
https://raw.githubusercontent.com/TylerJackk/surge-rules/refs/heads/main/Conf/Spec/Surge.conf
```

节点订阅必须返回 Surge 原生策略行，例如：

```ini
香港 01 = trojan, example.com, 443, password=REDACTED, sni=example.com
```

不要把订阅地址、密码、UUID、私钥或 Token 提交到本仓库。

## 手动规则

在 `Rules/Manual/<规则名>.txt` 中追加 Surge 规则，例如：

```text
DOMAIN-SUFFIX,example.com
DOMAIN,api.example.net
IP-CIDR,192.0.2.0/24,no-resolve
```

如果要从上游规则删除内容，在对应的
`Rules/Manual/<规则名>.exclude.txt` 中写入需要排除的完整文本或关键字。

本地更新：

```bash
./scripts/update-rules.sh
```

GitHub Actions 会在北京时间每天 04:00 自动同步一次，也支持手动运行。

## 模块

通用模块地址：

```text
https://raw.githubusercontent.com/TylerJackk/surge-rules/refs/heads/main/Module/Spec/General.sgmodule
```

在 Surge 的模块页面选择“从 URL 安装”并粘贴该地址。

## 安全边界

- `Conf/`、`Rules/`、`Module/` 可以公开。
- 节点订阅应放在有 Token 鉴权的独立 HTTPS 服务中。
- 不建议将第三方解锁、签到或去广告脚本直接复制进仓库；应逐个审查后再安装。
