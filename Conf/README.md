# 配置说明

`Spec/Surge.conf` 是可从 URL 安装的完整配置。

安装前必须修改这一行：

```ini
🚀 我的节点 = select, policy-path=你的订阅地址, update-interval=86400
```

如果机场节点命名不包含“香港、美国、日本、台湾、新加坡”等关键词，请同步修改
对应地区策略组的 `policy-regex-filter`。
