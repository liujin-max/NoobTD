return {
	[1001] = {
		Name = "新游戏",
		ID = 1001,
		ForceShow = 1,
		Condition = Table.Empty,
		Effect = {
			{id =9000, value =Crypt.TE(1)},
		},
	},
	[1002] = {
		Name = "新主机",
		ID = 1002,
		ForceShow = 1,
		Condition = {
			{id =101, value =1},
		},
		Effect = {
			{id =9001, value =Crypt.TE(1)},
		},
	},
	[1003] = {
		Name = "开发续作",
		ID = 1003,
		Condition = {
			{id =109, value =1010},
		},
		Effect = {
			{id =9002, value =Crypt.TE(1)},
		},
	},
	[1099] = {
		Name = "承接外包",
		ID = 1099,
		ForceShow = 1,
		Condition = Table.Empty,
		Effect = {
			{id =9003, value =Crypt.TE(1)},
		},
	},
	[1101] = {
		Name = "信息",
		ID = 1101,
		ForceShow = 1,
		Condition = Table.Empty,
		Effect = {
			{id =9100, value =Crypt.TE(1)},
		},
	},
	[1102] = {
		Name = "招聘",
		ID = 1102,
		Condition = {
			{id =105, value =2},
		},
		Effect = {
			{id =9101, value =Crypt.TE(1)},
		},
	},
	[1201] = {
		Name = "宣传",
		ID = 1201,
		ForceShow = 1,
		Condition = {
			{id =103, value =1},
		},
		Effect = {
			{id =9200, value =Crypt.TE(1)},
		},
	},
	[1202] = {
		Name = "银行",
		ID = 1202,
		Condition = {
			{id =105, value =2},
		},
		Effect = {
			{id =9201, value =Crypt.TE(1)},
		},
	},
	[1298] = {
		Name = "外出打工",
		ID = 1298,
		Condition = Table.Empty,
		Effect = {
			{id =9202, value =Crypt.TE(1)},
		},
	},
	[1299] = {
		Name = "搬迁",
		ID = 1299,
		Condition = {
			{id =106, value =1},
		},
		Effect = {
			{id =1004, value =Crypt.TE(1)},
		},
	},
	[1301] = {
		Name = "开发历史",
		ID = 1301,
		Condition = {
			{id =201, value =1},
		},
		Effect = {
			{id =9302, value =Crypt.TE(1)},
		},
	},
	[1302] = {
		Name = "排行",
		ID = 1302,
		Condition = {
			{id =201, value =3},
		},
		Effect = {
			{id =9300, value =Crypt.TE(1)},
		},
	},
	[1303] = {
		Name = "游戏系列",
		ID = 1303,
		Condition = {
			{id =205, value =1},
		},
		Effect = {
			{id =9301, value =Crypt.TE(1)},
		},
	},
	[1304] = {
		Name = "发行商信息",
		ID = 1304,
		Condition = Table.Empty,
		Effect = {
			{id =9303, value =Crypt.TE(1)},
		},
	},
	[1401] = {
		Name = "重新开始",
		ID = 1401,
		Condition = Table.Empty,
		Effect = {
			{id =9401, value =Crypt.TE(1)},
		},
	},
	[1499] = {
		Name = "退出游戏",
		ID = 1499,
		Condition = Table.Empty,
		Effect = {
			{id =9499, value =Crypt.TE(1)},
		},
	},
}
