# MySQL Operations Lab

## 项目简介

本项目基于 Rocky Linux 9.8 和 MySQL 8.0，实践 Linux 环境下的数据库部署、日常管理、自动备份、数据恢复及故障排查。

使用 Bash 编写数据库备份脚本，结合 Cron 实现每日定时备份，并通过实验验证数据恢复和数据库权限控制。

## 技术环境

- 操作系统：Rocky Linux 9.8
- 数据库：MySQL 8.0.46
- 脚本语言：Bash
- 服务管理：systemd
- 定时任务：Cron
- 备份工具：mysqldump
- 版本管理：Git / GitHub

## 项目功能

- 安装、启动 MySQL，并配置开机自启
- 创建实验数据库和服务器信息表
- 使用 mysqldump 进行数据库逻辑备份
- 将 SQL 备份恢复至新数据库
- 模拟误删除记录并恢复数据
- 创建普通数据库用户并配置最小权限
- 查看 MySQL 错误日志和 systemd 服务日志
- 模拟 MySQL 服务停止并完成故障恢复
- 使用 Bash 和 Cron 实现每日自动备份
- 使用 umask 和 Linux 文件权限保护备份数据

## 项目结构

```text
mysql-ops-lab/
├── init.sql       # 数据库初始化脚本
├── backup.sh      # MySQL 备份脚本
├── .gitignore     # Git 忽略规则
└── README.md      # 项目说明
```

## 备份与恢复

### 手动备份

```bash
sudo mysqldump ops_lab > ops_lab.sql
```

### 恢复到新数据库

```bash
sudo mysql -e "CREATE DATABASE ops_lab_restore;"
sudo mysql ops_lab_restore < ops_lab.sql
```

### 验证恢复结果

```bash
sudo mysql -e "SELECT * FROM ops_lab_restore.servers;"
```

## 自动备份

执行 `backup.sh`，自动生成带时间戳的 SQL 备份文件。

脚本采用 `umask 077` 限制新建备份文件的访问权限。

本实验使用 root 的 Cron，每天凌晨 2 点执行：

```cron
0 2 * * * /bin/bash /home/huiyi/mysql-ops-lab/backup.sh >> /home/huiyi/mysql-backups/backup.log 2>&1
```

**注意：** 使用前需要根据实际环境调整脚本路径和备份目录，并确保 root 能够通过本机 MySQL 认证。备份文件和日志不提交到 GitHub。

## 故障排查实践

### 1. MySQL 服务停止

**现象：** MySQL 客户端返回 `ERROR 2002`，无法连接本地数据库。

**排查：**

```bash
systemctl status mysqld --no-pager
sudo journalctl -u mysqld -n 15 --no-pager
```

**恢复：**

```bash
sudo systemctl start mysqld
```

恢复后重新连接数据库，验证服务和数据正常。

### 2. MySQL 权限限制

为 `ops_user` 授予 `ops_lab` 数据库的 SELECT、INSERT、UPDATE、DELETE 权限。

验证该用户能够查询授权数据，但无法查询未授权数据库，也无法执行 DROP TABLE。

### 3. 备份文件权限问题

检查发现备份文件原本具有 `644` 权限，其他用户可能读取备份。

通过调整备份目录及文件权限，并在脚本中设置 `umask 077`，限制非授权用户访问。

## 项目总结

通过本项目，实践了 MySQL 数据库的部署、逻辑备份、数据恢复、用户权限管理和服务故障排查。

初步掌握了 Linux 数据库运维流程，以及通过 Bash、Cron 和日志开展基础自动化运维的方法。
