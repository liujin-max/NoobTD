////////////////////////////////////////////////////////////////////////
//                                                                  ////
//      从对应的元表结构，生成CardTable和HeroLevel这两张表          ////
//      中间涉及到读取Excel，导入结构，导出结构，输出Excel          ////
//                                                                  ////
////////////////////////////////////////////////////////////////////////

using System.Collections;
using System.Collections.Generic;
#if UNITY_EDITOR
using System.Data;
#endif
using Excel;
using System.IO;
using UnityEngine;
using System.Text;
using System.Linq;

public class ExcelGenerator
{
#if UNITY_EDITOR
    private class Tuple<T1>
	{
		public T1 value;
		public string name;
		public string label;
		public string type;
	}

    private class HeroMaxLevel
    {
        public Tuple<int> ID = new Tuple<int>();
        public Tuple<string> Name = new Tuple<string>();
        public Tuple<int> T0_Max = new Tuple<int>();
        public Tuple<int> T1_Max = new Tuple<int>();
        public Tuple<int> T2_Max = new Tuple<int>();

        public static int Columns = 5;
    }

	private class Effect
	{
		public string Key;
		public int Value;

		public Effect (string key, int value)
		{
			this.Key = key;
			this.Value = value;
		}

		public override string ToString ()
		{
			return this.Value != 0 ? this.Key + ":" + this.Value : this.Key;
		}
	}

	private class DevelopEffect : Effect
	{
		public DevelopEffect (string key, int value) : base (key, value)
		{
            
		}
	}

	//元表数据结构
	private class HeroMetaTable
	{
		public Tuple<int> ID = new Tuple<int> ();
		public Tuple<string> Name = new Tuple<string> ();
		public Tuple<List<Effect>> T0 = new Tuple<List<Effect>> ();
		public Tuple<List<Effect>> T0_PowerUp = new Tuple<List<Effect>> ();
		public Tuple<List<Effect>> T1 = new Tuple<List<Effect>> ();
		public Tuple<List<Effect>> T1_PowerUp = new Tuple<List<Effect>> ();
		public Tuple<List<Effect>> T2 = new Tuple<List<Effect>> ();
		public Tuple<List<Effect>> T2_PowerUp = new Tuple<List<Effect>> ();
		public Tuple<List<Effect>> T3 = new Tuple<List<Effect>> ();
		public Tuple<List<Effect>> T3_PowerUp = new Tuple<List<Effect>> ();
		public Tuple<int> UpgradeTimes = new Tuple<int> ();
		public Tuple<int> SP = new Tuple<int> ();
		public Tuple<int> Order = new Tuple<int> ();
		public Tuple<int> Turn = new Tuple<int> ();
		public Tuple<string> UnlockTime = new Tuple<string> ();
		public List<Tuple<List<Effect>>> TN = new List<Tuple<List<Effect>>> ();
		public List<Tuple<List<Effect>>> TN_PowerUp = new List<Tuple<List<Effect>>> ();
		public CardTable ExtraInfo = new CardTable ();
	}

	//英雄升级对应结构
	private class HeroLevelTable
	{
		public Tuple<int> ID;
        public Tuple<int> Hero;
        public Tuple<string> Name;
		public Tuple<int> NeedSP;
		public Tuple<List<DevelopEffect>> LevelUpEffect;
		public Tuple<int> Step = new Tuple<int> ();
		public Tuple<int> HeroT = new Tuple<int> ();

		public static int Columns = 7;
	}

    private class HeroBreakTable
    {
        public Tuple<int> ID;
        public Tuple<int> Hero;
        public Tuple<string> Name;
        public Tuple<List<DevelopEffect>> LevelUpEffect;
        public Tuple<int> UnlockLevel = new Tuple<int>();
        public Tuple<int> Step = new Tuple<int>();
        public Tuple<int> HeroT = new Tuple<int>();

        public static int Columns = 7;
    }

	//卡牌对应结构体
	private class CardTable
	{
		public Tuple<string> belong = new Tuple<string> ();
		//角色名称
		public Tuple<string> type = new Tuple<string> ();
		//类型
		public Tuple<int> level = new Tuple<int> ();
		//星级
		public Tuple<int> step = new Tuple<int> ();
		//升阶次数
		public Tuple<string> quality = new Tuple<string> ();
		//品质类型
		public Tuple<string> label = new Tuple<string> ();
		//标签
		public Tuple<string> target = new Tuple<string> ();
		//目标选择
		public Tuple<string> img = new Tuple<string> ();
		//图像
		public Tuple<string> description = new Tuple<string> ();
		//描述
		public Tuple<int> drawweight = new Tuple<int> ();
		//抽取权重
		public Tuple<int> invisible = new Tuple<int> ();
		//无法看见
		public Tuple<int> block_target_description = new Tuple<int> ();
		//屏蔽目标描述
        
	}

	private class CardExport
	{
		public CardTable ExtraInfo;
		public Tuple<int> ID;
		public Tuple<string> Name;

        
		public List<Tuple<List<Effect>>> Effects = new List<Tuple<List<Effect>>> ();
		public List<Tuple<List<Effect>>> UpgradeEffects = new List<Tuple<List<Effect>>> ();

		public static int Columns = 14 + (5 + 5) * 4;
	}

	private class HeroInput
	{
		public int ID;
		public string Name;

		public DataTable template = null;
		public DataTable upgrade = null;

		public Dictionary<int, HeroMetaTable> meta = new Dictionary<int, HeroMetaTable> ();
	}

	private class HeroOutput
	{
		//List里: 如果有5个参数，那么按序号就代表T0,T1,T2
		//假设是3挡，那么最终生成T0 ~ T2三张表
		//假设只有1档的牌，那么最终这个字段只生成在T0中
		public Dictionary<int, List<CardExport>> cards = new Dictionary<int, List<CardExport>> ();
		public Dictionary<int, List<HeroLevelTable>> levels = new Dictionary<int, List<HeroLevelTable>> ();
        public Dictionary<int, List<HeroBreakTable>> breaks = new Dictionary<int, List<HeroBreakTable>>();
    }

	public class TableLike
	{
		public string[,] Cells;

		public TableLike (int rows, int columns)
		{
			Cells = new string[rows, columns];
		}

		public void AddValue (int r, int c, string value)
		{
			Cells [r, c] = value;
		}

		public string GetValue (int r, int c)
		{
			return Cells [r, c];
		}
	}

	private Dictionary<int, HeroInput> Inputs = new Dictionary<int, HeroInput> ();
	private HeroOutput Output = new HeroOutput ();

