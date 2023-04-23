return {
	[1001] = {
		Name = "解锁公司2",
		ID = 1001,
		condition = {
			{id =201, value =2},
		},
		effect = {
			{id =1005, value =Crypt.TE(1002)},
		},
	},
	[1002] = {
		Name = "解锁公司3",
		ID = 1002,
		condition = {
			{id =202, value =25},
		},
		effect = {
			{id =1005, value =Crypt.TE(1003)},
		},
	},
	[1003] = {
		Name = "解锁公司4",
		ID = 1003,
		condition = {
			{id =202, value =50},
		},
		effect = {
			{id =1005, value =Crypt.TE(1004)},
		},
	},
	[1004] = {
		Name = "解锁公司5",
		ID = 1004,
		condition = {
			{id =202, value =100},
		},
		effect = {
			{id =1005, value =Crypt.TE(1005)},
		},
	},
	[1010] = {
		Name = "解锁续作开发",
		ID = 1010,
		condition = {
			{id =205, value =1},
		},
		effect = Table.Empty,
	},
	[1200] = {
		Name = "解锁社区传单",
		ID = 1200,
		condition = Table.Empty,
		effect = {
			{id =1007, value =Crypt.TE(10000)},
		},
	},
	[1201] = {
		Name = "解锁86同村",
		ID = 1201,
		condition = {
			{id =105, value =2},
		},
		effect = {
			{id =1007, value =Crypt.TE(11000)},
		},
	},
	[1202] = {
		Name = "解锁前程堪忧",
		ID = 1202,
		condition = {
			{id =105, value =4},
		},
		effect = {
			{id =1007, value =Crypt.TE(12000)},
		},
	},
	[1203] = {
		Name = "解锁失联招聘",
		ID = 1203,
		condition = {
			{id =105, value =6},
		},
		effect = {
			{id =1007, value =Crypt.TE(13000)},
		},
	},
}
