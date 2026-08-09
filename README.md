# Surge 自用配置

参考 [Rabbit-Spec/Surge](https://github.com/Rabbit-Spec/Surge) 组织的个人 Surge
配置仓库，包含完整配置、自动同步规则、手动规则和模块。

## 目录

```text
Conf/Spec/Surge.conf              原有自用配置
Conf/Spec/Surge-CM-Online-Full.conf CM_Online_Full 完整版
Conf/Spec/Surge-lhie1-Full.conf   lhie1/dler 完整版
Rules/CM/*.list                   CM Full 每日镜像规则
Rules/lhie1/*.list                lhie1/dler 每日镜像规则
Rules/Manual/**                   手动追加或排除规则
Rules/Sources/*.sources           两套规则的上游来源映射
Rules/Upstream/*                  每日镜像的原始上游模板
Module/Spec/General.sgmodule      个人通用模块
scripts/update-rules.sh           上游规则同步脚本
.github/workflows/update-rules.yml 每日自动更新
```

## 使用配置

1. 将仓库设为公开，否则 Surge 无法匿名下载 GitHub Raw 文件。
2. 选择下面一个配置，打开文件并把 `你的订阅地址` 替换为机场提供的
   Surge 4/5 原生订阅地址。
3. 将修改后的配置作为自己的私有配置使用。不要把含 Token 的订阅地址提交到
   公开仓库。

### CM_Online_Full 完整版

策略结构和规则顺序按 `cmliu/ACL4SSR_Online_Full.ini` 适配为 Surge 原生格式：

```text
https://raw.githubusercontent.com/TylerJackk/surge-rules/main/Conf/Spec/Surge-CM-Online-Full.conf
```

### lhie1/dler 完整版

策略结构和规则顺序按 `tindy2013/lhie1_dler.ini` 适配，规则来自
`dler-io/Rules`：

```text
https://raw.githubusercontent.com/TylerJackk/surge-rules/main/Conf/Spec/Surge-lhie1-Full.conf
```

### 原有自用版

```text
https://raw.githubusercontent.com/TylerJackk/surge-rules/refs/heads/main/Conf/Spec/Surge.conf
```

节点订阅必须返回 Surge 原生策略行，例如：

```ini
香港 01 = trojan, example.com, 443, password=REDACTED, sni=example.com
```

不要把订阅地址、密码、UUID、私钥或 Token 提交到本仓库。

## 手动规则

原有自用版在 `Rules/Manual/<规则名>.txt` 中追加规则。两套完整版分别使用：

```text
Rules/Manual/CM/<规则名>.txt
Rules/Manual/lhie1/<规则名>.txt
```

例如：

```text
DOMAIN-SUFFIX,example.com
DOMAIN,api.example.net
IP-CIDR,192.0.2.0/24,no-resolve
```

如果要从上游规则删除内容，在对应的
同目录的 `<规则名>.exclude.txt` 中写入需要排除的完整文本或关键字。

本地更新：

```bash
./scripts/update-rules.sh
```

GitHub Actions 会在北京时间每天 04:00 自动同步一次，也支持手动运行。同步时会：

1. 从来源映射下载 CM Full 和 lhie1/dler 的最新规则；
2. 合并对应的手工追加规则并应用排除项；
3. 去重后更新 `Rules/CM/` 与 `Rules/lhie1/`；
4. 保存上游模板快照，方便发现其策略结构变化。

规则内容会自动跟随上游更新；若上游新增、删除或改名一个策略分类，需要同步调整
`Rules/Sources/*.sources` 和对应 Surge 配置中的策略组。

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
