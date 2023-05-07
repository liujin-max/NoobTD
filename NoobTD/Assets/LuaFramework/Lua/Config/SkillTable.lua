return {
	[1000001] = {
		Name = "平射",
		ID = 1000001,
		DisplayName = "pingshe",
		CD = 1200,
		AtkInc = 100,
		HitEffects = Table.Empty,
		Condition = Table.Empty,
		Range = 250,
	},
	[1001001] = {
		Name = "高级平射",
		ID = 1001001,
		DisplayName = "gaojipingshe",
		CD = 1000,
		AtkInc = 100,
		HitEffects = Table.Empty,
		Condition = Table.Empty,
		Range = 275,
	},
	[1002001] = {
		Name = "多重射击",
		ID = 1002001,
		DisplayName = "duochongsheji",
		CD = 1000,
		AtkInc = 100,
		HitEffects = Table.Empty,
		Condition = Table.Empty,
		Range = 300,
	},
	[1010001] = {
		Name = "狙击",
		ID = 1010001,
		DisplayName = "juji",
		CD = 1800,
		AtkInc = 100,
		HitEffects = Table.Empty,
		Condition = Table.Empty,
		Range = 450,
	},
	[2000001] = {
		Name = "寒冰弹",
		ID = 2000001,
		DisplayName = "hanbingdan",
		CD = 2000,
		AtkInc = 80,
		HitEffects = {
			{id =1000, value =Crypt.TE(1000)},
		},
		Condition = Table.Empty,
		Range = 300,
	},
}
