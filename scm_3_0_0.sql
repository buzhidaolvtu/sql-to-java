create table `t_scm_buy_to_inventory_business_receipt` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `global_id` varchar(100) NOT NULL DEFAULT '' COMMENT '全库唯一性,和id作用等价,标识唯一记录，引用附件使用',

  `buy_plan_sn` varchar(100) not null DEFAULT '' COMMENT '采购计划编号',
  `buy_order_sn` varchar(100) not null DEFAULT '' COMMENT '采购订单编号,相同采购订单号不允许重复入库',
  `business_receipt_sn` varchar(100) not null DEFAULT '' COMMENT '业务单号',
  `business_receipt_source` varchar(100) not null DEFAULT '' COMMENT '业务来源',
  `business_receipt_desc`  varchar(100) not null DEFAULT '' COMMENT '业务描述',

  `enter_inventory_time` datetime NULL DEFAULT '0000-00-00 00:00:00' COMMENT '入库日期',
  `receive_person_name` varchar(20) NULL DEFAULT '' COMMENT '收货员',
  `inspection_person_name` varchar(20) NULL DEFAULT '' COMMENT '收货员',

  `repository_sn`  varchar(100) NOT NULL DEFAULT '' COMMENT '仓库编码',
  `repository_name` varchar(100) NOT NULL DEFAULT '' COMMENT '仓库名称',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY uk_business_receipt_sn(`business_receipt_sn`),
  UNIQUE KEY uk_buy_order_sn(`buy_order_sn`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购订单入库业务单据';

create table `t_scm_buy_to_inventory_business_receipt_bill` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `business_receipt_sn` varchar(100) not null DEFAULT '' COMMENT '业务单号',
  `business_receipt_source` varchar(100) not null DEFAULT '' COMMENT '业务来源',
  `business_receipt_desc`  varchar(100) not null DEFAULT '' COMMENT '业务描述',

  `goods_type` tinyint not null DEFAULT -1 COMMENT '1:配件、2:整车',
  `goods_type_sn` varchar(100) not null DEFAULT '' COMMENT '货物类型编码，配件的物料编码code,material_code或者是整车类型编码，表示车型',
  `sku_snapshot_global_id` varchar(100) NOT NULL DEFAULT '' COMMENT 't_scm_sku_snapshot的global_id',
  `goods_name` varchar(100) not null DEFAULT '' COMMENT '货物名称',
  `goods_quantity` bigint not null DEFAULT 0 COMMENT '货物数量',

  `function_fault_quantity` bigint not null DEFAULT 0 COMMENT '功能故障数量',
  `bad_material_quantity` bigint not null DEFAULT 0 COMMENT '材质不良数量',
  `person_damaged_quantity` bigint not null DEFAULT 0 COMMENT '人为损坏数量',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY uk_business_receipt_sn(`business_receipt_sn`),
  KEY idx_goods_type_sn(`goods_type_sn`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='采购入库业务清单';

create table `t_scm_inventory_io_receipt` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `io_receipt_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '仓库库存出入单编码',

  `account_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '进出的库存账户编码',
  `account_name` varchar(100) NOT NULL DEFAULT '' COMMENT '进出的库存账户名称',
  `io_direction` tinyint not null DEFAULT -1 COMMENT '库存出入方向：1：入，2：出',
  `io_direction_desc` varchar(20) not null DEFAULT '' COMMENT '库存出入方向描述：1：入，2：出',

  `business_receipt_sn` varchar(100) not null DEFAULT '' COMMENT '业务单号',
  `business_receipt_source` varchar(100) not null DEFAULT '' COMMENT '业务来源',
  `business_receipt_desc`  varchar(100) not null DEFAULT '' COMMENT '业务描述',

  `io_result` tinyint not null DEFAULT 0 COMMENT '出入库结果：0:执行中，1:成功，2:失败',
  `io_result_desc` varchar(100) DEFAULT '' COMMENT '出入库结果文字描述',

  `issue_io_receipt_person_user_name` varchar(100) NOT NULL DEFAULT '' COMMENT '出单人用户名，打印这张单据的人',
  `issue_io_receipt_person_real_name` varchar(100) NOT NULL DEFAULT '' COMMENT '出单人真实姓名',

  `execute_io_receipt_person_user_name` varchar(100) NOT NULL DEFAULT '' COMMENT '执行人用户名，真正执行出入库存的人',
  `execute_io_receipt_person_real_name` varchar(100) NOT NULL DEFAULT '' COMMENT '执行人真实姓名',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY uk_io_receipt_sn(`io_receipt_sn`),
  UNIQUE KEY uk_inventory_request_gid(`inventory_request_gid`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库库存总出入单';

create table `t_scm_inventory_io_receipt_bill` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `io_receipt_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '仓库库存出入单编码',

  `goods_type` tinyint not null DEFAULT -1 COMMENT '1:配件、2:整车',
  `goods_type_sn` varchar(100) not null DEFAULT '' COMMENT '货物类型编码，配件的物料编码code,material_code或者是整车类型编码，表示车型',
  `goods_name` varchar(100) not null DEFAULT '' COMMENT '货物名称',
  `goods_quantity` bigint not null DEFAULT 0 COMMENT '货物数量',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY idx_io_receipt_bill_sn(`io_receipt_bill_sn`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库库存出入数量清单';

create table `t_scm_inventory_io_receipt_detail_bill` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `io_receipt_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '仓库库存出入单编码',

  `goods_type` tinyint not null DEFAULT -1 COMMENT '1:配件、2:整车',
  `goods_type_sn` varchar(100) not null DEFAULT '' COMMENT '货物类型编码，配件的物料编码code,material_code或者是整车类型编码，表示车型',
  `goods_unique_sn` varchar(100) not null DEFAULT '' COMMENT '货物唯一码',
  `goods_name` varchar(100) not null DEFAULT '' COMMENT '货物名称',
  `goods_quantity` bigint not null DEFAULT 0 COMMENT '货物数量',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY idx_io_receipt_bill_sn(`io_receipt_bill_sn`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='仓库库存出入详细清单';

# 这个账户要在创建供应商的时候一起创建，因为整车厂供应商会作为仓库被使用。账本是对仓库出入的证明，是一种事实记录。
create table `t_scm_inventory_account` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '库存总账户编码，不许变更',
  `account_name` varchar(100) NOT NULL DEFAULT '' COMMENT '库存总账户名称',
  `account_kind` tinyint NOT NULL DEFAULT -1 COMMENT '1:工厂，2:三包，3:城市',
  `account_kind_desc` varchar(100) NOT NULL DEFAULT '' COMMENT '文字描述，1:工厂，2:三包，3:城市',
  `account_type` tinyint NOT NULL DEFAULT -1 COMMENT '1：配件库，2：整车库，3：不良品库，4：废件库，5：生产库，6：不可见库（在途库，占用库）',
  `account_type_desc` varchar(100) NOT NULL DEFAULT '' COMMENT '1：配件库，2：整车库，3：不良品库，4：废件库，5：生产库，6：不可见库（在途库，占用库）',

  `inventory_money_limit` DECIMAL(30,10)  NULL DEFAULT 0 COMMENT '库存配额,单价：分',

  `repository_sn`  varchar(100) NOT NULL DEFAULT '' COMMENT '仓库编码',
  `repository_name` varchar(100) NOT NULL DEFAULT '' COMMENT '仓库名称',
  `repository_type` tinyint NOT NULL DEFAULT 1 COMMENT '仓库类型说明，1：普通仓库，2：整车厂供应商作为仓库，这里是为了兼容2.0开发引入的整车厂商仓库',
  `supplier_code` varchar(50) NOT NULL DEFAULT '' COMMENT '当类型是2的时候，表示整车厂供应商的供应商编码',

  `repository_status` TINYINT NOT NULL DEFAULT 0 COMMENT '状态 0关闭 1开启',
  `repository_status_desc` varchar(20) NOT NULL DEFAULT '' COMMENT '状态 0关闭 1开启',

  `city_id` bigint NOT NULL DEFAULT -1 COMMENT '坐落城市ID，如果有的话，包括自定义城市',
  `city_name` varchar(100) NOT NULL DEFAULT '' COMMENT '坐落城市名称，如果有的话，包括自定义城市',
  `gps` varchar(100) NOT NULL DEFAULT '' COMMENT '仓库坐标',
  `address` varchar(100) NOT NULL DEFAULT '' COMMENT '仓库地址',

  `remark` varchar(100) NOT NULL DEFAULT '' COMMENT '备注',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  UNIQUE KEY uk_account_sn(`account_sn`),
  UNIQUE KEY uk_repository_sn(`repository_sn`),
  KEY idx_supplier_code(`supplier_code`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='库存总账本';

create table `t_scm_inventory_account_bill` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '库存总账户编码',

  `goods_type` tinyint not null DEFAULT -1 COMMENT '1:配件、2:整车',
  `goods_type_sn` varchar(100) not null DEFAULT '' COMMENT '货物类型编码，配件的物料编码code,material_code或者是整车类型编码，表示车型',
  `goods_name` varchar(100) not null DEFAULT '' COMMENT '货物名称',
  `goods_quantity` bigint not null DEFAULT 0 COMMENT '货物数量',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  unique key uk_account_and_type_sn(`account_sn`,`goods_type_sn`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='在库数量清单';

create table `t_scm_inventory_account_detail_bill` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '库存总账户编码',

  `goods_type` tinyint not null DEFAULT -1 COMMENT '1:配件、2:整车',
  `goods_type_sn` varchar(100) not null DEFAULT '' COMMENT '货物类型编码，配件的物料编码code,material_code或者是整车类型编码，表示车型',
  `goods_unique_sn` varchar(100) not null DEFAULT '' COMMENT '货物唯一码',
  `goods_name` varchar(100) not null DEFAULT '' COMMENT '货物名称',
  `goods_quantity` bigint not null DEFAULT 0 COMMENT '货物数量',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  key idx_account_bill_sn(`account_bill_sn`),
  key idx_account_sn(`account_sn`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='在库详细清单';

# 添加库存预警设置时，针对每一个物料的预警清单
create table `t_scm_inventory_account_bill_alarm_setting` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '库存总账户编码',

  `goods_type` tinyint not null DEFAULT -1 COMMENT '1:配件、2:整车',
  `goods_type_sn` varchar(100) not null DEFAULT '' COMMENT '货物类型编码，配件的物料编码code,material_code或者是整车类型编码，表示车型',
  `goods_name` varchar(100) not null DEFAULT '' COMMENT '货物名称',
  `goods_alarm_quantity` bigint not null DEFAULT -1 COMMENT '货物预警数量',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='在库数量清单预警设置';

# 添加库存预警设置时，关联的生产车型信息
create table `t_scm_inventory_account_alarm_mapping` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `account_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '库存总账户编码',

  `production_bike_model_id` bigint NOT NULL COMMENT '生产车型内部唯一ID',
  `production_bike_model` varchar(100) NOT NULL COMMENT '生产车型编码',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  KEY idx_account_sn(`account_sn`),
  KEY idx_repository_sn(`repository_sn`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='预警设置和车型的对应关系';

# 库存变动流水，记录的是增量变动信息
create table `t_scm_inventory_water` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `water_sn` varchar(100) not null DEFAULT '' COMMENT '流水编号',
  `account_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '库存总账户编码',

  `io_receipt_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '库存出入单编码,用来追溯引发这次流水的原因',

  `io_direction` tinyint not null DEFAULT -1 COMMENT '库存出入方向：1：入，2：出',
  `io_direction_desc` varchar(20) not null DEFAULT '' COMMENT '库存出入方向描述：1：入，2：出',

  `business_receipt_sn` varchar(100) not null DEFAULT '' COMMENT '业务单号',
  `business_receipt_source` varchar(100) not null DEFAULT '' COMMENT '业务来源',
  `business_receipt_desc`  varchar(100) not null DEFAULT '' COMMENT '业务描述',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  key idx_account_sn(`account_sn`),
  key idx_water_sn(`water_sn`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='出入流水数量清单';

create table `t_scm_inventory_water_bill` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `water_sn` varchar(100) not null DEFAULT '' COMMENT '流水编号',
  `account_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '库存总账户编码',

  `goods_type` tinyint not null DEFAULT -1 COMMENT '1:配件、2:整车',
  `goods_type_sn` varchar(100) not null DEFAULT '' COMMENT '货物类型编码，配件的物料编码code,material_code或者是整车类型编码，表示车型',
  `goods_name` varchar(100) not null DEFAULT '' COMMENT '货物名称',
  `goods_quantity` bigint not null DEFAULT 0 COMMENT '货物数量',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  key idx_water_bill_sn(`water_bill_sn`),
  key idx_account_sn(`account_sn`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='出入流水数量清单';

create table `t_scm_inventory_water_detail_bill` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `water_sn` varchar(100) not null DEFAULT '' COMMENT '流水编号',
  `account_sn` varchar(100) NOT NULL DEFAULT '' COMMENT '库存总账户编码',

  `goods_type` tinyint not null DEFAULT -1 COMMENT '1:配件、2:整车',
  `goods_type_sn` varchar(100) not null DEFAULT '' COMMENT '货物类型编码，配件的物料编码code,material_code或者是整车类型编码，表示车型',
  `goods_unique_sn` varchar(100) not null DEFAULT '' COMMENT '货物唯一码',
  `goods_name` varchar(100) not null DEFAULT '' COMMENT '货物名称',
  `goods_quantity` bigint not null DEFAULT 0 COMMENT '货物数量',

  `create_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '创建人ID',
  `create_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '创建人姓名',
  `update_user` bigint(20) NOT NULL DEFAULT '0' COMMENT '更新人ID',
  `update_user_name` varchar(50) NOT NULL DEFAULT '' COMMENT '更新人姓名',
  `create_time` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_time` datetime NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`),
  key idx_water_bill_sn(`water_bill_sn`),
  key idx_account_sn(`account_sn`)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='出入流水详细清单';