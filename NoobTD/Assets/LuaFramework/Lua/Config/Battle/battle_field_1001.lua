return {
	--初始金币
	Coin 	= 650,
	--初始血量
	HP 		= 5,

	--路线
	Lines   = 
	{
		{
			Route = 
			{
				{12.94,4.67},{12.86,4.67},{12.63,4.68},{12.29,4.69},{11.84,4.71},{11.31,4.73},{10.74,4.75},{10.13,4.77},{9.51,4.78},{8.91,4.79},
				{8.35,4.79},{7.85,4.79},{7.43,4.77},{7.11,4.75},{6.83,4.72},{6.59,4.70},{6.36,4.67},{6.17,4.64},{5.99,4.60},{5.84,4.56},{5.70,4.50},
				{5.57,4.44},{5.46,4.36},{5.35,4.27},{5.25,4.16},{5.16,4.04},{5.08,3.89},{5.02,3.72},{4.98,3.53},{4.95,3.33},{4.94,3.11},{4.94,2.88},
				{4.94,2.65},{4.95,2.41},{4.95,2.18},{4.94,1.96},{4.93,1.75},{4.90,1.55},{4.85,1.37},{4.79,1.20},{4.73,1.03},{4.66,0.87},{4.59,0.72},
				{4.52,0.57},{4.44,0.42},{4.36,0.28},{4.28,0.14},{4.19,0.00},{4.11,-0.14},{4.03,-0.28},{3.94,-0.42},{3.87,-0.56},{3.79,-0.71},
				{3.73,-0.86},{3.66,-1.00},{3.59,-1.15},{3.52,-1.29},{3.45,-1.43},{3.36,-1.56},{3.27,-1.69},{3.17,-1.80},{3.05,-1.91},{2.92,-1.99},
				{2.76,-2.07},{2.59,-2.13},{2.40,-2.17},{2.19,-2.21},{1.97,-2.23},{1.74,-2.25},{1.50,-2.26},{1.26,-2.26},{1.02,-2.26},{0.79,-2.26},
				{0.56,-2.26},{0.35,-2.26},{0.15,-2.26},{-0.04,-2.27},{-0.23,-2.27},{-0.41,-2.28},{-0.58,-2.29},{-0.76,-2.29},{-0.92,-2.30},{-1.09,-2.29},
				{-1.26,-2.28},{-1.42,-2.27},{-1.58,-2.24},{-1.74,-2.20},{-1.90,-2.16},{-2.06,-2.09},{-2.21,-2.02},{-2.37,-1.92},{-2.52,-1.82},
				{-2.67,-1.70},{-2.82,-1.58},{-2.96,-1.45},{-3.11,-1.32},{-3.25,-1.19},{-3.40,-1.07},{-3.54,-0.94},{-3.69,-0.83},{-3.84,-0.72},
				{-3.99,-0.62},{-4.13,-0.52},{-4.28,-0.42},{-4.43,-0.32},{-4.58,-0.22},{-4.73,-0.12},{-4.88,-0.03},{-5.03,0.06},{-5.18,0.14},{-5.32,0.21},
				{-5.47,0.28},{-5.61,0.33},{-5.75,0.38},{-5.88,0.42},{-6.01,0.45},{-6.14,0.47},{-6.27,0.49},{-6.39,0.50},{-6.52,0.51},{-6.65,0.51},
				{-6.78,0.50},{-6.91,0.49},{-7.05,0.48},{-7.20,0.46},{-7.35,0.43},{-7.50,0.40},{-7.66,0.36},{-7.82,0.31},{-7.99,0.25},{-8.15,0.19},
				{-8.32,0.12},{-8.50,0.05},{-8.68,-0.02},{-8.86,-0.08},{-9.06,-0.14},{-9.26,-0.19},{-9.46,-0.23},{-9.68,-0.26},{-9.92,-0.28},
				{-10.19,-0.30},{-10.47,-0.31},{-10.76,-0.32},{-11.06,-0.32},{-11.36,-0.32},{-11.64,-0.32},{-11.91,-0.31},{-12.16,-0.31},{-12.38,-0.31},
				{-12.57,-0.30},{-12.72,-0.31}
			},
		},

		{
			Route = 
			{
				{12.89,-4.27},{12.84,-4.27},{12.69,-4.29},{12.45,-4.30},{12.15,-4.33},{11.79,-4.35},{11.39,-4.38},{10.97,-4.41},{10.53,-4.44},{10.10,-4.47},{9.68,-4.50},
				{9.29,-4.52},{8.95,-4.54},{8.66,-4.55},{8.40,-4.57},{8.15,-4.59},{7.91,-4.62},{7.68,-4.64},{7.46,-4.66},{7.25,-4.68},{7.05,-4.69},{6.85,-4.70},{6.66,-4.69},
				{6.47,-4.68},{6.28,-4.64},{6.10,-4.60},{5.92,-4.53},{5.74,-4.44},{5.57,-4.33},{5.41,-4.20},{5.25,-4.06},{5.10,-3.91},{4.95,-3.75},{4.81,-3.59},{4.67,-3.44},
				{4.53,-3.29},{4.40,-3.15},{4.27,-3.03},{4.14,-2.92},{4.02,-2.83},{3.91,-2.75},{3.82,-2.67},{3.73,-2.60},{3.64,-2.54},{3.56,-2.48},{3.48,-2.43},{3.39,-2.38},
				{3.29,-2.34},{3.19,-2.31},{3.07,-2.27},{2.94,-2.24},{2.79,-2.22},{2.62,-2.20},{2.43,-2.19},{2.23,-2.18},{2.01,-2.18},{1.79,-2.19},{1.56,-2.20},{1.32,-2.21},
				{1.09,-2.23},{0.86,-2.24},{0.63,-2.25},{0.42,-2.25},{0.21,-2.26},{0.02,-2.25},{-0.17,-2.25},{-0.34,-2.25},{-0.52,-2.25},{-0.69,-2.26},{-0.85,-2.26},
				{-1.01,-2.26},{-1.17,-2.25},{-1.33,-2.24},{-1.49,-2.22},{-1.64,-2.19},{-1.79,-2.15},{-1.95,-2.10},{-2.10,-2.04},{-2.25,-1.96},{-2.39,-1.86},{-2.54,-1.76},
				{-2.68,-1.64},{-2.82,-1.52},{-2.96,-1.40},{-3.09,-1.27},{-3.23,-1.15},{-3.37,-1.02},{-3.51,-0.90},{-3.65,-0.79},{-3.79,-0.68},{-3.94,-0.58},{-4.09,-0.48},
				{-4.24,-0.38},{-4.38,-0.28},{-4.53,-0.19},{-4.68,-0.09},{-4.83,0.00},{-4.98,0.09},{-5.13,0.17},{-5.28,0.25},{-5.42,0.31},{-5.57,0.37},{-5.71,0.42},
				{-5.85,0.46},{-5.98,0.50},{-6.12,0.52},{-6.25,0.54},{-6.37,0.56},{-6.50,0.56},{-6.63,0.57},{-6.76,0.56},{-6.90,0.55},{-7.03,0.54},{-7.18,0.52},{-7.32,0.50},
				{-7.47,0.47},{-7.63,0.43},{-7.78,0.38},{-7.93,0.31},{-8.09,0.24},{-8.25,0.17},{-8.41,0.09},{-8.57,0.02},{-8.75,-0.06},{-8.92,-0.12},{-9.11,-0.19},
				{-9.30,-0.24},{-9.50,-0.28},{-9.72,-0.31},{-9.96,-0.33},{-10.23,-0.34},{-10.51,-0.35},{-10.80,-0.35},{-11.09,-0.34},{-11.38,-0.33},{-11.66,-0.32},
				{-11.93,-0.31},{-12.17,-0.31},{-12.39,-0.30},{-12.57,-0.29},{-12.72,-0.29}
			}
		}
	},

	--防守位
	Defender    =
	{
		{2.03, -0.69},
		{-1.58, -0.73},
		{6.7, -3.28},
		{6.6, 3,36},
		{5.01, -1.86},
		{-6.75, -0.8},
		{-4.06, -2.25},
		{2.32, -3.47}
	},

	--怪物
	Waves	=
	{
		{
			wait    = 0,
			line	= {1},
			list    =
			{
				{time = 0.0, id = 910000}, {time = 1.0, id = 910000},{time = 2.0, id = 910000},{time = 3.0, id = 910000},
				{time = 5.0, id = 910000}, {time = 6.0, id = 910000},{time = 7.0, id = 910000},{time = 8.0, id = 910000},
			}
		},

		{
			wait    = 500,
			line	= {1, 2},
			list    =
			{
				{time = 0.0, id = 910000, line = 2}, {time = 1.0, id = 910000, line = 2},{time = 2.0, id = 910000, line = 2},{time = 3.0, id = 910000, line = 2},
				{time = 5.0, id = 910000}, {time = 6.0, id = 910000},{time = 7.0, id = 910000},{time = 8.0, id = 910000},
			}
		}
	}
}