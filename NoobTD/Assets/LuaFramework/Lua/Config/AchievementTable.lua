return {
	[100] = {
		Name = "心思缜密",
		ID = 100,
		TriggerType = 1,
		IsEgg = 1,
		Description = "制作出的游戏没有漏洞!",
		condition = {
			{id =200, value =0},
		},
		Reward = {
			{id =1008, value =Crypt.TE(5)},
		},
	},
	[101] = {
		Name = "糟糕透顶",
		ID = 101,
		TriggerType = 6,
		IsEgg = 1,
		Description = "游戏的四项评分均为1分",
		condition = {
			{id =108, value =1},
		},
		Reward = {
			{id =1009, value =Crypt.TE(50000)},
		},
	},
	[102] = {
		Name = "十全十美",
		ID = 102,
		TriggerType = 6,
		IsEgg = 1,
		Description = "游戏的四项评分均为满分",
		condition = {
			{id =108, value =10},
		},
		Reward = Table.Empty,
	},
	[200] = {
		Name = "游戏",
		ID = 200,
		TriggerType = 2,
		Description = "制作出首款游戏",
		condition = {
			{id =201, value =1},
		},
		Reward = Table.Empty,
	},
	[201] = {
		Name = "游戏",
		ID = 201,
		TriggerType = 2,
		Description = "制作出10款游戏",
		condition = {
			{id =201, value =10},
		},
		Reward = Table.Empty,
	},
	[202] = {
		Name = "游戏",
		ID = 202,
		TriggerType = 2,
		Description = "制作出25款游戏",
		condition = {
			{id =201, value =25},
		},
		Reward = Table.Empty,
	},
	[203] = {
		Name = "游戏",
		ID = 203,
		TriggerType = 2,
		Description = "制作出50款游戏",
		condition = {
			{id =201, value =50},
		},
		Reward = Table.Empty,
	},
	[204] = {
		Name = "游戏",
		ID = 204,
		TriggerType = 2,
		Description = "制作出100款游戏",
		condition = {
			{id =201, value =100},
		},
		Reward = Table.Empty,
	},
	[300] = {
		Name = "5W",
		ID = 300,
		TriggerType = 3,
		Description = "单款游戏售出5万套",
		condition = {
			{id =202, value =5},
		},
		Reward = Table.Empty,
	},
	[301] = {
		Name = "10W",
		ID = 301,
		TriggerType = 3,
		Description = "单款游戏售出10万套",
		condition = {
			{id =202, value =10},
		},
		Reward = Table.Empty,
	},
	[302] = {
		Name = "25W",
		ID = 302,
		TriggerType = 3,
		Description = "单款游戏售出25万套",
		condition = {
			{id =202, value =25},
		},
		Reward = Table.Empty,
	},
	[303] = {
		Name = "50W",
		ID = 303,
		TriggerType = 3,
		Description = "单款游戏售出50万套",
		condition = {
			{id =202, value =50},
		},
		Reward = Table.Empty,
	},
	[304] = {
		Name = "100W",
		ID = 304,
		TriggerType = 3,
		Description = "单款游戏售出100万套",
		condition = {
			{id =202, value =100},
		},
		Reward = Table.Empty,
	},
	[305] = {
		Name = "250W",
		ID = 305,
		TriggerType = 3,
		Description = "单款游戏售出250万套",
		condition = {
			{id =202, value =250},
		},
		Reward = Table.Empty,
	},
	[306] = {
		Name = "500W",
		ID = 306,
		TriggerType = 3,
		Description = "单款游戏售出500万套",
		condition = {
			{id =202, value =500},
		},
		Reward = Table.Empty,
	},
	[307] = {
		Name = "1000W",
		ID = 307,
		TriggerType = 3,
		Description = "单款游戏售出1000万套",
		condition = {
			{id =202, value =1000},
		},
		Reward = Table.Empty,
	},
	[308] = {
		Name = "5000W",
		ID = 308,
		TriggerType = 3,
		Description = "单款游戏售出5000万套",
		condition = {
			{id =202, value =5000},
		},
		Reward = Table.Empty,
	},
	[309] = {
		Name = "10000W",
		ID = 309,
		TriggerType = 3,
		Description = "单款游戏售出10000万套",
		condition = {
			{id =202, value =10000},
		},
		Reward = Table.Empty,
	},
	[400] = {
		Name = "粉丝",
		ID = 400,
		TriggerType = 4,
		Description = "粉丝人数达到1000人",
		condition = {
			{id =203, value =1000},
		},
		Reward = Table.Empty,
	},
	[401] = {
		Name = "粉丝",
		ID = 401,
		TriggerType = 4,
		Description = "粉丝人数达到1万人",
		condition = {
			{id =203, value =10000},
		},
		Reward = Table.Empty,
	},
	[402] = {
		Name = "粉丝",
		ID = 402,
		TriggerType = 4,
		Description = "粉丝人数达到5万人",
		condition = {
			{id =203, value =50000},
		},
		Reward = Table.Empty,
	},
	[403] = {
		Name = "粉丝",
		ID = 403,
		TriggerType = 4,
		Description = "粉丝人数达到10万人",
		condition = {
			{id =203, value =100000},
		},
		Reward = Table.Empty,
	},
	[404] = {
		Name = "粉丝",
		ID = 404,
		TriggerType = 4,
		Description = "粉丝人数达到25万人",
		condition = {
			{id =203, value =250000},
		},
		Reward = Table.Empty,
	},
	[405] = {
		Name = "粉丝",
		ID = 405,
		TriggerType = 4,
		Description = "粉丝人数达到50万人",
		condition = {
			{id =203, value =5000000},
		},
		Reward = Table.Empty,
	},
	[406] = {
		Name = "粉丝",
		ID = 406,
		TriggerType = 4,
		Description = "粉丝人数达到100万人",
		condition = {
			{id =203, value =1000000},
		},
		Reward = Table.Empty,
	},
	[407] = {
		Name = "粉丝",
		ID = 407,
		TriggerType = 4,
		Description = "粉丝人数达到500万人",
		condition = {
			{id =203, value =5000000},
		},
		Reward = Table.Empty,
	},
	[408] = {
		Name = "粉丝",
		ID = 408,
		TriggerType = 4,
		Description = "粉丝人数达到1000万人",
		condition = {
			{id =203, value =10000000},
		},
		Reward = Table.Empty,
	},
}
