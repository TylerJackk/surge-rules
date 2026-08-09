# 手动规则

- `<Name>.txt`：插入对应生成规则集的顶部，优先保留。
- `<Name>.exclude.txt`：从上游下载结果中过滤包含这些文本的行。
- 所有规则都不包含最终策略，例如写 `DOMAIN-SUFFIX,example.com`，不要在末尾添加策略组。