	public delegate void ExportLuaDelegate (ExcelGenerator.TableLike c, string tableName);
	public ExportLuaDelegate Callback = null;

	public ExcelGenerator(ExportLuaDelegate callback)
	{
		this.Callback = callback;
	}

	private DataTable Read (string filePath)
	{
		FileStream stream = File.Open (filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
		IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader (stream);
		DataSet result = excelReader.AsDataSet ();
		stream.Close ();
		return result.Tables [0];
	}

	//假设interpolate = 5,
	//那么返回 0, 1, 2, 3, 4
	//对应的就是 5, 5 + 1/5 * (10 - 5),  2/5 *(10 - 5), 3/5*(10 - 5), 4/5*(10 - 5)
	private List<List<Effect>> InterpolateEffects (List<Effect> from, List<Effect> to, int interpolate)
	{
		List<List<Effect>> ret = new List<List<Effect>> ();

		for (int i = 0; i < interpolate; i++) {
			List<Effect> sec = new List<Effect> ();
			for (int k = 0; k < from.Count; k++) {
				var diff = to [k].Value - from [k].Value;
				float percent = (float)i / interpolate;
				var value = Mathf.RoundToInt (from [k].Value + percent * diff);
				var key = from [k].Key;

				Effect eff = new Effect (key, value);
				sec.Add (eff);
			}
			ret.Add (sec);
		}

		return ret;
	}

	private List<Effect> ParseEffects (string effect_string)
	{
		List<Effect> ret = new List<Effect> ();
		string[] parts = effect_string.Split (',');
		foreach (string p in parts) {
			string[] pair = p.Split (':');
			string key_name = pair [0];
			int value = 0;
			if (pair.Length > 1) {
				value = int.Parse (pair [1]);
			}

			Effect eff = new Effect (key_name, value);
			ret.Add (eff);
		}
		return ret;
	}

	private void ImportUpgrade (HeroInput input)
	{
		var c = input.upgrade;
		int columns = c.Columns.Count;          //获取列数
		int rows = c.Rows.Count;                //获取行数

		for (int i = 3; i < rows; i++) {
			HeroMetaTable meta = new HeroMetaTable ();
			int index = 0;

			if (string.IsNullOrEmpty (c.Rows [i] [index].ToString ())) {
				continue;
			}

			meta.Name.value = c.Rows [i] [index].ToString ();
			meta.Name.label = c.Rows [2] [index].ToString ();
			meta.Name.type = c.Rows [1] [index].ToString ();
			meta.Name.name = c.Rows [0] [index].ToString ();
			index++;

			meta.ID.value = int.Parse (c.Rows [i] [index].ToString ());
			meta.ID.label = c.Rows [2] [index].ToString ();
			meta.ID.type = c.Rows [1] [index].ToString ();
			meta.ID.name = c.Rows [0] [index].ToString ();
			index++;

			meta.T0.value = ParseEffects (c.Rows [i] [index].ToString ());
			meta.T0.label = c.Rows [2] [index].ToString ();
			meta.T0.type = c.Rows [1] [index].ToString ();
			meta.T0.name = c.Rows [0] [index].ToString ();
			index++;

			meta.T0_PowerUp.value = ParseEffects (c.Rows [i] [index].ToString ());
			meta.T0_PowerUp.label = c.Rows [2] [index].ToString ();
			meta.T0_PowerUp.type = c.Rows [1] [index].ToString ();
			meta.T0_PowerUp.name = c.Rows [0] [index].ToString ();
			index++;

			meta.T1.value = ParseEffects (c.Rows [i] [index].ToString ());
			meta.T1.label = c.Rows [2] [index].ToString ();
			meta.T1.type = c.Rows [1] [index].ToString ();
			meta.T1.name = c.Rows [0] [index].ToString ();
			index++;

			meta.T1_PowerUp.value = ParseEffects (c.Rows [i] [index].ToString ());
			meta.T1_PowerUp.label = c.Rows [2] [index].ToString ();
			meta.T1_PowerUp.type = c.Rows [1] [index].ToString ();
			meta.T1_PowerUp.name = c.Rows [0] [index].ToString ();
			index++;

			meta.T2.value = ParseEffects (c.Rows [i] [index].ToString ());
			meta.T2.label = c.Rows [2] [index].ToString ();
			meta.T2.type = c.Rows [1] [index].ToString ();
			meta.T2.name = c.Rows [0] [index].ToString ();
			index++;

			meta.T2_PowerUp.value = ParseEffects (c.Rows [i] [index].ToString ());
			meta.T2_PowerUp.label = c.Rows [2] [index].ToString ();
			meta.T2_PowerUp.type = c.Rows [1] [index].ToString ();
			meta.T2_PowerUp.name = c.Rows [0] [index].ToString ();
			index++;

			meta.T3.value = ParseEffects (c.Rows [i] [index].ToString ());
			meta.T3.label = c.Rows [2] [index].ToString ();
			meta.T3.type = c.Rows [1] [index].ToString ();
			meta.T3.name = c.Rows [0] [index].ToString ();
			index++;

			meta.T3_PowerUp.value = ParseEffects (c.Rows [i] [index].ToString ());
			meta.T3_PowerUp.label = c.Rows [2] [index].ToString ();
			meta.T3_PowerUp.type = c.Rows [1] [index].ToString ();
			meta.T3_PowerUp.name = c.Rows [0] [index].ToString ();
			index++;

			meta.TN.Add (meta.T0);
			meta.TN.Add (meta.T1);
			meta.TN.Add (meta.T2);
			meta.TN.Add (meta.T3);

			meta.TN_PowerUp.Add (meta.T0_PowerUp);
			meta.TN_PowerUp.Add (meta.T1_PowerUp);
			meta.TN_PowerUp.Add (meta.T2_PowerUp);
			meta.TN_PowerUp.Add (meta.T3_PowerUp);

			meta.UpgradeTimes.value = int.Parse (c.Rows [i] [index].ToString ());
			meta.UpgradeTimes.label = c.Rows [2] [index].ToString ();
			meta.UpgradeTimes.type = c.Rows [1] [index].ToString ();
			meta.UpgradeTimes.name = c.Rows [0] [index].ToString ();
			index++;

			meta.SP.value = int.Parse (c.Rows [i] [index].ToString ());
			meta.SP.label = c.Rows [2] [index].ToString ();
			meta.SP.type = c.Rows [1] [index].ToString ();
			meta.SP.name = c.Rows [0] [index].ToString ();
			index++;

			meta.Order.value = int.Parse (c.Rows [i] [index].ToString ());
			meta.Order.label = c.Rows [2] [index].ToString ();
			meta.Order.type = c.Rows [1] [index].ToString ();
			meta.Order.name = c.Rows [0] [index].ToString ();
			index++;

			meta.Turn.value = int.Parse (c.Rows [i] [index].ToString ());
			meta.Turn.label = c.Rows [2] [index].ToString ();
			meta.Turn.type = c.Rows [1] [index].ToString ();
			meta.Turn.name = c.Rows [0] [index].ToString ();
			index++;

			meta.UnlockTime.value = c.Rows [i] [index].ToString ();
			meta.UnlockTime.label = c.Rows [2] [index].ToString ();
			meta.UnlockTime.type = c.Rows [1] [index].ToString ();
			meta.UnlockTime.name = c.Rows [0] [index].ToString ();
			index++;

			input.meta.Add (meta.ID.value, meta);
		}
	}
	//角色名称	类型	星级	品质类型	标签	目标选择	图像	描述	    抽取权重	无法看见	屏蔽目标描述
	//belong	type	level	quality	    label	target	    img	    description	drawweight	invisible	block_target_description
	//string	string	int	    string	    string	target_list	string	string	    int	        int	        int

	private void ImportTemplate (HeroInput input)
	{
		var c = input.template;
		int columns = c.Columns.Count;          //获取列数
		int rows = c.Rows.Count;                //获取行数

		for (int i = 3; i < rows; i++) {
			int index = 0;
			string t = c.Rows [i] [index].ToString ();
			if (string.IsNullOrEmpty (t)) {
				continue;
			}

			int ID = int.Parse (c.Rows [i] [1].ToString ());
			var meta = input.meta [ID];

			index = 2;
			meta.ExtraInfo.belong.value = c.Rows [i] [index].ToString ();
			meta.ExtraInfo.belong.label = c.Rows [2] [index].ToString ();
			meta.ExtraInfo.belong.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.belong.name = c.Rows [0] [index].ToString ();
			index++;

			meta.ExtraInfo.type.value = c.Rows [i] [index].ToString ();
			meta.ExtraInfo.type.label = c.Rows [2] [index].ToString ();
			meta.ExtraInfo.type.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.type.name = c.Rows [0] [index].ToString ();
			index++;

			meta.ExtraInfo.level.value = int.Parse (c.Rows [i] [index].ToString ());
			meta.ExtraInfo.level.label = c.Rows [2] [index].ToString ();
			meta.ExtraInfo.level.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.level.name = c.Rows [0] [index].ToString ();
			index++;

			meta.ExtraInfo.quality.value = c.Rows [i] [index].ToString ();
			meta.ExtraInfo.quality.label = c.Rows [2] [index].ToString ();
			meta.ExtraInfo.quality.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.quality.name = c.Rows [0] [index].ToString ();
			index++;

			meta.ExtraInfo.label.value = c.Rows [i] [index].ToString ();
			meta.ExtraInfo.label.label = c.Rows [2] [index].ToString ();
			meta.ExtraInfo.label.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.label.name = c.Rows [0] [index].ToString ();
			index++;

			meta.ExtraInfo.target.value = c.Rows [i] [index].ToString ();
			meta.ExtraInfo.target.label = c.Rows [2] [index].ToString ();
			meta.ExtraInfo.target.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.target.name = c.Rows [0] [index].ToString ();
			index++;

			meta.ExtraInfo.img.value = c.Rows [i] [index].ToString ();
			meta.ExtraInfo.img.label = c.Rows [2] [index].ToString ();
			meta.ExtraInfo.img.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.img.name = c.Rows [0] [index].ToString ();
			index++;

			meta.ExtraInfo.description.value = c.Rows [i] [index].ToString ();
			meta.ExtraInfo.description.label = c.Rows [2] [index].ToString ();
			meta.ExtraInfo.description.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.description.name = c.Rows [0] [index].ToString ();
			index++;

			if (string.IsNullOrEmpty (c.Rows [i] [index].ToString ()) == false) {
				meta.ExtraInfo.drawweight.value = int.Parse (c.Rows [i] [index].ToString ());
			} else {
				meta.ExtraInfo.drawweight.value = 0;
			}

			meta.ExtraInfo.drawweight.name = c.Rows [0] [index].ToString ();
			meta.ExtraInfo.drawweight.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.drawweight.label = c.Rows [2] [index].ToString ();
			index++;

			if (string.IsNullOrEmpty (c.Rows [i] [index].ToString ()) == false) {
				meta.ExtraInfo.invisible.value = int.Parse (c.Rows [i] [index].ToString ());
			} else {
				meta.ExtraInfo.invisible.value = 0;
			}
			meta.ExtraInfo.invisible.name = c.Rows [0] [index].ToString ();
			meta.ExtraInfo.invisible.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.invisible.label = c.Rows [2] [index].ToString ();
			index++;

			if (string.IsNullOrEmpty (c.Rows [i] [index].ToString ()) == false) {
				meta.ExtraInfo.block_target_description.value = int.Parse (c.Rows [i] [index].ToString ());
			} else {
				meta.ExtraInfo.block_target_description.value = 0;
			}
			meta.ExtraInfo.block_target_description.name = c.Rows [0] [index].ToString ();
			meta.ExtraInfo.block_target_description.type = c.Rows [1] [index].ToString ();
			meta.ExtraInfo.block_target_description.label = c.Rows [2] [index].ToString ();
			index++;
		}
	}

	//将input的信息导入到 Dictionary<int, HeroMetaTable> 之中
	private void GenerateMeta (HeroInput input)
	{
		ImportUpgrade (input);
		ImportTemplate (input);
	}

	private CardExport GenerateCard (List<List<Effect>> sections, List<List<Effect>> sections_upgrade, CardTable table, Tuple<int> ID, Tuple<string> name)
	{
		CardExport export = new CardExport ();
		export.ExtraInfo = table;
		export.ID = ID;
		export.Name = name;

		List<Tuple<List<Effect>>> eff_sections = new List<Tuple<List<Effect>>> ();
		int index = 1;
		foreach (List<Effect> sec in sections) {
			Tuple<List<Effect>> sec_pair = new Tuple<List<Effect>> ();
			sec_pair.value = sec;
			sec_pair.type = "list";
			sec_pair.name = "effect" + index;
			index++;
			eff_sections.Add (sec_pair);
		}

		export.Effects = eff_sections;

		List<Tuple<List<Effect>>> eff_upgrade_sections = new List<Tuple<List<Effect>>> ();
		index = 1;
		foreach (List<Effect> sec in sections_upgrade) {
			Tuple<List<Effect>> sec_pair = new Tuple<List<Effect>> ();
			sec_pair.value = sec;
			sec_pair.type = "list";
			sec_pair.name = "powerup" + index;
			index++;
			eff_upgrade_sections.Add (sec_pair);
		}
		export.UpgradeEffects = eff_upgrade_sections;

		return export;
	}

    private TableLike Save(string luaPath, string tablePath, int heroID, List<HeroBreakTable> levelTable)
    {
        TableLike TL = new TableLike(levelTable.Count + 3, HeroBreakTable.Columns);
        for (int i = 0; i < 1; i++)
        {
            int j = 0;
            HeroBreakTable lv = levelTable[0];
            TL.AddValue(i, j++, lv.Name.name.ToString());
            TL.AddValue(i, j++, lv.ID.name.ToString());
            TL.AddValue(i, j++, lv.Hero.name.ToString());
            TL.AddValue(i, j++, lv.Step.name.ToString());
            TL.AddValue(i, j++, lv.HeroT.name.ToString());
            TL.AddValue(i, j++, lv.LevelUpEffect.name.ToString());
            TL.AddValue(i, j++, lv.UnlockLevel.name.ToString());
        }

        for (int i = 1; i < 2; i++)
        {
            int j = 0;
            HeroBreakTable lv = levelTable[0];
            TL.AddValue(i, j++, lv.Name.label.ToString());
            TL.AddValue(i, j++, lv.ID.label.ToString());
            TL.AddValue(i, j++, lv.Hero.label.ToString());
            TL.AddValue(i, j++, lv.Step.label.ToString());
            TL.AddValue(i, j++, lv.HeroT.label.ToString());
            TL.AddValue(i, j++, lv.LevelUpEffect.label.ToString());
            TL.AddValue(i, j++, lv.UnlockLevel.label.ToString());
        }

        for (int i = 2; i < 3; i++)
        {
            int j = 0;
            HeroBreakTable lv = levelTable[0];
            TL.AddValue(i, j++, lv.Name.type.ToString());
            TL.AddValue(i, j++, lv.ID.type.ToString());
            TL.AddValue(i, j++, lv.Hero.type.ToString());
            TL.AddValue(i, j++, lv.Step.type.ToString());
            TL.AddValue(i, j++, lv.HeroT.type.ToString());
            TL.AddValue(i, j++, lv.LevelUpEffect.type.ToString());
            TL.AddValue(i, j++, lv.UnlockLevel.type.ToString());
        }

        for (int i = 3; i < levelTable.Count + 3; i++)
        {
            int j = 0;
            HeroBreakTable lv = levelTable[i - 3];
            TL.AddValue(i, j++, lv.Name.value.ToString());
            TL.AddValue(i, j++, lv.ID.value.ToString());
            TL.AddValue(i, j++, lv.Hero.value.ToString());
            TL.AddValue(i, j++, lv.Step.value.ToString());
            TL.AddValue(i, j++, lv.HeroT.value.ToString());

            var elist = lv.LevelUpEffect.value;
            string ret_str = "";
            for (int p = 0; p < lv.LevelUpEffect.value.Count; p++)
            {
                string eff_str = lv.LevelUpEffect.value[p].ToString();
                ret_str += eff_str;
                if (p != lv.LevelUpEffect.value.Count)
                {
                    ret_str += ";";
                }
            }
            TL.AddValue(i, j++, ret_str);
            TL.AddValue(i, j++, lv.UnlockLevel.value.ToString());
        }

        //遍历T0, 将其写成以逗号分隔的形式, 编辑成字符串导出
        StringBuilder strb = new StringBuilder();
        for (int i = 0; i < TL.Cells.GetLength(0); i++)
        {
            for (int j = 0; j < TL.Cells.GetLength(1); j++)
            {
                var value = TL.Cells[i, j];
                strb.Append(value + ",");
            }
            strb.Append("\r\n");
        }

        string file_path = tablePath + "//" + "Break_" + heroID + "_Table.csv";
        if (File.Exists(file_path))
        {
            FileStream fs = new FileStream(file_path, FileMode.Truncate, FileAccess.ReadWrite);
            fs.Close();
        }

        FileStream stream = File.Open(file_path, FileMode.Create);
        byte[] data = System.Text.Encoding.GetEncoding("GB2312").GetBytes(strb.ToString());
        stream.Write(data, 0, data.Length);
        stream.Flush();
        stream.Close();

        int columns = TL.Cells.GetLength(1);
        int rows = TL.Cells.GetLength(0);

        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < columns; j++)
            {
                string value = TL.Cells[i, j].ToString();
                TL.Cells[i, j] = value.Replace(';', ',');
            }
        }
        return TL;
    }

    private TableLike Save (string luaPath, string tablePath, int heroID, List<HeroLevelTable> levelTable)
	{
		TableLike TL = new TableLike (levelTable.Count + 3, HeroLevelTable.Columns);
		for (int i = 0; i < 1; i++) {
			int j = 0;
			HeroLevelTable lv = levelTable [0];
			TL.AddValue (i, j++, lv.Name.name.ToString ());
			TL.AddValue (i, j++, lv.ID.name.ToString ());
            TL.AddValue (i, j++, lv.Hero.name.ToString());
            TL.AddValue (i, j++, lv.NeedSP.name.ToString ());
			TL.AddValue (i, j++, lv.Step.name.ToString ());
			TL.AddValue (i, j++, lv.HeroT.name.ToString ());
			TL.AddValue (i, j++, lv.LevelUpEffect.name.ToString ());
		}

		for (int i = 1; i < 2; i++) {
			int j = 0;
			HeroLevelTable lv = levelTable [0];
			TL.AddValue (i, j++, lv.Name.label.ToString ());
			TL.AddValue (i, j++, lv.ID.label.ToString ());
            TL.AddValue (i, j++, lv.Hero.label.ToString());
            TL.AddValue (i, j++, lv.NeedSP.label.ToString());
            TL.AddValue (i, j++, lv.Step.label.ToString ());
			TL.AddValue (i, j++, lv.HeroT.label.ToString ());
			TL.AddValue (i, j++, lv.LevelUpEffect.label.ToString ());
		}

		for (int i = 2; i < 3; i++) {
			int j = 0;
			HeroLevelTable lv = levelTable [0];
			TL.AddValue (i, j++, lv.Name.type.ToString ());
			TL.AddValue (i, j++, lv.ID.type.ToString ());
            TL.AddValue (i, j++, lv.Hero.type.ToString());
            TL.AddValue (i, j++, lv.NeedSP.type.ToString ());
			TL.AddValue (i, j++, lv.Step.type.ToString ());
			TL.AddValue (i, j++, lv.HeroT.type.ToString ());
			TL.AddValue (i, j++, lv.LevelUpEffect.type.ToString ());
		}

		for (int i = 3; i < levelTable.Count + 3; i++) {
			int j = 0;
			HeroLevelTable lv = levelTable [i - 3];
			TL.AddValue (i, j++, lv.Name.value.ToString ());
			TL.AddValue (i, j++, lv.ID.value.ToString ());
            TL.AddValue (i, j++, lv.Hero.value.ToString());
            TL.AddValue (i, j++, lv.NeedSP.value.ToString ());
			TL.AddValue (i, j++, lv.Step.value.ToString ());
			TL.AddValue (i, j++, lv.HeroT.value.ToString ());

			var elist = lv.LevelUpEffect.value;
			string ret_str = "";
			for (int p = 0; p < lv.LevelUpEffect.value.Count; p++) {
				string eff_str = lv.LevelUpEffect.value [p].ToString ();
				ret_str += eff_str;
				if (p != lv.LevelUpEffect.value.Count) {
					ret_str += ";";
				}
			}
			TL.AddValue (i, j++, ret_str);
		}

		//遍历T0, 将其写成以逗号分隔的形式, 编辑成字符串导出
		StringBuilder strb = new StringBuilder ();
		for (int i = 0; i < TL.Cells.GetLength (0); i++) {
			for (int j = 0; j < TL.Cells.GetLength (1); j++) {
				var value = TL.Cells [i, j];
				strb.Append (value + ",");
			}
			strb.Append ("\r\n");
		}

		string file_path = tablePath + "//" + "Level_" + heroID + "_Table.csv";
		if (File.Exists (file_path)) {
			FileStream fs = new FileStream (file_path, FileMode.Truncate, FileAccess.ReadWrite);
			fs.Close ();
		}

		FileStream stream = File.Open (file_path, FileMode.Create);
		byte[] data = System.Text.Encoding.GetEncoding ("GB2312").GetBytes (strb.ToString ());
		stream.Write (data, 0, data.Length);
		stream.Flush ();
		stream.Close ();

        int columns = TL.Cells.GetLength(1);
        int rows    = TL.Cells.GetLength(0);

        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < columns; j++)
            {
                string value = TL.Cells[i, j].ToString();
                TL.Cells[i, j] = value.Replace(';', ',');
            }
        }
        return TL;
	}

	private TableLike Save (string luaPath, string tablePath, Dictionary<int, List<CardExport>> cards)
	{
        //将cards转化为4张表格形式的结构体
        int totalCount = 0;
        foreach(var pair in cards)
        {
            totalCount = pair.Value.Count;
        }

		TableLike T0 = new TableLike (totalCount + 3, CardExport.Columns);

        for (int i = 0; i < 1; i++)
        {
            int j = 0;
            CardExport c = cards[0][1];
            T0.AddValue(i, j++, c.Name.name.ToString());
            T0.AddValue(i, j++, c.ID.name.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.belong.name.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.type.name.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.level.name.ToString());
            T0.AddValue(i, j++, "阶次");
            T0.AddValue(i, j++, c.ExtraInfo.quality.name.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.label.name.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.target.name.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.img.name.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.description.name.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.drawweight.name.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.invisible.name.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.block_target_description.name.ToString());

            for (int T = 0; T <= 3; T++)
            {
                for (int k = 0; k < 5; k++)
                {
                    int t = k + 1 + T * 5;
                    T0.AddValue(i, j++, "效果" + t);
                }

                for (int k = 0; k < 5; k++)
                {
                    int t = k + 1 + T * 5;
                    T0.AddValue(i, j++, "强化效果" + t);
                }
            }
        }

        for (int i = 2; i < 3; i++)
        {
            int j = 0;
            CardExport c = cards[0][1];
            T0.AddValue(i, j++, c.Name.label.ToString());
            T0.AddValue(i, j++, c.ID.label.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.belong.label.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.type.label.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.level.label.ToString());
            T0.AddValue(i, j++, "int");//c.ExtraInfo.step.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.quality.label.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.label.label.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.target.label.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.img.label.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.description.label.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.drawweight.label.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.invisible.label.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.block_target_description.label.ToString());

            for (int T = 0; T <= 3; T++)
            {
                for (int k = 0; k < 5; k++)
                {
                    int t = k + 1 + T * 5;
                    T0.AddValue(i, j++, "list");
                }

                for (int k = 0; k < 5; k++)
                {
                    int t = k + 1 + T * 5;
                    T0.AddValue(i, j++, "list");
                }
            }
        }

        for (int i = 1; i < 2; i++)
        {
            int j = 0;
            CardExport c = cards[0][1];
            T0.AddValue(i, j++, c.Name.type.ToString());
            T0.AddValue(i, j++, c.ID.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.belong.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.type.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.level.type.ToString());
            T0.AddValue(i, j++, "int");//c.ExtraInfo.step.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.quality.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.label.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.target.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.img.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.description.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.drawweight.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.invisible.type.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.block_target_description.type.ToString());

            for (int T = 0; T <= 3; T++)
            {
                for (int k = 0; k < 5; k++)
                {
                    int t = k + 1 + T * 5;
                    T0.AddValue(i, j++, "effect" + t);
                }

                for (int k = 0; k < 5; k++)
                {
                    int t = k + 1 + T * 5;
                    T0.AddValue(i, j++, "powerup" + t);
                }
            }
        }


        for (int i = 3; i < cards[0].Count + 3; i++)
        {
            int j = 0;
            CardExport c = cards[0][i - 3];
            //卡牌名称
            T0.AddValue(i, j++, c.Name.value.ToString());
            T0.AddValue(i, j++, c.ID.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.belong.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.type.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.level.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.step.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.quality.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.label.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.target.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.img.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.description.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.drawweight.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.invisible.value.ToString());
            T0.AddValue(i, j++, c.ExtraInfo.block_target_description.value.ToString());

            for (int T = 0; T <= 3; T++)
            {
                c = cards[T][i - 3];
                for (int k = 0; k < c.Effects.Count; k++)
                {
                    var elist = c.Effects[k];
                    string ret_str = "";
                    for (int p = 0; p < elist.value.Count; p++)
                    {
                        string eff_str = elist.value[p].ToString();
                        ret_str += eff_str;
                        if (p != elist.value.Count)
                        {
                            ret_str += ";";
                        }
                    }
                    T0.AddValue(i, j++, ret_str);
                }

                int diffk = 5 - c.Effects.Count;
                for (int k = 0; k < diffk; k++)
                {
                    T0.AddValue(i, j++, "");
                }

                for (int k = 0; k < c.UpgradeEffects.Count; k++)
                {
                    var elist = c.UpgradeEffects[k];
                    string ret_str = "";
                    for (int p = 0; p < elist.value.Count; p++)
                    {
                        string eff_str = elist.value[p].ToString();
                        ret_str += eff_str;
                        if (p != elist.value.Count)
                        {
                            ret_str += ";";
                        }
                    }
                    T0.AddValue(i, j++, ret_str);
                }

                diffk = 5 - c.UpgradeEffects.Count;
                for (int k = 0; k < diffk; k++)
                {
                    T0.AddValue(i, j++, "");
                }
            }
        }
            

        //遍历T0, 将其写成以逗号分隔的形式, 编辑成字符串导出
        StringBuilder strb = new StringBuilder();
        for (int i = 0; i < T0.Cells.GetLength(0); i++)
        {
            for (int j = 0; j < T0.Cells.GetLength(1); j++)
            {
                var value = T0.Cells[i, j];
                strb.Append(value + ",");
            }
            strb.Append("\r\n");
        }

        string file_path = tablePath + "//" + "FighterCard" + "Table.csv";
        if (File.Exists(file_path))
        {
            FileStream fs = new FileStream(file_path, FileMode.Truncate, FileAccess.ReadWrite);
            fs.Close();
        }

        FileStream stream = File.Open(file_path, FileMode.Create);
        byte[] data = System.Text.Encoding.GetEncoding("GB2312").GetBytes(strb.ToString());
        stream.Write(data, 0, data.Length);
        stream.Flush();
        stream.Close();

        int columns = T0.Cells.GetLength(1);
        int rows = T0.Cells.GetLength(0);

        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < columns; j++)
            {
                //Debug.Log("I" + i + "J" + j + "  " + rows + " " + columns);
                string value = "";
                if(T0.Cells[i, j] != null)
                {
                    value = T0.Cells[i, j].ToString();
                }
                T0.Cells[i, j] = value.Replace(';', ',');
            }
        }
        return T0;
    }

    //载入
    public void Load (string directory, string luaPath)
	{
		Output.cards.Add (0, new List<CardExport> ());    //T0
		Output.cards.Add (1, new List<CardExport> ());    //T1
		Output.cards.Add (2, new List<CardExport> ());    //T2
		Output.cards.Add (3, new List<CardExport> ());    //T3

		string[] filePaths = Directory.GetFiles (directory);
		string tableRoot = Path.GetDirectoryName (directory);

		Dictionary<string, string> fighter_template = new Dictionary<string, string> ();
		Dictionary<string, string> fighter_upgrade = new Dictionary<string, string> ();
		Dictionary<string, string> id_name_match = new Dictionary<string, string> ();
        Dictionary<int, HeroMaxLevel> max_levels = new Dictionary<int, HeroMaxLevel>();

		for (int i = 0; i < filePaths.Length; i++) {
			string path = filePaths [i];                 //meta文件路径
			string fileName = Path.GetFileName (path);   //文件名
			if (fileName.Contains ("CardTemplate")) {       //说明是模板文件
				string[] tags = fileName.Split ('_');    //e.g. 圆盾骑士 11000 CardTemplate
				string id = tags [1];
				fighter_template.Add (id, path);
			} else if (fileName.Contains ("Upgrade")) {       //说明是升级文件
				string[] tags = fileName.Split ('_');    //e.g. 圆盾骑士 11000 Upgrade
				string name_label = tags [0];
				string id = tags [1];
				id_name_match.Add (id, name_label);
				fighter_upgrade.Add (id, path);
			}
		}

		foreach (var pair in fighter_template) {
			string ID = pair.Key;
			string template_path = pair.Value;
			string upgrade_path = fighter_upgrade [ID];

			//读取这两个文件模块, 放入HeroInput中
			HeroInput input = new HeroInput ();
			input.ID = int.Parse (ID);
			input.Name = id_name_match [ID];
			input.template = Read (template_path);
			input.upgrade = Read (upgrade_path);
			GenerateMeta (input);

			Inputs.Add (input.ID, input);
		}

		//从Input来输出Output
		//规则1:
		//对于同一张卡，根据其是否有T0，T1，T2， 导出的表格也是多张
		//Card_T0, Card_T1, Card_T2, Card_T3
		//每个Card表格里，除去一些卡牌的基础信息外, 还要加上在这段时间升级的每一个分割点, 数据用Round计算
		foreach (var pair in Inputs) {
			HeroInput hero_input = pair.Value;

			foreach (var meta in hero_input.meta) {
				int ID = meta.Key;
				HeroMetaTable meta_table = meta.Value;

				int ti = 0; //T0
				while (ti < meta_table.TN.Count) {
					if ((ti + 1) < meta_table.TN.Count) {
						var current_T = meta_table.TN [ti];
						var last_T = meta_table.TN [ti + 1];

						var current_TUP = meta_table.TN_PowerUp [ti];
						var last_TUP = meta_table.TN_PowerUp [ti + 1];
						//所有中继点，包括TN本身
						List<List<Effect>> intersections = InterpolateEffects (current_T.value, last_T.value, meta_table.UpgradeTimes.value);
						//强化后数据的插值
						List<List<Effect>> intersections_upgrade = InterpolateEffects (current_TUP.value, last_TUP.value, meta_table.UpgradeTimes.value);

						//将生成出来的插值，归并其他信息，写回到output里
						CardExport export = GenerateCard (intersections, intersections_upgrade, meta_table.ExtraInfo, meta_table.ID, meta_table.Name);    //这里生成的卡牌是TN ---> TN+1 这一段中的卡牌
						Output.cards [ti].Add (export);

						ti++;
					} else {//说明是T3
						var current_T = meta_table.TN [ti];
						var current_TUP = meta_table.TN_PowerUp [ti];
						List<List<Effect>> intersections = new List<List<Effect>> ();
						List<List<Effect>> intersections_upgrade = new List<List<Effect>> ();
						CardExport export = new CardExport ();
						export.Effects.Add (current_T);
						export.UpgradeEffects.Add (current_TUP);
						export.ID = meta_table.ID;
						export.Name = meta_table.Name;
						export.ExtraInfo = meta_table.ExtraInfo;

						Output.cards [ti].Add (export);
						ti++;
					}
				}
			}
		}

        //将Output中的数据导出为lua, FighterCard
        TableLike tl = Save(luaPath, tableRoot + "/Cards/", Output.cards);
        Callback(tl, "FighterCard");


        //规则2:
        //根据Order, 生成这个英雄的整一条升级路线; 所有英雄的升级路线综合成一张大表;
        //同时，需要修改下HeroInfo表，以及更新下进度保存逻辑

        foreach (var pair in Inputs) {
			HeroInput hero_input = pair.Value;
			int hero_id = pair.Key;
			string hero_name = pair.Value.Name;
			if (Output.levels.ContainsKey (hero_id) == false) {
				Output.levels.Add (hero_id, new List<HeroLevelTable> ());
                Output.breaks.Add(hero_id, new List<HeroBreakTable>());
            }
			HeroLevelTable lv = new HeroLevelTable ();

			List<HeroMetaTable> metalist = new List<HeroMetaTable> ();
			foreach (var p in hero_input.meta) {
				metalist.Add (p.Value);
			}

			//对metalist进行从小到大的排序
			metalist.Sort ((a, b) => {
				var o = a.Order.value - b.Order.value;
				return o;
			});



            //算法：
            //1. 按照顺序来轮;
            //2. 如果有Turn, 则叠加顺序
            //3. 如果有Unlock, 说明是解锁牌; 
            // -> 1. 他的强度即为解锁时的轮次, 如解锁时是T2, 那么就是T3;
            int order = 0;
            for (int T = 0; T <= 3; T++) {
				int MAX_TURN = 0;
				for (int i = 0; i < metalist.Count; i++) {
					var meta = metalist [i];
					int max = meta.Turn.value + meta.UpgradeTimes.value - 1;
					if (max > MAX_TURN) {
						MAX_TURN = max;
					}
				}

				for (int current_turn = 1; current_turn <= MAX_TURN; current_turn++) {
					for (int i = 0; i < metalist.Count; i++) {
                        order++;
                        var meta = metalist [i];
						string unlock = meta.UnlockTime.value;
						bool orderable = true;

						HeroLevelTable level_table = new HeroLevelTable ();

						if (string.IsNullOrEmpty (unlock) == false) {
							string[] unlock_pair = unlock.Split ('_');
							int heroT = int.Parse (unlock_pair [0]);
							int level = int.Parse (unlock_pair [1]);
							if (heroT >= T) {
								orderable = false;
							}

							if (heroT == T && level == 1) {
								orderable = true;
							}

                            if(heroT == T && current_turn == 1)
                            {
                                HeroBreakTable break_table = new HeroBreakTable();

                                break_table.UnlockLevel.value = level;
                                break_table.UnlockLevel.name = "解锁等级";
                                break_table.UnlockLevel.label = "UnlockLevel";
                                break_table.UnlockLevel.type = "int";

                                break_table.ID = new Tuple<int>();
                                break_table.ID.value = hero_id * 1000 + order;
                                break_table.ID.name = "编号";
                                break_table.ID.label = "ID";
                                break_table.ID.type = "int";

                                break_table.Hero = new Tuple<int>();
                                break_table.Hero.value = hero_id;
                                break_table.Hero.name = "英雄";
                                break_table.Hero.label = "HeroID";
                                break_table.Hero.type = "int";

                                //Name: 名字
                                break_table.Name = new Tuple<string>();
                                break_table.Name.value = meta.Name.value;
                                break_table.Name.name = "名称";
                                break_table.Name.label = "Name";
                                break_table.Name.type = "string";

                                break_table.HeroT = new Tuple<int>();
                                break_table.HeroT.value = T;
                                break_table.HeroT.name = "转生次数";
                                break_table.HeroT.label = "HeroT";
                                break_table.HeroT.type = "int";

                                break_table.Step.value = current_turn;
                                break_table.Step.name = "分阶";
                                break_table.Step.label = "Step";
                                break_table.Step.type = "int";

                                break_table.LevelUpEffect = new Tuple<List<DevelopEffect>>();
                                break_table.LevelUpEffect.value = new List<DevelopEffect>();
                                break_table.LevelUpEffect.name = "升级效果";
                                break_table.LevelUpEffect.label = "LevelUpEffect";
                                break_table.LevelUpEffect.type = "develop_list";

                                //DevelopEffect: 怎么从T2_1 => 变成效果器
                                //会变成两种 => 等级/解锁
                                DevelopEffect breakEffect = new DevelopEffect("解锁卡牌", meta.ID.value);
                                break_table.LevelUpEffect.value.Add(breakEffect);

                                Output.breaks[hero_id].Add(break_table);
                            }
                        }

						if (orderable == false)
							continue;

						if (meta.Turn.value == 0 || current_turn < meta.Turn.value) {
							continue;
						}
                        
						if (current_turn > meta.Turn.value + meta.UpgradeTimes.value - 1) {
							continue;
						}

						//ID: 编号
						level_table.ID = new Tuple<int> ();
						level_table.ID.value    = hero_id * 1000 + order;
						level_table.ID.name     = "编号";
						level_table.ID.label    = "ID";
						level_table.ID.type     = "int";

                        level_table.Hero = new Tuple<int>();
                        level_table.Hero.value = hero_id;
                        level_table.Hero.name   = "英雄";
                        level_table.Hero.label  = "HeroID";
                        level_table.Hero.type   = "int";

                        //Name: 名字
                        level_table.Name = new Tuple<string> ();
						level_table.Name.value  = meta.Name.value;
						level_table.Name.name   = "名称";
						level_table.Name.label  = "Name";
						level_table.Name.type   = "string";

						level_table.NeedSP = new Tuple<int> ();
						level_table.NeedSP.value    = meta.SP.value;
						level_table.NeedSP.name     = meta.SP.name;
						level_table.NeedSP.label    = "NeedSP";
						level_table.NeedSP.type     = "int";

						level_table.HeroT = new Tuple<int> ();
						level_table.HeroT.value     = T;
						level_table.HeroT.name      = "转生次数";
						level_table.HeroT.label     = "HeroT";
						level_table.HeroT.type      = "int";

						level_table.Step.value = current_turn;
						level_table.Step.name = "分阶";
						level_table.Step.label = "Step";
						level_table.Step.type = "int";

						level_table.LevelUpEffect = new Tuple<List<DevelopEffect>> ();
						level_table.LevelUpEffect.value = new List<DevelopEffect> ();
						level_table.LevelUpEffect.name = "升级效果";
						level_table.LevelUpEffect.label = "LevelUpEffect";
						level_table.LevelUpEffect.type = "develop_list";

                        //DevelopEffect: 怎么从T2_1 => 变成效果器
                        //会变成两种 => 等级/解锁
                        DevelopEffect upgradeEffect = new DevelopEffect("卡牌升级", meta.ID.value);
                        level_table.LevelUpEffect.value.Add(upgradeEffect);
                        Output.levels[hero_id].Add(level_table);
                    }
				}
			}



			//-----------------------------------------//
			foreach (var level_pair in Output.levels) {
				int ID = level_pair.Key;
				List<HeroLevelTable> levels = level_pair.Value;
				TableLike tla = Save (luaPath, tableRoot, ID, levels);
				Callback (tla, "LevelUp_" + ID);
			}

            foreach (var break_pair in Output.breaks)
            {
                int ID = break_pair.Key;
                List<HeroBreakTable> breaks = break_pair.Value;
                if(breaks.Count > 0)
                {
                    TableLike tla = Save(luaPath, tableRoot, ID, breaks);
                    Callback(tla, "Break_" + ID);
                }
            }
        }

        foreach (var level_pair in Output.levels)
        {
            int ID = level_pair.Key;

            HeroMaxLevel maxLevel = new HeroMaxLevel();
            maxLevel.ID.value = ID;
            maxLevel.ID.name = "编号";
            maxLevel.ID.label = "ID";
            maxLevel.ID.type = "int";

            maxLevel.Name.value = id_name_match[ID.ToString()];
            maxLevel.Name.name = "名称";
            maxLevel.Name.label = "Name";
            maxLevel.Name.type = "string";

            List<HeroLevelTable> levels = level_pair.Value;
            int total_sp_t0 = 0;
            int total_sp_t1 = 0;
            int total_sp_t2 = 0;
            for (int Ti = 0; Ti < 3; Ti++)
            {
                for (int i = 0; i < levels.Count; i++)
                {
                    var single_lv = levels[i];
                    if (Ti == single_lv.HeroT.value && Ti == 0)
                    {
                        total_sp_t0 += single_lv.NeedSP.value;
                    }
                    else if (Ti == single_lv.HeroT.value && Ti == 1)
                    {
                        total_sp_t1 += single_lv.NeedSP.value;
                    }
                    else if (Ti == single_lv.HeroT.value && Ti == 2)
                    {
                        total_sp_t2 += single_lv.NeedSP.value;
                    }
                }
            }

            maxLevel.T0_Max.value = total_sp_t0;
            maxLevel.T0_Max.name = "T0最大值";
            maxLevel.T0_Max.label = "LvMaxT0";
            maxLevel.T0_Max.type = "int";

            maxLevel.T1_Max.value = total_sp_t1;
            maxLevel.T1_Max.name = "T1最大值";
            maxLevel.T1_Max.label = "LvMaxT1";
            maxLevel.T1_Max.type = "int";

            maxLevel.T2_Max.value = total_sp_t2;
            maxLevel.T2_Max.name = "T2最大值";
            maxLevel.T2_Max.label = "LvMaxT2";
            maxLevel.T2_Max.type = "int";

            max_levels.Add(ID, maxLevel);
        }

        TableLike TL = SaveMaxLevels(luaPath, tableRoot + "/LevelUp/", max_levels);
        Callback(TL, "MaxLevel");
    }

    private TableLike SaveMaxLevels(string luaPath, string tablePath, Dictionary<int, HeroMaxLevel> maxlvs)
    {
        TableLike TL = new TableLike(maxlvs.Count + 3, HeroMaxLevel.Columns);

        List<HeroMaxLevel> lvlist = new List<HeroMaxLevel>();
        foreach(var pair in maxlvs)
        {
            HeroMaxLevel lv = pair.Value;
            lvlist.Add(lv);
        }

        for (int i = 0; i < 1; i++)
        {
            int j = 0;
            HeroMaxLevel lv = lvlist[0];
            TL.AddValue(i, j++, lv.Name.name.ToString());
            TL.AddValue(i, j++, lv.ID.name.ToString());
            TL.AddValue(i, j++, lv.T0_Max.name.ToString());
            TL.AddValue(i, j++, lv.T1_Max.name.ToString());
            TL.AddValue(i, j++, lv.T2_Max.name.ToString());
        }

        for (int i = 1; i < 2; i++)
        {
            int j = 0;
            HeroMaxLevel lv = lvlist[0];
            TL.AddValue(i, j++, lv.Name.label.ToString());
            TL.AddValue(i, j++, lv.ID.label.ToString());
            TL.AddValue(i, j++, lv.T0_Max.label.ToString());
            TL.AddValue(i, j++, lv.T1_Max.label.ToString());
            TL.AddValue(i, j++, lv.T2_Max.label.ToString());
        }

        for (int i = 2; i < 3; i++)
        {
            int j = 0;
            HeroMaxLevel lv = lvlist[0];
            TL.AddValue(i, j++, lv.Name.type.ToString());
            TL.AddValue(i, j++, lv.ID.type.ToString());
            TL.AddValue(i, j++, lv.T0_Max.type.ToString());
            TL.AddValue(i, j++, lv.T1_Max.type.ToString());
            TL.AddValue(i, j++, lv.T2_Max.type.ToString());
        }

        for (int i = 3; i < lvlist.Count + 3; i++)
        {
            int j = 0;
            HeroMaxLevel lv = lvlist[i-3];
            TL.AddValue(i, j++, lv.Name.value.ToString());
            TL.AddValue(i, j++, lv.ID.value.ToString());
            TL.AddValue(i, j++, lv.T0_Max.value.ToString());
            TL.AddValue(i, j++, lv.T1_Max.value.ToString());
            TL.AddValue(i, j++, lv.T2_Max.value.ToString());
        }

        StringBuilder strb = new StringBuilder();
        for (int i = 0; i < TL.Cells.GetLength(0); i++)
        {
            for (int j = 0; j < TL.Cells.GetLength(1); j++)
            {
                var value = TL.Cells[i, j];
                strb.Append(value + ",");
            }
            strb.Append("\r\n");
        }

        string file_path = tablePath + "//MaxLevelTable.csv";
        if (File.Exists(file_path))
        {
            FileStream fs = new FileStream(file_path, FileMode.Truncate, FileAccess.ReadWrite);
            fs.Close();
        }

        FileStream stream = File.Open(file_path, FileMode.Create);
        byte[] data = System.Text.Encoding.GetEncoding("GB2312").GetBytes(strb.ToString());
        stream.Write(data, 0, data.Length);
        stream.Flush();
        stream.Close();

        int columns = TL.Cells.GetLength(1);
        int rows = TL.Cells.GetLength(0);

        for (int i = 0; i < rows; i++)
        {
            for (int j = 0; j < columns; j++)
            {
                string value = TL.Cells[i, j].ToString();
                TL.Cells[i, j] = value.Replace(';', ',');
            }
        }
        return TL;
    }
#endif
}
