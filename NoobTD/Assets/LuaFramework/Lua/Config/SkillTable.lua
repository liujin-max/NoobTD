return {
	[1000001] = {
		Name = "平射",
		ID = 1000001,
		DisplayName = "pingshe",
		CD = 1500,
		AtkInc = 100,
		HitEffects = Table.Empty,
		Condition = Table.Empty,
		Range = 200,
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
		Range = 250,
	},
}
