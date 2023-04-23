
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using Excel;
using System.IO;
#if UNITY_EDITOR
using System.Data;
#endif
using System.Text;
using System;
using System.Security.Cryptography;

public class ExcelImporterWindow :  EditorWindow
{
#if UNITY_EDITOR
    private bool IsDebug    = false;
    private bool IgnoreCard = false;
    private Dictionary<string, Dictionary<string, Hashtable>> BaseTypeList = new Dictionary<string, Dictionary<string, Hashtable>>();
    private Dictionary<string, string> NameToFileList = new Dictionary<string, string>();
    private Dictionary<string, DataTableCollection> RecordList = new Dictionary<string, DataTableCollection>();
    private Dictionary<string, List<DataTableCollection>> RecordCollectionList = new Dictionary<string, List<DataTableCollection>>();
    private Dictionary<string, string> FileMD5List = new Dictionary<string, string>();

    private List<string> Exclude = new List<string>()
    {
        "Wiki",
        "PetSkill",
        "Smriti",
        "SmritiEntity",
        "Inborn",
        "Spirit",
        "SpiritEntity",
        "SoulEffect",
        "EventChoice",
        "Event",
        "Environment",
        "JadeItem",
        "MaterialItem",
        "FoodItem",
        "Rune",
    };
    
    [SerializeField]
    public string ExcelPath = "";

    [SerializeField]
    public string LuaPath = "";

    [SerializeField]
    public string ServerLuaPath = "";

    public string MD5Path = null;

    public bool IsExportingServer = false;

    public bool ClearMD5 = false;

    [MenuItem("FoodWar/导表工具")]
    public static void Show()
    {
        ExcelImporterWindow window = EditorWindow.GetWindow<ExcelImporterWindow>();
    }

    public float BeginStamp = 0;


    //GUI OnEnable
    private void OnEnable()
    {
        MD5Path = Application.dataPath + "/../MD5/MD5.txt";
        this.title = "导表工具";
        this.maxSize = new Vector2(1000, 500);
        this.minSize = new Vector2(999, 499);

        if(EditorPrefs.HasKey("FoodWar_ExcelPath") == true)
        {
            this.ExcelPath = EditorPrefs.GetString("FoodWar_ExcelPath");
        }
        if (EditorPrefs.HasKey("FoodWar_LuaPath") == true)
        {
            this.LuaPath = EditorPrefs.GetString("FoodWar_LuaPath");
        }
        if(EditorPrefs.HasKey("FoodWar_ServerLuaPath") == true)
        {
            this.ServerLuaPath = EditorPrefs.GetString("FoodWar_ServerLuaPath");
        }
    }

    private void OnDisable()
    {
        EditorPrefs.SetString("FoodWar_ExcelPath", this.ExcelPath);
        EditorPrefs.SetString("FoodWar_LuaPath", this.LuaPath);
        EditorPrefs.SetString("FoodWar_ServerLuaPath", this.ServerLuaPath);
        GC.Collect();
    }

    private void TraverseLua_BaseType()
    {
        foreach(KeyValuePair<string, Dictionary<string, Hashtable>> pair in BaseTypeList)
        {
            string key = pair.Key;
            foreach(KeyValuePair<string, Hashtable> kpair in pair.Value)
            {
                //Debug.Log(kpair.Key + " " + kpair.Value["编号"]);
            }
        }
    }

    private void Export_BaseType(DataTableCollection c, string tableName)
    {
        //遍历result
        int columns = c[0].Columns.Count;       //获取列数
        int rows = c[0].Rows.Count;             //获取行数

        //row: ki == 0  表头
        //row: 字段名 - Value
        if (BaseTypeList.ContainsKey(tableName) == true)
        {
            throw new System.Exception("基本类型表名重复: " + tableName);
        }
        else
        {
            BaseTypeList.Add(tableName, new Dictionary<string, Hashtable>());
        }

        Dictionary<string, string> WikiPair = new Dictionary<string, string>();
        // var records = RecordList["Wiki"];
        // int records_Column = records[0].Columns.Count;          //获取列数
        // int rocords_Row = records[0].Rows.Count;                //获取行数
        // for (int kj = 3; kj < rocords_Row; kj++)
        // {
        //     string wiki_name = records[0].Rows[kj][0].ToString();
        //     string wiki_id = records[0].Rows[kj][1].ToString();
        //     if (!string.IsNullOrEmpty(wiki_name) && !string.IsNullOrEmpty(wiki_id))
        //     {
        //         WikiPair.Add(wiki_name, wiki_id);
        //     }
        // }

        NameToFileList.Add(c[0].Rows[0][0].ToString(), tableName);
        Hashtable NameTable = new Hashtable();
        for (int i = 0; i < columns; i++)
        {
            if (string.IsNullOrEmpty(c[0].Rows[0][i].ToString()) == false)
            {
                NameTable[i] = c[0].Rows[0][i].ToString();
            }
        }

        for (int i = 1; i < rows; i++)
        {
            string key = c[0].Rows[i][0].ToString();
            string value = c[0].Rows[i][1].ToString();
            string description = null;

            if (tableName.Equals("EventEffectList")) {
                description = c[0].Rows[i][2].ToString();
                if (!string.IsNullOrEmpty(key)) {
                    int intValue = 0;
                    if (int.TryParse(value, out intValue)) {
                        BaseTypeList[tableName].Add(key, new Hashtable());
                        BaseTypeList[tableName][key].Add(NameTable[1], value);


                        if (!string.IsNullOrEmpty(description)) {
                            BaseTypeList[tableName][key].Add(NameTable[2], description);
                        }
                    } else {
                        Debug.Log("Wrong Format: " + intValue + " KEY " + key);
                    }
                }
            }
            else if (tableName.Equals("GuideEffectList"))
            {
                if (NameTable.Count >= 3)
                {
                    description = c[0].Rows[i][2].ToString();
                }
                int intValue = 0;
                if (!string.IsNullOrEmpty(value))
                {
                    if (int.TryParse(value, out intValue))
                    {
                        BaseTypeList[tableName].Add(key, new Hashtable());
                        BaseTypeList[tableName][key].Add(NameTable[1], value);
                        if (!string.IsNullOrEmpty(description))
                        {
                            BaseTypeList[tableName][key].Add(NameTable[2], description);
                        }
                    }
                    else
                    {
                        Debug.Log("Wrong Format: " + intValue + " KEY " + key);
                    }
                }
            }
            else if (tableName.Equals("DungeonDpEffectList"))
            {
                description = c[0].Rows[i][2].ToString();
                if (!string.IsNullOrEmpty(key))
                {
                    int intValue = 0;
                    if (int.TryParse(value, out intValue)) {
                        BaseTypeList[tableName].Add(key, new Hashtable());
                        BaseTypeList[tableName][key].Add(NameTable[1], value);

                        if (!string.IsNullOrEmpty(description)) {
                            BaseTypeList[tableName][key].Add(NameTable[2], description);
                        }

                        if (!string.IsNullOrEmpty(c[0].Rows[i][3].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("clear", c[0].Rows[i][3].ToString());
                        }
                        else
                        {
                            BaseTypeList[tableName][key].Add("clear", "0");
                        }

                        if (!string.IsNullOrEmpty(c[0].Rows[i][4].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("choose", c[0].Rows[i][4].ToString());
                        }
                        else
                        {
                            BaseTypeList[tableName][key].Add("choose", "0");
                        }

                    } else {
                        Debug.Log("Wrong Format: " + intValue + " KEY " + key);
                    }
                }

            }
            else if (tableName.Equals("DevelopEffectList"))
            {
                description = c[0].Rows[i][4].ToString();
                if (!string.IsNullOrEmpty(key))
                {
                    int intValue = 0;
                    if (int.TryParse(value, out intValue))
                    {
                        if (BaseTypeList[tableName].ContainsKey(key))
                        {
                            throw new System.Exception("Already contained: " + key + " table: " + tableName);
                        }
                        BaseTypeList[tableName].Add(key, new Hashtable());
                        BaseTypeList[tableName][key].Add(NameTable[1], value);
                        BaseTypeList[tableName][key].Add("benefit", c[0].Rows[i][2].ToString());
                        if (!string.IsNullOrEmpty(c[0].Rows[i][3].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("forced", c[0].Rows[i][3].ToString());
                        }
                        else
                        {
                            BaseTypeList[tableName][key].Add("forced", "0");
                        }

                        if (!string.IsNullOrEmpty(c[0].Rows[i][5].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("c_id", c[0].Rows[i][5].ToString());
                        }
                        else
                        {
                            BaseTypeList[tableName][key].Add("c_id", "0");
                        }

                        if (!string.IsNullOrEmpty(c[0].Rows[i][6].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("type", c[0].Rows[i][6].ToString());
                        }
                        else
                        {
                            BaseTypeList[tableName][key].Add("type", "0");
                        }

                        if (!string.IsNullOrEmpty(c[0].Rows[i][7].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("nogoods", c[0].Rows[i][7].ToString());
                        }
                        else
                        {
                            BaseTypeList[tableName][key].Add("nogoods", "0");
                        }


                        if (!string.IsNullOrEmpty(description))
                        {
                            BaseTypeList[tableName][key].Add(NameTable[4], description);
                        }
                    }
                    else
                    {
                        Debug.Log("Wrong Format: " + intValue + " KEY " + key);
                    }
                }
            }
            else if (tableName.Equals("EventConditionList"))
            {
                if (NameTable.Count >= 3)
                {
                    description = c[0].Rows[i][2].ToString();
                }
                int intValue = 0;
                if (!string.IsNullOrEmpty(value))
                {
                    if (int.TryParse(value, out intValue))
                    {
                        BaseTypeList[tableName].Add(key, new Hashtable());
                        BaseTypeList[tableName][key].Add(NameTable[1], value);
                        if (!string.IsNullOrEmpty(description))
                        {
                            BaseTypeList[tableName][key].Add(NameTable[2], description);
                        }
                    }
                    else
                    {
                        Debug.Log("Wrong Format: " + intValue + " KEY " + key);
                    }
                }
            }
            else if (tableName.Equals("EffectList"))
            {
                int isFloor = 0;
                string link = "";
                string tag = "";
                description = c[0].Rows[i][2].ToString();
                if (!string.IsNullOrEmpty(key))
                {
                    int intValue = 0;
                    if (int.TryParse(value, out intValue))
                    {
                        BaseTypeList[tableName].Add(key, new Hashtable());
                        BaseTypeList[tableName][key].Add(NameTable[1], value);
                        if (!string.IsNullOrEmpty(description))
                        {
                            string new_description = description;
                            foreach (var pair in WikiPair)
                            {
                                string WikiName = pair.Key;
                                int WikiID = int.Parse(pair.Value);

                                //<link="id_01>
                                int index = new_description.IndexOf(WikiName);
                                if (index != -1)
                                {
                                    string s1 = new_description.Substring(0, index);
                                    string s2 = "";
                                    if ((index + WikiName.Length) < new_description.Length)
                                    {
                                        s2 = new_description.Substring(index + WikiName.Length, new_description.Length - index - WikiName.Length);
                                    }
                                    new_description = s1 + "<link=\\\"" + WikiID + "\\\">~" + WikiName + "`</link>" + s2;
                                }
                            }

                            BaseTypeList[tableName][key].Add(NameTable[2], new_description);
                        }
                    }
                    else
                    {
                        Debug.Log("Wrong Format: " + intValue + " KEY " + key);
                    }
                }
            }
            else if (tableName.Equals("TargetList"))
            {
                description = c[0].Rows[i][2].ToString();
                string fullDescription = c[0].Rows[i][3].ToString();
                if (!string.IsNullOrEmpty(key))
                {
                    int intValue = 0;
                    if (int.TryParse(value, out intValue))
                    {
                        BaseTypeList[tableName].Add(key, new Hashtable());
                        BaseTypeList[tableName][key].Add(NameTable[1], value);
                        if (!string.IsNullOrEmpty(description))
                        {
                            BaseTypeList[tableName][key].Add(NameTable[2], description);
                        }
                        if (!string.IsNullOrEmpty(fullDescription))
                        {
                            BaseTypeList[tableName][key].Add("full", fullDescription);
                        }
                        if (!string.IsNullOrEmpty(c[0].Rows[i][2].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("short", c[0].Rows[i][3].ToString());
                        }
                    }
                    else
                    {
                        Debug.Log("Wrong Format: " + intValue + " KEY " + key);
                    }
                }
            }
            else if (tableName.Equals("PropertyList"))
            {
                description = c[0].Rows[i][2].ToString();
                if (!string.IsNullOrEmpty(key))
                {
                    int intValue = 0;
                    if (int.TryParse(value, out intValue))
                    {
                        if (BaseTypeList[tableName].ContainsKey(key))
                        {
                            throw new System.Exception("Already contained: " + key + " table: " + tableName);
                        }
                        BaseTypeList[tableName].Add(key, new Hashtable());
                        BaseTypeList[tableName][key].Add(NameTable[1], value);
                        BaseTypeList[tableName][key].Add("benefit", c[0].Rows[i][2].ToString());

                        if (!string.IsNullOrEmpty(c[0].Rows[i][4].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("eff_value", c[0].Rows[i][4].ToString());
                        }
                        else
                        {
                            BaseTypeList[tableName][key].Add("eff_value", "0");
                        }

                        if (!string.IsNullOrEmpty(c[0].Rows[i][5].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("up_value", c[0].Rows[i][5].ToString());
                        }
                        else
                        {
                            BaseTypeList[tableName][key].Add("up_value", "0");
                        }

                        if (!string.IsNullOrEmpty(c[0].Rows[i][6].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("short", c[0].Rows[i][6].ToString());
                        }

                        Debug.Log("PropertyList ==========> " + description);
                        if (!string.IsNullOrEmpty(c[0].Rows[i][7].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("nostack", c[0].Rows[i][7].ToString());
                        }
                        else
                        {
                            BaseTypeList[tableName][key].Add("nostack", "0");
                        }

                        if (!string.IsNullOrEmpty(c[0].Rows[i][8].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("postset", c[0].Rows[i][8].ToString());
                        }
                        else
                        {
                            BaseTypeList[tableName][key].Add("postset", "0");
                        }

                        if (!string.IsNullOrEmpty(c[0].Rows[i][9].ToString()))
                        {
                            BaseTypeList[tableName][key].Add("wiki_id", c[0].Rows[i][9].ToString());
                        }


                        if (!string.IsNullOrEmpty(description))
                        {
                            BaseTypeList[tableName][key].Add(NameTable[4], description);
                        }
                    }
                    else
                    {
                        Debug.Log("Wrong Format: " + intValue + " KEY " + key);
                    }
                }
            }
            else
            {
                if (NameTable.Count >= 3)
                {
                    description = c[0].Rows[i][2].ToString();
                }
                if (!string.IsNullOrEmpty(key))
                {
                    int intValue = 0;
                    if (int.TryParse(value, out intValue))
                    {
                        BaseTypeList[tableName].Add(key, new Hashtable());
                        BaseTypeList[tableName][key].Add(NameTable[1], value);
                        if (!string.IsNullOrEmpty(description))
                        {
                            BaseTypeList[tableName][key].Add(NameTable[2], description);
                        }
                    }
                    else
                    {
                        Debug.Log("Wrong Format: " + intValue + " KEY " + key);
                    }
                }
            }
        }

        StringBuilder luaContent = new StringBuilder("return {\n");
        if (IsExportingServer == true)
        {
            luaContent = new StringBuilder(tableName + "Table = {\n");
        }
        foreach (KeyValuePair<string, Hashtable> pair in BaseTypeList[tableName])
        {
            if (pair.Value.Count == 1) {
                luaContent.Append("\t[" + pair.Value[NameTable[1]] + "] = \"" + pair.Key + "\",\n");
            }
            else if (tableName.Equals("DevelopEffectList"))
            {
                luaContent.Append("\t[" + pair.Value[NameTable[1]] + "] = { [1] = \"" + pair.Key);
                luaContent.Append("\", [2] = \"" + pair.Value[NameTable[4]]);
                luaContent.Append("\", [3] = " + pair.Value["benefit"]);
                luaContent.Append(", [4] = " + pair.Value["forced"]);
                luaContent.Append(", [5] = " + pair.Value["c_id"]);
                luaContent.Append(", [6] = " + pair.Value["type"]);
                luaContent.Append(", [7] = " + pair.Value["nogoods"]);
                luaContent.Append("},\n");
            }
            else if (tableName.Equals("PropertyList"))
            {
                luaContent.Append("\t[" + pair.Value[NameTable[1]] + "] = { [1] = \"" + pair.Key);
                luaContent.Append("\", [2] = \"" + pair.Value[NameTable[4]]);
                luaContent.Append("\", [3] = " + pair.Value["eff_value"]);
                luaContent.Append(", [4] = " + pair.Value["up_value"]);
                if(pair.Value.Contains("short"))
                    luaContent.Append(", [5] = \"" + pair.Value["short"] + "\"");
                luaContent.Append(", [6] = " + pair.Value["nostack"]);
                luaContent.Append(", [7] = " + pair.Value["postset"]);
                if (pair.Value.Contains("wiki_id"))
                    luaContent.Append(", [8] = " + pair.Value["wiki_id"]);

                luaContent.Append("},\n");

            }
            else if (tableName.Equals("DungeonDpEffectList"))
            {
                luaContent.Append("\t[" + pair.Value[NameTable[1]] + "] = { [1] = \"" + pair.Key);
                luaContent.Append("\", [2] = \"" + pair.Value[NameTable[2]]);
                luaContent.Append("\", [3] = " + pair.Value["clear"]);
                luaContent.Append(", [4] = " + pair.Value["choose"]);
                luaContent.Append("},\n");
            }
            else if (tableName.Equals ("EventEffectList")) {
                luaContent.Append("\t[" + pair.Value[NameTable[1]] + "] = { [1] = \"" + pair.Key);
                luaContent.Append("\", [2] = \"" + pair.Value[NameTable[2]]);
                luaContent.Append("\"},\n");
			} else if (tableName.Equals ("EffectList")) {
                luaContent.Append("\t[" + pair.Value[NameTable[1]] + "] = { [1] = \"" + pair.Key);
                luaContent.Append("\", [2] = \"" + pair.Value[NameTable[2]]);
                luaContent.Append("\"},\n");
			} else if (tableName.Equals ("EventConditionList")) {
                luaContent.Append("\t[" + pair.Value[NameTable[1]] + "] = { [1] = \"" + pair.Key);
                luaContent.Append("\", [2] = \"" + pair.Value [NameTable [2]]);
                luaContent.Append("\"},\n");
			}
            else if (tableName.Equals("TargetList"))
            {
                luaContent.Append("\t[" + pair.Value[NameTable[1]] + "] = { [1] = \"" + pair.Key);
                luaContent.Append("\", [2] = \"" + pair.Value[NameTable[2]]);
                luaContent.Append("\", [3] = \"" + pair.Value["short"]);
                luaContent.Append("\"},\n");
            }
            else
            {
                luaContent.Append("\t[" + pair.Value[NameTable[1]] + "] = { [1] = \"" + pair.Key);
                luaContent.Append("\", [2] = \"" + pair.Value[NameTable[2]]);
                luaContent.Append("\"},\n");
            }
        }
        luaContent.Append("}");

        string path = LuaPath;
        if(IsExportingServer == true)
        {
            path = ServerLuaPath;
        }

        if (File.Exists(path + "//" + tableName + "Table.lua"))
        {
            FileStream fs = new FileStream(path + "//" + tableName + "Table.lua", FileMode.Truncate, FileAccess.ReadWrite);
            fs.Close();
        }
            
        FileStream stream = File.Open(path + "//" + tableName + "Table.lua", FileMode.Create);
        byte[] data = System.Text.Encoding.UTF8.GetBytes(luaContent.ToString());
        stream.Write(data, 0, data.Length);
        stream.Flush();
        stream.Close();
    }

    private class Dialogue
    {
        public string ID = null;
        public string Name = null;
        public List<string> Contents = new List<string>();
        public List<bool> IsLeft = new List<bool>();
        public List<string> Talkers = new List<string>();
        public string FinishEffectRaw = null;
        public string PostProcessEffectRaw = null;
    }

    private void ExportDialogue(DataTableCollection c, string tableName)
    {
        List<Dialogue> dialogues = new List<Dialogue>();
        //遍历result
        int columns = c[0].Columns.Count;       //获取列数
        int rows = c[0].Rows.Count;          //获取行数

        //row: ki == 0  表头
        //row: k1 == 1  字段名
        //row: k2 == 2  类型
        List<string> TableHead = new List<string>();
        List<string> TableValStr = new List<string>();
        List<string> TableType = new List<string>();
        for (int j = 0; j < columns; j++)
        {
            string head = c[0].Rows[0][j].ToString();
            if (!string.IsNullOrEmpty(head))
            {
                TableHead.Add(head);
            }
        }
        columns = TableHead.Count;

        for (int j = 0; j < columns; j++)
        {
            string val = c[0].Rows[1][j].ToString();
            if (!string.IsNullOrEmpty(val))
            {
                TableValStr.Add(val);
            }
        }

        for (int j = 0; j < columns; j++)
        {
            string type = c[0].Rows[2][j].ToString();
            if (!string.IsNullOrEmpty(type))
            {
                TableType.Add(type);
            }
        }

        Dialogue current_dialogue = null;
        for (int i = 3; i < rows; i++)
        {
            string check = c[0].Rows[i][0].ToString();
            string tc = c[0].Rows[i][2].ToString();
            Dialogue dialogue = null;
            bool create_dialogue = false;

            if (string.IsNullOrEmpty(check) == true && string.IsNullOrEmpty(tc) == true)
            {
                break;
            }

            if (string.IsNullOrEmpty(check) == false)
            {
                if(current_dialogue != null)
                {
                    dialogues.Add(current_dialogue);
                }
                dialogue = new Dialogue();
                current_dialogue = dialogue;
                create_dialogue = true;
            }

            if (create_dialogue == true)
            {
                string name         = c[0].Rows[i][0].ToString();
                string id           = c[0].Rows[i][1].ToString();
                string content      = c[0].Rows[i][2].ToString();
                string talker       = c[0].Rows[i][3].ToString();
                string isleft       = c[0].Rows[i][4].ToString();
                string event_list   = c[0].Rows[i][5].ToString();
                string post_event_list   = c[0].Rows[i][6].ToString();

                current_dialogue.ID = id;
                current_dialogue.Name = name;
                current_dialogue.IsLeft.Add(string.IsNullOrEmpty(isleft) == false);
                current_dialogue.Talkers.Add(talker);
                current_dialogue.Contents.Add(content);
                current_dialogue.FinishEffectRaw = event_list;
                current_dialogue.PostProcessEffectRaw = post_event_list;
            }
            else
            {
                string content = c[0].Rows[i][2].ToString();
                string isleft = c[0].Rows[i][4].ToString();
                string talker = c[0].Rows[i][3].ToString();

                current_dialogue.IsLeft.Add(string.IsNullOrEmpty(isleft) == false);
                current_dialogue.Talkers.Add(talker);
                current_dialogue.Contents.Add(content);
            }
        }
        dialogues.Add(current_dialogue);

        StringBuilder luaContent = new StringBuilder();
        luaContent.Append("return {\n");
        if(IsExportingServer == true)
        {
            luaContent.Append(tableName + "Table = {\n");
        }

        foreach(Dialogue d in dialogues)
        {
            luaContent.Append("\t[" + d.ID + "] = {\n");
            luaContent.Append("\t\t" + "name" + " = \"" + d.Name + "\",\n");
            luaContent.Append("\t\t" + "id" + " = " + d.ID + ",\n");
            luaContent.Append("\t\t" + "contents" + " = {\n");

            for (int i = 0; i < d.Contents.Count; i++)
            {
                var t = d.IsLeft[i].ToCString().ToLower().ToString();
                luaContent.Append("\t\t\t" + "{ text" + " = \"" + d.Contents[i] 
                                            + "\", talker =" + d.Talkers[i] 
                                            + ", isleft =" + t + "},\n");
            }
            luaContent.Append("\t\t},\n");

            string[] elements = d.FinishEffectRaw.Split(',');
            luaContent.Append("\t\tfinish_effect = {\n");
            for (int k = 0; k < elements.Length; k++)
            {
                string[] pair = elements[k].Split(':');
                if (string.IsNullOrEmpty(pair[0]))
                {
                    continue;
                }
                if (pair.Length == 2)
                {
                    Hashtable table = null;
                    if (BaseTypeList["EventEffectList"].TryGetValue(pair[0], out table))
                    {
                        string content = "";
                        if (pair[1].Equals("x"))
                        {
                            content = "\t\t\t{id =" + table["编号"] + ", value =\"" + pair[1] + "\"},\n";
                        }
                        else if (pair[1].Contains("A") || pair[1].Contains("R("))  //说明是个计算公式
                        {
                            //作为一个计算公式，要考虑两点: 1. 给计算函数;  2. 给文字描述
                            content = "\t\t\t{id =" + table["编号"] + ", text =\"" + pair[1] + "\", " +
                                /*函数*/ "value = function(A) return " + pair[1];
                            if (pair[1].Contains("R("))
                            {
                                content += ", true";
                            }
                            content +=
                                " end"
                                + "},\n";
                            content = content.Replace("R", "math.random");
                            content = content.Replace("~", ",");
                        }
                        else
                        {
                            content = "\t\t\t{id =" + table["编号"] + ", value =" + CryptTE(int.Parse(pair[1])) + "},\n";
                        }
                        luaContent.Append(content);
                    }
                }
                else if (pair.Length == 1)
                {
                    Hashtable table = null;
                    if (BaseTypeList["EventEffectList"].TryGetValue(pair[0], out table))
                    {
                        luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + CryptTE(0) + "},\n");
                    }
                }
            }
            luaContent.Append("\t\t},\n");


            string[] telements = d.PostProcessEffectRaw.Split(',');
            luaContent.Append("\t\tredirect_effect = {\n");
            for (int k = 0; k < telements.Length; k++)
            {
                string[] pair = telements[k].Split(':');
                if (string.IsNullOrEmpty(pair[0]))
                {
                    continue;
                }
                if (pair.Length == 2)
                {
                    Hashtable table = null;
                    if (BaseTypeList["EventEffectList"].TryGetValue(pair[0], out table))
                    {
                        string content = "";
                        if (pair[1].Equals("x"))
                        {
                            content = "\t\t\t{id =" + table["编号"] + ", value =\"" + pair[1] + "\"},\n";
                        }
                        else if (pair[1].Contains("A") || pair[1].Contains("R("))  //说明是个计算公式
                        {
                            //作为一个计算公式，要考虑两点: 1. 给计算函数;  2. 给文字描述
                            content = "\t\t\t{id =" + table["编号"] + ", text =\"" + pair[1] + "\", " +
                                /*函数*/ "value = function(A) return " + pair[1];
                            if (pair[1].Contains("R("))
                            {
                                content += ", true";
                            }
                            content +=
                                " end"
                                + "},\n";
                            content = content.Replace("R", "math.random");
                            content = content.Replace("~", ",");
                        }
                        else
                        {
                            content = "\t\t\t{id =" + table["编号"] + ", value =" + CryptTE(int.Parse(pair[1])) + "},\n";
                        }
                        luaContent.Append(content);
                    }
                }
                else if (pair.Length == 1)
                {
                    Hashtable table = null;
                    if (BaseTypeList["EventEffectList"].TryGetValue(pair[0], out table))
                    {
                        luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + CryptTE(0) + "},\n");
                    }
                }
            }
            luaContent.Append("\t\t},\n");

            luaContent.Append("\t},\n");
        }
        luaContent.Append("}");

        string path = LuaPath;
        if (IsExportingServer == true)
        {
            path = ServerLuaPath;
        }

        if (File.Exists(path + "//" + tableName + "Table.lua"))
        {
            FileStream fs = new FileStream(path + "//" + tableName + "Table.lua", FileMode.Truncate, FileAccess.ReadWrite);
            fs.Close();
        }

        FileStream stream = File.Open(path + "//" + tableName + "Table.lua", FileMode.Create);
        byte[] data = System.Text.Encoding.UTF8.GetBytes(luaContent.ToString());
        stream.Write(data, 0, data.Length);
        stream.Flush();
        stream.Close();
    }

    private Dictionary<string, string> SkillPair            = new Dictionary<string, string>();
    private Dictionary<string, string> InbornPair           = new Dictionary<string, string>();
    private Dictionary<string, string> SpiritPair           = new Dictionary<string, string>();
    private Dictionary<string, string> SpiritEntityPair     = new Dictionary<string, string>();
    private Dictionary<string, string> SmritiPair           = new Dictionary<string, string>();
    private Dictionary<string, string> SmritiEntityPair     = new Dictionary<string, string>();
    private Dictionary<string, string> EnvPair              = new Dictionary<string, string>();

    private void ClearPreGenerate()
    {
        SkillPair.Clear();
        InbornPair.Clear();
        SpiritPair.Clear();
        SpiritEntityPair.Clear();
        SmritiPair.Clear();
        SmritiEntityPair.Clear();
        EnvPair.Clear();
    }

    private void PreGenerateMonsterPurpose()
    {
        SkillPair.Clear();
        var MonsterPurpose_records = RecordCollectionList["MonsterPurpose"];

        foreach (var records in MonsterPurpose_records)
        {
            int MonsterPurpose_records_Column = records[0].Columns.Count;          //获取列数
            int MonsterPurpose_rocords_Row = records[0].Rows.Count;                //获取行数
            for (int kj = 3; kj < MonsterPurpose_rocords_Row; kj++)
            {
                string skill_name = records[0].Rows[kj][0].ToString();
                string skill_id = records[0].Rows[kj][1].ToString();
                if (!string.IsNullOrEmpty(skill_name) && !string.IsNullOrEmpty(skill_id))
                {
                    SkillPair.Add(skill_name, skill_id);
                }
            }
        }
        }

    private void PreGenerate()
    {
        ClearPreGenerate();
        // var Spirit_records = RecordList["Spirit"];
        // int Spirit_records_Column = Spirit_records[0].Columns.Count;              //获取列数
        // int Spirit_rocords_Row = Spirit_records[0].Rows.Count;                    //获取行数
        // for (int kj = 3; kj < Spirit_rocords_Row; kj++)
        // {
        //     string skill_name = Spirit_records[0].Rows[kj][0].ToString();
        //     string skill_id = Spirit_records[0].Rows[kj][1].ToString();
        //     if (!string.IsNullOrEmpty(skill_name) && !string.IsNullOrEmpty(skill_id))
        //     {
        //         SpiritPair.Add(skill_name, skill_id);
        //     }
        // }

        // {
        //     var records = RecordList["JadeItem"];
        //     int records_Column = records[0].Columns.Count;              //获取列数
        //     int rocords_Row = records[0].Rows.Count;                    //获取行数
        //     for (int kj = 3; kj < rocords_Row; kj++)
        //     {
        //         string env_name = records[0].Rows[kj][0].ToString();
        //         string env_id = records[0].Rows[kj][1].ToString();
        //         if (!string.IsNullOrEmpty(env_name) && !string.IsNullOrEmpty(env_id))
        //         {
        //             EnvPair.Add(env_name, env_id);
        //         }
        //     }
        // }
        // {
        //     var records = RecordList["MaterialItem"];
        //     int records_Column = records[0].Columns.Count;              //获取列数
        //     int rocords_Row = records[0].Rows.Count;                    //获取行数
        //     for (int kj = 3; kj < rocords_Row; kj++)
        //     {
        //         string env_name = records[0].Rows[kj][0].ToString();
        //         string env_id = records[0].Rows[kj][1].ToString();
        //         if (!string.IsNullOrEmpty(env_name) && !string.IsNullOrEmpty(env_id))
        //         {
        //             EnvPair.Add(env_name, env_id);
        //         }
        //     }
        // }
        // {
        //     var records = RecordList["ProofItem"];
        //     int records_Column = records[0].Columns.Count;              //获取列数
        //     int rocords_Row = records[0].Rows.Count;                    //获取行数
        //     for (int kj = 3; kj < rocords_Row; kj++)
        //     {
        //         string env_name = records[0].Rows[kj][0].ToString();
        //         string env_id = records[0].Rows[kj][1].ToString();
        //         if (!string.IsNullOrEmpty(env_name) && !string.IsNullOrEmpty(env_id))
        //         {
        //             EnvPair.Add(env_name, env_id);
        //         }
        //     }
        // }
        // {
        //     //var records = RecordList["Rune"];
        //     //int records_Column = records[0].Columns.Count;              //获取列数
        //     //int rocords_Row = records[0].Rows.Count;                    //获取行数
        //     //for (int kj = 3; kj < rocords_Row; kj++)
        //     //{
        //     //    string env_name = records[0].Rows[kj][0].ToString();
        //     //    string env_id = records[0].Rows[kj][1].ToString();
        //     //    if (!string.IsNullOrEmpty(env_name) && !string.IsNullOrEmpty(env_id))
        //     //    {
        //     //        EnvPair.Add(env_name, env_id);
        //     //    }
        //     //}
        // }

        // var Smriti_records = RecordList["Smriti"];
        // int Smriti_records_Column = Smriti_records[0].Columns.Count;              //获取列数
        // int Smriti_rocords_Row = Smriti_records[0].Rows.Count;                    //获取行数
        // for (int kj = 3; kj < Smriti_rocords_Row; kj++)
        // {
        //     string skill_name = Smriti_records[0].Rows[kj][0].ToString();
        //     string skill_id = Smriti_records[0].Rows[kj][1].ToString();
        //     if (!string.IsNullOrEmpty(skill_name) && !string.IsNullOrEmpty(skill_id))
        //     {
        //         SmritiPair.Add(skill_name, skill_id);
        //     }
        // }

        // var SmritiEntity_records = RecordList["SmritiEntity"];
        // int SmritiEntity_records_Column = SmritiEntity_records[0].Columns.Count;              //获取列数
        // int SmritiEntity_rocords_Row = SmritiEntity_records[0].Rows.Count;                    //获取行数
        // for (int kj = 3; kj < SmritiEntity_rocords_Row; kj++)
        // {
        //     string skill_name = SmritiEntity_records[0].Rows[kj][0].ToString();
        //     string skill_id = SmritiEntity_records[0].Rows[kj][1].ToString();
        //     if (!string.IsNullOrEmpty(skill_name) && !string.IsNullOrEmpty(skill_id))
        //     {
        //         SmritiEntityPair.Add(skill_name, skill_id);
        //     }
        // }

        // var SpiritEntity_records = RecordList["SpiritEntity"];
        // int SpiritEntity_records_Column = SpiritEntity_records[0].Columns.Count;              //获取列数
        // int SpiritEntity_rocords_Row = SpiritEntity_records[0].Rows.Count;                    //获取行数
        // for (int kj = 3; kj < SpiritEntity_rocords_Row; kj++)
        // {
        //     string skill_name = SpiritEntity_records[0].Rows[kj][0].ToString();
        //     string skill_id = SpiritEntity_records[0].Rows[kj][1].ToString();
        //     if (!string.IsNullOrEmpty(skill_name) && !string.IsNullOrEmpty(skill_id))
        //     {
        //         SpiritEntityPair.Add(skill_name, skill_id);
        //     }
        // }
    }

    private StringBuilder GenerateLuaContent(DataTableCollection c, string tableName, StringBuilder luaContent)
    {
        //遍历result
        int columns = c[0].Columns.Count;       //获取列数
        int rows = c[0].Rows.Count;          //获取行数

        //row: ki == 0  表头
        //row: k1 == 1  字段名
        //row: k2 == 2  类型
        List<string> TableHead = new List<string>();
        List<string> TableValStr = new List<string>();
        List<string> TableType = new List<string>();
        for (int j = 0; j < columns; j++)
        {
            string head = c[0].Rows[0][j].ToString();
            if (!string.IsNullOrEmpty(head))
            {
                TableHead.Add(head);
            }
        }
        columns = TableHead.Count;

        for (int j = 0; j < columns; j++)
        {
            string val = c[0].Rows[1][j].ToString();
            if (!string.IsNullOrEmpty(val))
            {
                TableValStr.Add(val);
            }
        }

        for (int j = 0; j < columns; j++)
        {
            string type = c[0].Rows[2][j].ToString();
            if (!string.IsNullOrEmpty(type))
            {
                TableType.Add(type);
            }
        }


        float bb = Time.realtimeSinceStartup;
        float[] tp = new float[columns];
        int index = 1;
        for (int i = 3; i < rows; i++)
        {
            for (int j = 0; j < columns; j++)
            {
                if (tableName.Equals("MonsterPurpose_2001") == true)
                {
                    var aa = Time.realtimeSinceStartup - bb;
                    bb = Time.realtimeSinceStartup;
                    tp[j] += aa;
                }

                string value = c[0].Rows[i][j].ToString();
                if (IsDebug)
                {
                    var pi = i + 1;
                    var pj = j + 1;
                    Debug.Log("TABLE " + tableName + " 列 " + pj + " 行 " + pi + " 内容 " + value);
                }
                if (j == 0 && string.IsNullOrEmpty(value))
                {
                    break; //说明到底了
                }
                else if (j == 0 && !string.IsNullOrEmpty(value))
                {
                    luaContent.Append("\t[" + c[0].Rows[i][1].ToString() + "] = {\n");
                }
                string type = TableType[j];
                if (type.Equals("int"))
                {
                    int intValue = 0;
                    if (int.TryParse(value, out intValue))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + intValue + ",\n");
                    }
                }
                else if (type.Equals("long"))
                {
                    long longValue = 0;
                    if (long.TryParse(value, out longValue))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + longValue + ",\n");
                    }
                }
                else if (type.Equals("float"))
                {
                    float floatValue = 0;
                    if (float.TryParse(value, out floatValue))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + floatValue + ",\n");
                    }
                }
                else if (type.Equals("string"))
                {
                    if (NameToFileList.ContainsKey(TableHead[j]))
                    {
                        try
                        {
                            luaContent.Append("\t\t" + TableValStr[j] + " = " + BaseTypeList[NameToFileList[TableHead[j]]][value]["编号"] + ",\n");
                        }
                        catch (Exception e)
                        {
                            Debug.LogError("Exception " + e.ToString() + " Value " + value + " TableName " + tableName + " " + i + " " + j + " ");
                        }
                    }
                    else
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = \"" + value + "\",\n");
                    }
                }
                else if (type.Equals("tag_array"))
                {
                    if (string.IsNullOrEmpty(value) == false)
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                        string[] parts = value.Split(',');
                        for (int kk = 0; kk < parts.Length; kk++)
                        {
                            string tag_str = parts[kk];
                            if (BaseTypeList["TagList"].ContainsKey(tag_str))
                            {
                                luaContent.Append("\t\t\t " + BaseTypeList["TagList"][tag_str]["编号"] + ",\n");
                            }
                        }
                        luaContent.Append("\t\t" + "},\n");
                    }
                    else
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                        luaContent.Append("\t\t" + "},\n");
                    }
                }
                else if (type.Equals("action_array"))
                {
                    if (string.IsNullOrEmpty(value) == true)
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                    else
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                        if (!string.IsNullOrEmpty(value))
                        {
                            string[] parts = value.Split(',');
                            for (int kk = 0; kk < parts.Length; kk++)
                            {
                                string part = parts[kk];
                                string[] pair = part.Split(':');
                                luaContent.Append("\t\t\t" + pair[0] + " = " + pair[1] + ",\n");
                            }
                        }
                        luaContent.Append("\t\t" + "},\n");
                    }
 
                }
                //Condition
                else if (type.Equals("condition"))
                {
                    luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                    if (!string.IsNullOrEmpty(value))
                    {
                        string[] parts = value.Split(':');
                        string effKey = parts[0];
                        if (BaseTypeList["MonsterConditiontList"].ContainsKey(effKey))
                        {
                            string effVal = parts[1];
                            string[] effs = effVal.Split('|');
                            luaContent.Append("\t\t\t[" + BaseTypeList["MonsterConditiontList"][effKey]["编号"] + "] = { \n");
                            for (int cc = 0; cc < effs.Length; cc++)
                            {
                                var pair = effs[cc].Split('>');
                                if (pair.Length > 1)
                                {
                                    string skillName = pair[0];
                                    string skillNum = pair[1];
                                    if (SkillPair.ContainsKey(skillName))
                                    {
                                        luaContent.Append("\t\t\t\t{ id = " + SkillPair[skillName] + ", num = " + skillNum + ", },\n");
                                    }
                                    else
                                    {

                                    }
                                }
                                else
                                {
                                    string skillName = pair[0];
                                    if (SkillPair.ContainsKey(skillName))
                                    {
                                        luaContent.Append("\t\t\t\t" + SkillPair[skillName] + ",");
                                    }
                                    else
                                    {   //说明skillName不是一个技能
                                        luaContent.Append("\t\t\t\t" + skillName + ",\n");
                                    }
                                }
                            }
                            luaContent.Append("\n\t\t\t},");
                        }
                    }
                    luaContent.Append("\n\t\t" + "},\n");
                }
                else if (type.Equals("skill_array"))
                {

                }
                else if (type.Equals("smriti_talent_array"))
                {
                    if(string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                    else
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                        string[] parts = value.Split(',');
                        for (int kk = 0; kk < parts.Length; kk++)
                        {
                            string skillName = parts[kk];
                            if (SmritiPair.ContainsKey(skillName))
                            {
                                luaContent.Append("\t\t\t" + SmritiPair[skillName] + ",\n");
                            }
                        }
                        luaContent.Append("\t\t" + "},\n");
                    }

                }
                else if (type.Equals("smriti_array"))
                {
                    if(string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                    else
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                        string[] parts = value.Split(',');
                        for (int kk = 0; kk < parts.Length; kk++)
                        {
                            string skillName = parts[kk];
                            if (SmritiEntityPair.ContainsKey(skillName))
                            {
                                luaContent.Append("\t\t\t" + SmritiEntityPair[skillName] + ",\n");
                            }
                        }
                        luaContent.Append("\t\t" + "},\n");
                    }
                }
                else if (type.Equals("inborn_talent_array"))
                {
                    luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                    string[] parts = value.Split(',');
                    for (int kk = 0; kk < parts.Length; kk++)
                    {
                        string skillName = parts[kk];
                        if (InbornPair.ContainsKey(skillName))
                        {
                            luaContent.Append("\t\t\t" + InbornPair[skillName] + ",\n");
                        }
                    }
                    luaContent.Append("\t\t" + "},\n");
                }
                else if (type.Equals("pair_array"))
                {
                    string[] elements = value.Split(',');
                    luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                    for (int k = 0; k < elements.Length; k++)
                    {
                        string[] pair = elements[k].Split(':');
                        if (string.IsNullOrEmpty(pair[0]))
                        {
                            continue;
                        }
                        luaContent.Append("\t\t\t {id = " + pair[0] + ", value = " + pair[1] + "},\n");
                    }
                    luaContent.Append("\t\t},\n");
                }
                else if (type.Equals("spirit_talent_array"))
                {
                    luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                    string[] parts = value.Split(',');
                    for (int kk = 0; kk < parts.Length; kk++)
                    {
                        string skillName = parts[kk];
                        if (SpiritPair.ContainsKey(skillName))
                        {
                            luaContent.Append("\t\t\t" + SpiritPair[skillName] + ",\n");
                        }
                    }
                    luaContent.Append("\t\t" + "},\n");
                }
                else if (type.Equals("spirit_array"))
                {
                    luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                    string[] parts = value.Split(',');
                    for (int kk = 0; kk < parts.Length; kk++)
                    {
                        string skillName = parts[kk];
                        if (SpiritEntityPair.ContainsKey(skillName))
                        {
                            luaContent.Append("\t\t\t" + SpiritEntityPair[skillName] + ",\n");
                        }
                    }
                    luaContent.Append("\t\t" + "},\n");
                }
                else if (type.Equals("dungeon_node_array"))
                {
                    string[] elements = value.Split(',');
                    luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                    for (int k = 0; k < elements.Length; k++)
                    {
                        string[] pair = elements[k].Split(':');
                        if (string.IsNullOrEmpty(pair[0]))
                        {
                            continue;
                        }
                        Hashtable table = null;
                        if (BaseTypeList["DungeonNodeTypeList"].TryGetValue(pair[0], out table))
                        {
                            if (pair.Length > 1)
                            {
                                luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + pair[1] + "},\n");
                            }
                            else
                            {
                                luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + 0 + "},\n");
                            }
                        }
                        else
                        {
                            throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + value);
                        }
                    }
                    luaContent.Append("\t\t},\n");
                }
                else if (type.Equals("soul_effect_array"))
                {
                    var records = RecordList["SoulEffect"];
                    int records_Column = records[0].Columns.Count;              //获取列数
                    int rocords_Row = records[0].Rows.Count;                    //获取行数
                    Dictionary<string, string> SoulEffectPair = new Dictionary<string, string>();
                    for (int kj = 3; kj < rocords_Row; kj++)
                    {
                        string skill_name = records[0].Rows[kj][0].ToString();
                        string skill_id = records[0].Rows[kj][1].ToString();
                        if (!string.IsNullOrEmpty(skill_name) && !string.IsNullOrEmpty(skill_id))
                        {
                            SoulEffectPair.Add(skill_name, skill_id);
                        }
                    }

                    luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                    string[] parts = value.Split(',');
                    for (int kk = 0; kk < parts.Length; kk++)
                    {
                        string skillName = parts[kk];
                        if (SoulEffectPair.ContainsKey(skillName))
                        {
                            luaContent.Append("\t\t\t" + SoulEffectPair[skillName] + ",\n");
                        }
                    }
                    luaContent.Append("\t\t" + "},\n");
                }
                else if (type.Equals("option_array"))
                {
                    var records = RecordList["EventChoice"];
                    int records_Column = records[0].Columns.Count;              //获取列数
                    int rocords_Row = records[0].Rows.Count;                    //获取行数
                    Dictionary<string, string> EventOptionPair = new Dictionary<string, string>();
                    for (int kj = 3; kj < rocords_Row; kj++)
                    {
                        string skill_name = records[0].Rows[kj][0].ToString();
                        string skill_id = records[0].Rows[kj][1].ToString();
                        if (!string.IsNullOrEmpty(skill_name) && !string.IsNullOrEmpty(skill_id))
                        {
                            EventOptionPair.Add(skill_name, skill_id);
                        }
                    }

                    luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                    string[] parts = value.Split(',');
                    for (int kk = 0; kk < parts.Length; kk++)
                    {
                        string skillName = parts[kk];
                        if (EventOptionPair.ContainsKey(skillName))
                        {
                            luaContent.Append("\t\t\t" + EventOptionPair[skillName] + ",\n");
                        }
                    }
                    luaContent.Append("\t\t" + "},\n");
                }
                else if (type.Equals("event"))
                {
                    var records = RecordList["Event"];
                    int records_Column = records[0].Columns.Count;              //获取列数
                    int rocords_Row = records[0].Rows.Count;                    //获取行数
                    Dictionary<string, string> EventPair = new Dictionary<string, string>();
                    for (int kj = 3; kj < rocords_Row; kj++)
                    {
                        string skill_name = records[0].Rows[kj][0].ToString();
                        string skill_id = records[0].Rows[kj][1].ToString();
                        if (!string.IsNullOrEmpty(skill_name) && !string.IsNullOrEmpty(skill_id))
                        {
                            EventPair.Add(skill_name, skill_id);
                        }
                    }

                    int ID = -1;
                    luaContent.Append("\t\t" + TableValStr[j] + " = ");
                    string[] parts = value.Split(',');
                    for (int kk = 0; kk < parts.Length; kk++)
                    {
                        string skillName = parts[kk];
                        if (EventPair.ContainsKey(skillName))
                        {
                            ID = int.Parse(EventPair[skillName]);
                        }
                    }
                    luaContent.Append(ID + ",\n");
                }
                else if (type.Equals("event_array"))
                {
                    var records = RecordList["Event"];
                    int records_Column = records[0].Columns.Count;              //获取列数
                    int rocords_Row = records[0].Rows.Count;                    //获取行数
                    Dictionary<string, string> EventPair = new Dictionary<string, string>();
                    for (int kj = 3; kj < rocords_Row; kj++)
                    {
                        string skill_name = records[0].Rows[kj][0].ToString();
                        string skill_id = records[0].Rows[kj][1].ToString();
                        if (!string.IsNullOrEmpty(skill_name) && !string.IsNullOrEmpty(skill_id))
                        {
                            EventPair.Add(skill_name, skill_id);
                        }
                    }

                    luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                    string[] parts = value.Split(',');
                    for (int kk = 0; kk < parts.Length; kk++)
                    {
                        string skillName = parts[kk];
                        if (EventPair.ContainsKey(skillName))
                        {
                            luaContent.Append("\t\t\t" + EventPair[skillName] + ",\n");
                        }
                    }
                    luaContent.Append("\t\t" + "},\n");
                }
                //Purpose_Array
                else if (type.Equals("purpose_array"))
                {
                    var records_list = SkillPair;
                    luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");

                    string[] parts = value.Split(',');
                    for (int kk = 0; kk < parts.Length; kk++)
                    {
                        string skillName = parts[kk];
                        if (SkillPair.ContainsKey(skillName))
                        {
                            luaContent.Append("\t\t\t" + SkillPair[skillName] + ",\n");
                        }
                    }
                    luaContent.Append("\t\t" + "},\n");
                }
                else if (type.Equals("id_array"))
                {
                    if (string.IsNullOrEmpty(value) == false)
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                        string[] parts = value.Split(',');
                        for (int kk = 0; kk < parts.Length; kk++)
                        {
                            string skillID = parts[kk];
                            luaContent.Append("\t\t\t { id = " + skillID + "},\n");
                        }
                        luaContent.Append("\t\t" + "},\n");
                    }
                    else
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                        luaContent.Append("\t\t" + "},\n");
                    }
                }
                else if (type.Equals("string_array"))
                {
                    if (string.IsNullOrEmpty(value) == false)
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                        string[] parts = value.Split(',');
                        for (int kk = 0; kk < parts.Length; kk++)
                        {
                            string skillID = parts[kk];
                            luaContent.Append("\t\t\t\"" + skillID + "\",\n");
                        }
                        luaContent.Append("\t\t" + "},\n");
                    }
                    else
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                }
                else if (type.Equals("int_array"))
                {
                    if (string.IsNullOrEmpty(value) == false)
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "{" + "\n");
                        string[] parts = value.Split(',');
                        for (int kk = 0; kk < parts.Length; kk++)
                        {
                            string skillID = parts[kk];
                            luaContent.Append("\t\t\t" + skillID + ",\n");
                        }
                        luaContent.Append("\t\t" + "},\n");
                    }
                    else
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                }
                else if (type.Equals("array"))
                {   //事件系统里特有的array
                    if (string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                        continue;
                    }
                    string[] parts = value.Split(',');

                    luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                    Dictionary<string, string> namePair = new Dictionary<string, string>();
                    for (int event_i = 3; event_i < rows; event_i++)
                    {
                        string t = c[0].Rows[event_i][0].ToString();
                        if (!string.IsNullOrEmpty(t))
                        {
                            namePair.Add(t, c[0].Rows[event_i][1].ToString());
                        }
                    }
                    for (int ki = 0; ki < parts.Length; ki++)
                    {
                        if (namePair.ContainsKey(parts[ki]))
                        {
                            luaContent.Append("\t\t\t" + namePair[parts[ki]] + ",\n");
                        }
                    }
                    luaContent.Append("\t\t" + "},\n");
                }
                else if (type.Equals("guide_list"))
                {
                    if (string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                        continue;
                    }
                    string[] elements = value.Split(',');
                    luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                    for (int k = 0; k < elements.Length; k++)
                    {
                        string[] pair = elements[k].Split(':');
                        if (string.IsNullOrEmpty(pair[0]))
                        {
                            continue;
                        }
                        if (pair.Length == 2)
                        {
                            Hashtable table = null;
                            if (BaseTypeList["GuideEffectList"].TryGetValue(pair[0], out table))
                            {
                                string content = "";
                                if (pair[1].Contains("[") == true)
                                {
                                    var output = pair[1].Substring(1, pair[1].Length - 2);
                                    content = "\t\t\t{id =" + table["编号"] + ", value =\"" + output + "\"},\n";
                                }
                                else
                                {
                                    content = "\t\t\t{id =" + table["编号"] + ", value =" + pair[1] + "},\n";
                                }
                                luaContent.Append(content);
                            }
                            else
                            {
                                throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + value);
                            }
                        }
                        else if (pair.Length == 1)
                        {
                            Hashtable table = null;
                            if (BaseTypeList["GuideEffectList"].TryGetValue(pair[0], out table))
                            {
                                luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + 0 + "},\n");
                            }
                            else
                            {
                                throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + value);
                            }
                        }
                    }
                    luaContent.Append("\t\t},\n");
                }
                else if (type.Equals("condition_list"))
                {
                    if (string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                    else
                    {
                        string[] elements = value.Split(',');
                        luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                        for (int k = 0; k < elements.Length; k++)
                        {
                            string[] pair = elements[k].Split(':');
                            if (string.IsNullOrEmpty(pair[0]))
                            {
                                continue;
                            }
                            if (pair.Length == 2)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["EventConditionList"].TryGetValue(pair[0], out table))
                                {
                                    string content = "";
                                    if (pair[1].Equals("x"))
                                    {
                                        content = "\t\t\t{id =" + table["编号"] + ", value =\"" + pair[1] + "\"},\n";
                                    }
                                    else if (pair[1].Contains("A") || pair[1].Contains("R("))
                                    {  //说明是个计算公式
                                    //作为一个计算公式，要考虑两点: 1. 给计算函数;  2. 给文字描述
                                        content = "\t\t\t{id =" + table["编号"] + ", text =\"" + pair[1] + "\", " +
                                        /*函数*/
                                        "value = function(A) return " + pair[1];
                                        if (pair[1].Contains("R("))
                                        {
                                            content += ", true";
                                        }
                                        content +=
                                            " end"
                                        + "},\n";
                                        content = content.Replace("R", "math.random");
                                        content = content.Replace("~", ",");
                                    }
                                    else
                                    {
                                        content = "\t\t\t{id =" + table["编号"] + ", value =" + pair[1] + "},\n";
                                    }
                                    luaContent.Append(content);
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + value);
                                }
                            }
                            else if (pair.Length == 1)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["EventConditionList"].TryGetValue(pair[0], out table))
                                {
                                    luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + 0 + "},\n");
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + value);
                                }
                            }
                        }
                        luaContent.Append("\t\t},\n");
                    }
                }
                else if (type.Equals("property_list"))
                {
                    if (string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                    else
                    {
                        string[] elements = value.Split(',');
                        luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                        for (int k = 0; k < elements.Length; k++)
                        {
                            string[] pair = elements[k].Split(':');
                            if (string.IsNullOrEmpty(pair[0]))
                            {
                                continue;
                            }
                            if (pair.Length == 2)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["PropertyList"].TryGetValue(pair[0], out table))
                                {
                                    string content = "";
                                    if (pair[1].Equals("x"))
                                    {
                                        content = "\t\t\t{id =" + table["编号"] + ", value =\"" + pair[1] + "\"},\n";
                                    }
                                    else if (pair[1].Contains("A") || pair[1].Contains("R("))  //说明是个计算公式
                                    {
                                        //作为一个计算公式，要考虑两点: 1. 给计算函数;  2. 给文字描述
                                        content = "\t\t\t{id =" + table["编号"] + ", text =\"" + pair[1] + "\", " +
                                            /*函数*/ "value = function(A) return " + pair[1];
                                        if (pair[1].Contains("R("))
                                        {
                                            content += ", true";
                                        }
                                        content +=
                                            " end"
                                            + "},\n";
                                        content = content.Replace("R", "math.random");
                                        content = content.Replace("~", ",");
                                    }
                                    else
                                    {
                                        content = "\t\t\t{id =" + table["编号"] + ", value =" + CryptTE(int.Parse(pair[1])) + "},\n";
                                    }
                                    luaContent.Append(content);
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + elements[k]);
                                }
                            }
                            else if (pair.Length == 1)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["PropertyList"].TryGetValue(pair[0], out table))
                                {
                                    luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + CryptTE(0) + "},\n");
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + elements[k]);
                                }
                            }
                        }
                        luaContent.Append("\t\t},\n");
                    }
                }
                else if (type.Equals("develop_list"))
                {
                    if (string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                    else
                    {
                        string[] elements = value.Split(',');
                        luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                        for (int k = 0; k < elements.Length; k++)
                        {
                            string[] pair = elements[k].Split(':');
                            if (string.IsNullOrEmpty(pair[0]))
                            {
                                continue;
                            }
                            if (pair.Length == 2)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["DevelopEffectList"].TryGetValue(pair[0], out table) || BaseTypeList["DungeonDpEffectList"].TryGetValue(pair[0], out table))
                                {
                                    string content = "";
                                    if (pair[1].Equals("x"))
                                    {
                                        content = "\t\t\t{id =" + table["编号"] + ", value =\"" + pair[1] + "\"},\n";
                                    }
                                    else if (pair[1].Contains("A") || pair[1].Contains("R("))  //说明是个计算公式
                                    {
                                        //作为一个计算公式，要考虑两点: 1. 给计算函数;  2. 给文字描述
                                        content = "\t\t\t{id =" + table["编号"] + ", text =\"" + pair[1] + "\", " +
                                            /*函数*/ "value = function(A) return " + pair[1];
                                        if (pair[1].Contains("R("))
                                        {
                                            content += ", true";
                                        }
                                        content +=
                                            " end"
                                            + "},\n";
                                        content = content.Replace("R", "math.random");
                                        content = content.Replace("~", ",");
                                    }
                                    else
                                    {
                                        // Debug.LogError(" XX " + table["编号"] + " " + pair[1] + " " + i + " " + j);
                                        content = "\t\t\t{id =" + table["编号"] + ", value =" + CryptTE(int.Parse(pair[1])) + "},\n";
                                    }
                                    luaContent.Append(content);
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + elements[k]);
                                }
                            }
                            else if (pair.Length == 1)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["EventEffectList"].TryGetValue(pair[0], out table))
                                {
                                    luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + CryptTE(0) + "},\n");
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + elements[k]);
                                }
                            }
                        }
                        luaContent.Append("\t\t},\n");
                    }
                }
                else if (type.Equals("environment_list"))
                {
                    if (string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                    else
                    {
                        var records = RecordList["Environment"];
                        int records_Column = records[0].Columns.Count;              //获取列数
                        int rocords_Row = records[0].Rows.Count;                    //获取行数
                        Dictionary<string, string> EnvPair = new Dictionary<string, string>();
                        for (int kj = 3; kj < rocords_Row; kj++)
                        {
                            string env_name = records[0].Rows[kj][0].ToString();
                            string env_id = records[0].Rows[kj][1].ToString();
                            if (!string.IsNullOrEmpty(env_name) && !string.IsNullOrEmpty(env_id))
                            {
                                EnvPair.Add(env_name, env_id);
                            }
                        }

                        string[] elements = value.Split(',');
                        luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                        for (int k = 0; k < elements.Length; k++)
                        {
                            string name_tag = elements[k];
                            if (EnvPair.ContainsKey(name_tag) == true)
                            {
                                var ID = EnvPair[name_tag];
                                luaContent.Append("\t\t\t" + ID + ",\n");
                            }
                        }
                        luaContent.Append("\t\t},\n");
                    }
                }
                else if (type.Equals("res_list"))
                {
                    if (string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                        continue;
                    }
                    string[] elements = value.Split(',');
                    luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                    for (int k = 0; k < elements.Length; k++)
                    {
                        string name_tag = elements[k];
                        if (EnvPair.ContainsKey(name_tag) == true)
                        {
                            var ID = EnvPair[name_tag];
                            luaContent.Append("\t\t\t" + ID + ",\n");
                        }
                    }
                    luaContent.Append("\t\t},\n");
                }
                else if (type.Equals("event_list"))
                {
                    if (string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                    else
                    {
                        string[] elements = value.Split(',');
                        luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                        for (int k = 0; k < elements.Length; k++)
                        {
                            string[] pair = elements[k].Split(':');
                            if (string.IsNullOrEmpty(pair[0]))
                            {
                                continue;
                            }
                            if (pair.Length == 2)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["EventEffectList"].TryGetValue(pair[0], out table))
                                {
                                    string content = "";
                                    if (pair[1].Equals("x"))
                                    {
                                        content = "\t\t\t{id =" + table["编号"] + ", value =\"" + pair[1] + "\"},\n";
                                    }
                                    else if (pair[1].Contains("A") || pair[1].Contains("R("))  //说明是个计算公式
                                    {
                                        //作为一个计算公式，要考虑两点: 1. 给计算函数;  2. 给文字描述
                                        content = "\t\t\t{id =" + table["编号"] + ", text =\"" + pair[1] + "\", " +
                                            /*函数*/ "value = function(A) return " + pair[1];
                                        if (pair[1].Contains("R("))
                                        {
                                            content += ", true";
                                        }
                                        content +=
                                            " end"
                                            + "},\n";
                                        content = content.Replace("R", "math.random");
                                        content = content.Replace("~", ",");
                                    }
                                    else
                                    {
                                        content = "\t\t\t{id =" + table["编号"] + ", value =" + CryptTE(int.Parse(pair[1])) + "},\n";
                                    }
                                    luaContent.Append(content);
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + elements[k]);
                                }
                            }
                            else if (pair.Length == 1)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["EventEffectList"].TryGetValue(pair[0], out table))
                                {
                                    luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + CryptTE(0) + "},\n");
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName + " row " + i + " column " + j + " value " + elements[k]);
                                }
                            }
                        }
                        luaContent.Append("\t\t},\n");
                    }
                }
                else if (type.Equals("target_list"))
                {
                    if (string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                    else
                    {
                        string[] elements = value.Split(',');
                        luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                        for (int k = 0; k < elements.Length; k++)
                        {
                            string[] pair = elements[k].Split(':');
                            if (string.IsNullOrEmpty(pair[0]))
                            {
                                continue;
                            }
                            else if (pair.Length >= 1)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["TargetList"].TryGetValue(pair[0], out table))
                                {
                                    if(pair.Length == 1)
                                        luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + 0 + "},\n");
                                    else
                                        luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + pair[1] + "},\n");
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0]);
                                }
                            }
                        }
                        luaContent.Append("\t\t},\n");
                    }
                }
                else if (type.Equals("list"))
                {
                    if (string.IsNullOrEmpty(value))
                    {
                        luaContent.Append("\t\t" + TableValStr[j] + " = " + "Table.Empty," + "\n");
                    }
                    else
                    {
                        string[] elements = value.Split(',');
                        luaContent.Append("\t\t" + TableValStr[j] + " = {\n");
                        for (int k = 0; k < elements.Length; k++)
                        {
                            string[] pair = elements[k].Split(':');
                            if (string.IsNullOrEmpty(pair[0]))
                            {
                                continue;
                            }
                            if (pair.Length == 2)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["EffectList"].TryGetValue(pair[0], out table))
                                {
                                    string content = "";
                                    if (pair[1].Equals("x"))
                                    {
                                        content = "\t\t\t{id =" + table["编号"] + ", value =\"" + pair[1] + "\"},\n";
                                    }
                                    else if (pair[1].Contains("A") || pair[1].Contains("R("))  //说明是个计算公式
                                    {
                                        //作为一个计算公式，要考虑两点: 1. 给计算函数;  2. 给文字描述
                                        content = "\t\t\t{id =" + table["编号"] + ", text =\"" + pair[1] + "\", " +
                                            /*函数*/ "value = function(A) return " + pair[1];
                                        if (pair[1].Contains("R("))
                                        {
                                            content += ", true";
                                        }
                                        content +=
                                        " end"
                                        + "},\n";
                                        content = content.Replace("R", "math.random");
                                        content = content.Replace("~", ",");
                                    }
                                    else
                                    {
                                        content = "\t\t\t{id =" + table["编号"] + ", value =" + CryptTE(int.Parse(pair[1])) + "},\n";
                                    }
                                    luaContent.Append(content);
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0] + " table " + tableName);
                                }
                            }
                            else if (pair.Length == 1)
                            {
                                Hashtable table = null;
                                if (BaseTypeList["EffectList"].TryGetValue(pair[0], out table))
                                {
                                    luaContent.Append("\t\t\t{id =" + table["编号"] + ", value = " + CryptTE(0) + "},\n");
                                }
                                else
                                {
                                    throw new System.Exception("BaseTypeList Key Not Found" + pair[0]);
                                }
                            }
                        }
                        luaContent.Append("\t\t},\n");
                    }
                }

                if (j == columns - 1)
                {
                    luaContent.Append("\t},\n");
                }
            }
            index++;
        }

        return luaContent;
    }
    
    private void ExportLua(DataTableCollection c, string tableName, LuaFileExtraInfo extraInfo = null)
    {
        EditorUtility.DisplayProgressBar("Import", "读取: " + tableName, 0);
    
        StringBuilder luaContent = new StringBuilder("");

        if(IsExportingServer == true)
        {
            luaContent = new StringBuilder(tableName + "Table = {\n");
            luaContent = GenerateLuaContent(c, tableName, luaContent);
            luaContent.Append("}\n");
        }
        else
        {
            luaContent = new StringBuilder("return {\n");
            Debug.LogError("TABLE NAME " + tableName);
            luaContent = GenerateLuaContent(c, tableName, luaContent);
            luaContent.Append("}\n");
        }

        EditorUtility.DisplayProgressBar("Import", "读取: " + tableName, 1);

        string path = LuaPath;
        if (IsExportingServer == true)
        {
            path = ServerLuaPath;
        }

        string store_path = path + "//" + tableName + "Table.lua";
        if(extraInfo != null)
        {
            if(extraInfo.replace != null)
            {
                tableName = extraInfo.replace;
            }
            if(extraInfo.sub != null)
            {
                store_path = LuaPath + "//" + extraInfo.sub + "//" + tableName + "Table.lua";

                if (Directory.Exists(LuaPath + "//" + extraInfo.sub) == false)
                {
                    Directory.CreateDirectory(LuaPath + "//" + extraInfo.sub);
                }
            }
            else
            {
                store_path = LuaPath + "//" + tableName + "Table.lua";
            }
        }


        if (File.Exists(store_path))
        {
            FileStream fs = new FileStream(store_path, FileMode.Truncate, FileAccess.ReadWrite);
            fs.Close();
        }

        FileStream stream = File.Open(store_path, FileMode.Create);
        byte[] data = System.Text.Encoding.UTF8.GetBytes(luaContent.ToString());
        stream.Write(data, 0, data.Length);
        stream.Flush();
        stream.Close();

        EditorUtility.ClearProgressBar();
    }

    private void ParseCollections(string directory, LuaFileExtraInfo extraInfo, string recordName)
    {
        var time = Time.realtimeSinceStartup;
        string[] filePaths = Directory.GetFiles(directory);
        List<DataTableCollection> t_collections = new List<DataTableCollection>();
        List<bool> Md5Changed = new List<bool>();
        List<string> tableNames = new List<string>();

        for (int i = 0; i < filePaths.Length; i++)
        {
            string filePath = filePaths[i];
            string tableName = System.IO.Path.GetFileNameWithoutExtension(filePath);
            if (!RecordList.ContainsKey(tableName))
            {
                if (filePath.EndsWith(".xlsx") || filePath.EndsWith(".xls"))
                {
                    FileStream stream = File.Open(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
                    string md5 = GetFileMD5(stream);
                    IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                    DataSet result = excelReader.AsDataSet();

                    t_collections.Add(result.Tables);
                    tableNames.Add(tableName);
                    stream.Close();

                    if (FileMD5List.ContainsKey(filePath) == false)
                    {
                        Md5Changed.Add(true);
                        FileMD5List.Add(filePath, md5);
                    }
                    else if(FileMD5List[filePath].Equals(md5) == false)
                    {
                        Md5Changed.Add(true);
                        FileMD5List[filePath] = md5;
                    }
                    else
                    {
                        Md5Changed.Add(false);
                    }

                }
                else
                {
                    continue;
                }
            }
        }

        RecordCollectionList.Add(recordName, t_collections);

        var time_next = Time.realtimeSinceStartup;
        var diff = time_next - time;
        time = time_next;

        

        bool once_changed = false;
        foreach(bool changed in Md5Changed)
        {
            if(changed == true)
            {
                once_changed = true;
                break;
            }
        }
        if(once_changed == true)
        {
            StringBuilder luaContent = new StringBuilder("return {\n");

            if (IsExportingServer == true)
            {
                luaContent = new StringBuilder(extraInfo.replace.Substring(0, extraInfo.replace.Length - 4) + " = {\n");
            }

            for (int i = 0; i < t_collections.Count; i++)
            {
                time_next = Time.realtimeSinceStartup;
                diff = time_next - time;
                time = time_next;
                //Debug.Log("READ " + tableNames[i] + " " + diff);

                luaContent = GenerateLuaContent(t_collections[i], tableNames[i], luaContent);

                time_next = Time.realtimeSinceStartup;
                diff = time_next - time;
                time = time_next;
                //Debug.Log("PASS " + tableNames[i] + " " + diff);
            }
            luaContent.Append("}\n");

            string path = LuaPath;
            if (IsExportingServer == true)
            {
                path = ServerLuaPath;
            }

            string store_path = path + "//" + extraInfo.replace;
            if (extraInfo != null)
            {
                if (extraInfo.sub != null)
                {
                    store_path = path + "//" + extraInfo.sub + "//" + extraInfo.replace;

                    if (Directory.Exists(path + "//" + extraInfo.sub) == false)
                    {
                        Directory.CreateDirectory(path + "//" + extraInfo.sub);
                    }
                }
                else
                {
                    store_path = path + "//" + extraInfo.replace;
                }
            }


            if (File.Exists(store_path))
            {
                FileStream fs = new FileStream(store_path, FileMode.Truncate, FileAccess.ReadWrite);
                fs.Close();
            }

            FileStream stream1 = File.Open(store_path, FileMode.Create);
            byte[] data = System.Text.Encoding.UTF8.GetBytes(luaContent.ToString());
            stream1.Write(data, 0, data.Length);
            stream1.Flush();
            stream1.Close();
        }
    }

    private void Parse(string directory, LuaFileExtraInfo extraInfo = null)
    {
        var time = Time.realtimeSinceStartup;
        string[] filePaths = Directory.GetFiles(directory);
        
        var time_next = Time.realtimeSinceStartup;
        var diff = time_next - time;
        time = time_next;

        for (int i = 0; i < filePaths.Length; i++)
        {
            string filePath = filePaths[i];
            if (filePath.EndsWith(".xlsx") || filePath.EndsWith(".xls"))
            {
                FileStream stream = File.Open(filePath, FileMode.Open, FileAccess.Read, FileShare.Read);
                string md5 = GetFileMD5(stream);
                string tableName = System.IO.Path.GetFileNameWithoutExtension(filePath);

                if (FileMD5List.ContainsKey(filePath) == false)
                {
                    IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                    DataSet result = excelReader.AsDataSet();

                    time_next = Time.realtimeSinceStartup;
                    diff = time_next - time;
                    time = time_next;
                    Debug.Log("READ " + filePath + " " + diff);

                    if (tableName.Equals("Dialogue"))
                    {
                        ExportDialogue(result.Tables, tableName);
                    }
                    else
                    {
                        ExportLua(result.Tables, tableName, extraInfo);
                    }

                    time_next = Time.realtimeSinceStartup;
                    diff = time_next - time;
                    time = time_next;
                    //Debug.Log("PASS " + filePath + " " + diff);

                    stream.Close();
                    FileMD5List.Add(filePath, md5);
                }
                else if (FileMD5List[filePath].Equals(md5) == false || Exclude.Contains(tableName))
                {
                    IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                    DataSet result = excelReader.AsDataSet();

                    time_next = Time.realtimeSinceStartup;
                    diff = time_next - time;
                    time = time_next;
                    //Debug.Log("READ " + filePath + " " + diff);

                    if (tableName.Equals("Dialogue"))
                    {
                        ExportDialogue(result.Tables, tableName);
                    }
                    else
                    {
                        ExportLua(result.Tables, tableName, extraInfo);
                    }

                    time_next = Time.realtimeSinceStartup;
                    diff = time_next - time;
                    time = time_next;
                    //Debug.Log("PASS " + filePath + " " + diff);

                    stream.Close();
                    FileMD5List[filePath] = md5;
                }
                else
                {
                    Debug.Log("Omit " + tableName);
                }
            }
            else
            {
                continue;
            }
        }
    }

    //界面：
    //1. 一个Excel表写入路径;
    //2. 一个lua表导出路径;
    //执行button
    private void OnGUI()
    {
        Vector2 beginPivot = new Vector2(30, 50);
        GUI.Label(new Rect(beginPivot.x, beginPivot.y, 200, 30), "Excel路径:");
        this.ExcelPath = GUI.TextField(new Rect(beginPivot.x, beginPivot.y + 30, 500, 20), this.ExcelPath);
        if(GUI.Button(new Rect(beginPivot.x + 530, beginPivot.y + 30, 100, 20), "选取"))
        {
            string path = EditorUtility.OpenFolderPanel("选择Excel的路径", ExcelPath, "");
            if(!string.IsNullOrEmpty(path))
            {
                this.ExcelPath = path;
            }
        }

        GUI.Label(new Rect(beginPivot.x, beginPivot.y + 80, 200, 30), "Lua路径:");
        this.LuaPath = GUI.TextField(new Rect(beginPivot.x, beginPivot.y + 30 + 80, 500, 20), this.LuaPath);
        if (GUI.Button(new Rect(beginPivot.x + 530, beginPivot.y + 30 + 80, 100, 20), "选取"))
        {
            string path = EditorUtility.OpenFolderPanel("选择Lua的路径", LuaPath, "");
            if (!string.IsNullOrEmpty(path))
            {
                this.LuaPath = path;
            }
        }

        GUI.Label(new Rect(beginPivot.x, beginPivot.y + 160, 200, 30), "Server Lua路径:");
        this.ServerLuaPath = GUI.TextField(new Rect(beginPivot.x, beginPivot.y + 30 + 160, 500, 20), this.ServerLuaPath);
        if (GUI.Button(new Rect(beginPivot.x + 530, beginPivot.y + 30 + 160, 100, 20), "选取"))
        {
            string path = EditorUtility.OpenFolderPanel("选择Server Lua的路径", LuaPath, "");
            if (!string.IsNullOrEmpty(path))
            {
                this.ServerLuaPath = path;
            }
        }

        ClearMD5 = GUI.Toggle(new Rect(this.position.width - 300, this.position.height - 220, 250, 80), ClearMD5, "重新导入");

        IsDebug = GUI.Toggle(new Rect(this.position.width - 300, this.position.height - 250, 250, 80), IsDebug, "输出日志");

        IgnoreCard = GUI.Toggle(new Rect(this.position.width - 300, this.position.height - 280, 250, 80), IgnoreCard, "忽略表格");

        if (GUI.Button(new Rect(this.position.width - 300, this.position.height - 200, 250, 80), "打印基本表"))
        {
            TraverseLua_BaseType();
        }

        if (GUI.Button(new Rect(100, this.position.height - 100, 250, 80), "服务器执行"))
        {
            FileMD5List.Clear();
            ClearPreGenerate();
            {
                IsExportingServer = true;
                NameToFileList.Clear();
                BaseTypeList.Clear();
                string[] directoryPaths = Directory.GetDirectories(ExcelPath);

                string dungeonDetailPath = null;

                List<string> recordPaths = new List<string>();
                foreach(string p in directoryPaths)
                {
                    recordPaths.Add(p);
                }
                recordPaths.Add(ExcelPath);

                //先导入所有表的索引
                for (int i = 0; i < recordPaths.Count; i++)
                {
                    string directory = recordPaths[i];
                    if (Directory.Exists(directory))
                    {
                        string[] basePaths = Directory.GetFiles(directory);
                        for (int p = 0; p < basePaths.Length; p++)
                        {
                            string basePath = basePaths[p];
                            if (directory.Contains("策划案") == true)
                            {
                                continue;
                            }
                            if (directory.Contains(".git") == true)
                            {
                                continue;

                            }
                            if (basePath.EndsWith(".xlsx") || basePath.EndsWith(".xls"))
                            {
                                FileStream stream = File.Open(basePath, FileMode.Open, FileAccess.Read, FileShare.Read);
                                string tableName = System.IO.Path.GetFileNameWithoutExtension(basePath);
                                IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                                DataSet result = excelReader.AsDataSet();

                                if (RecordList.ContainsKey(tableName) == false)
                                {
                                    //Debug.Log("Add Record " + tableName);
                                    RecordList.Add(tableName, result.Tables);
                                }
                                stream.Close();
                            }
                        }

                        var time_passed = Time.realtimeSinceStartup - BeginStamp;
                        Debug.Log("--- INFO --- RECORD DIRECTORY " + directory + "Time Passed " + time_passed);
                        BeginStamp = Time.realtimeSinceStartup;
                    }
                }

                PreGenerate();

                for (int i = 0; i < directoryPaths.Length; i++)
                {

                    string directory = directoryPaths[i];
                    if (directory.Contains("策划案") == true)
                    {
                        continue;
                    }
                    if (directory.Contains(".git") == true)
                    {
                        continue;
                    }
                    //读取BaseType
                    if (Directory.Exists(directory) && directory.Contains("BaseType"))
                    {
                        string[] basePaths = Directory.GetFiles(directory);
                        for (int p = 0; p < basePaths.Length; p++)
                        {
                            string basePath = basePaths[p];
                            if (basePath.EndsWith(".xlsx") || basePath.EndsWith(".xls"))
                            {
                                FileStream stream = File.Open(basePath, FileMode.Open, FileAccess.Read, FileShare.Read);
                                IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                                DataSet result = excelReader.AsDataSet();


                                string tableName = System.IO.Path.GetFileNameWithoutExtension(basePath);
                                Export_BaseType(result.Tables, tableName);
                                
                                stream.Close();
                            }
                        }
                    }
                    else if (Directory.Exists(directory) && directory.Contains("DungeonDetail"))
                    {
                        dungeonDetailPath = directory;
                    }
                    else if (Directory.Exists(directory) && directory.Contains("MetaHero"))
                    {
                        if (IgnoreCard == false)
                        {
                            //ExcelGenerator generator = new ExcelGenerator(ExportLua);
                            //generator.Load(directory, LuaPath);
                        }
                    }
                    else if (Directory.Exists(directory))
                    {
                        Parse(directory);
                    }
                }

                float time_passed0 = Time.realtimeSinceStartup - BeginStamp;
                Debug.Log("--- INFO --- PARSE DIRECTORY Time Passed " + time_passed0);
                BeginStamp = Time.realtimeSinceStartup;

                Parse(ExcelPath);

                float time_passed2 = Time.realtimeSinceStartup - BeginStamp;
                Debug.Log("--- INFO --- PARSE ExcelPath " + ExcelPath + " Time Passed " + time_passed2);
                BeginStamp = Time.realtimeSinceStartup;

                //------------- 对DetailPath进行处理 -------------//
                // string[] dungeonDirectories = Directory.GetDirectories(dungeonDetailPath);
                // foreach (string dungeon_table_directories in dungeonDirectories)
                // {
                //     string name = Path.GetFileNameWithoutExtension(dungeon_table_directories);
                //     name = name.Substring(2);
                    
                //     LuaFileExtraInfo extra_info = new LuaFileExtraInfo();
                //     extra_info.replace = name + "Table.lua";
                //     ParseCollections(dungeon_table_directories, extra_info, name);

                //     if (name.Equals("MonsterPurpose"))
                //     {
                //         PreGenerateMonsterPurpose();
                //     }

                //     float time_passeddg = Time.realtimeSinceStartup - BeginStamp;
                //     Debug.Log("-- INFO -- PARSE DungeonPath " + name + " " + time_passeddg);
                //     BeginStamp = Time.realtimeSinceStartup;
                // }
                //------------- 对DetailPath进行处理 -------------//
                float time_passed3 = Time.realtimeSinceStartup - BeginStamp;
                Debug.Log("-- INFO -- PARSE DungeonPath Time Passed " + time_passed3);
                BeginStamp = Time.realtimeSinceStartup;

                RecordList.Clear();
                RecordCollectionList.Clear();
            }
            ClearPreGenerate();
        }

        if (GUI.Button(new Rect(this.position.width - 300, this.position.height - 100, 250, 80), "执行"))
        {
            BeginStamp = Time.realtimeSinceStartup;
            ImportMD5();
            ClearPreGenerate();
            {
                IsExportingServer = false;
                NameToFileList.Clear();
                BaseTypeList.Clear();
                string[] directoryPaths = Directory.GetDirectories(ExcelPath);

                string dungeonDetailPath = null;

                List<string> recordPaths = new List<string>();
                foreach(string p in directoryPaths)
                {
                    recordPaths.Add(p);
                }
                recordPaths.Add(ExcelPath);

                //先导入所有表的索引
                for (int i = 0; i < recordPaths.Count; i++)
                {
                    string directory = recordPaths[i];
                    if (Directory.Exists(directory))
                    {
                        string[] basePaths = Directory.GetFiles(directory);
                        for (int p = 0; p < basePaths.Length; p++)
                        {
                            Debug.Log("--- INFO --- INTO DIRECTORY " + directory);
                            string basePath = basePaths[p];
                            if (directory.Contains("策划案") == true)
                            {
                                continue;
                            }
                            if (directory.Contains(".git") == true)
                            {
                                continue;
                            }
                            if (basePath.EndsWith(".xlsx") || basePath.EndsWith(".xls"))
                            {
                                Debug.Log("--- INFO --- OPEN PATH " + basePath);
                                FileStream stream = File.Open(basePath, FileMode.Open, FileAccess.Read, FileShare.Read);
                                string tableName = System.IO.Path.GetFileNameWithoutExtension(basePath);
                                IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                                DataSet result = excelReader.AsDataSet();
                                
                                if (RecordList.ContainsKey(tableName) == false)
                                {
                                    RecordList.Add(tableName, result.Tables);
                                }
                                stream.Close();
                            }
                        }

                        var time_passed = Time.realtimeSinceStartup - BeginStamp;
                        Debug.Log("--- INFO --- RECORD DIRECTORY " + directory + "Time Passed " + time_passed);
                        BeginStamp = Time.realtimeSinceStartup;
                    }
                }

                PreGenerate();

                for (int i = 0; i < directoryPaths.Length; i++)
                {

                    string directory = directoryPaths[i];
                    if (directory.Contains("策划案") == true)
                    {
                        continue;
                    }
                    if (directory.Contains(".git") == true)
                    {
                        continue;
                    }
                    //读取BaseType
                    if (Directory.Exists(directory) && directory.Contains("BaseType"))
                    {
                        string[] basePaths = Directory.GetFiles(directory);
                        for (int p = 0; p < basePaths.Length; p++)
                        {
                            string basePath = basePaths[p];
                            if (basePath.EndsWith(".xlsx") || basePath.EndsWith(".xls"))
                            {
                                FileStream stream = File.Open(basePath, FileMode.Open, FileAccess.Read, FileShare.Read);
                                IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                                DataSet result = excelReader.AsDataSet();
                                
                                string tableName = System.IO.Path.GetFileNameWithoutExtension(basePath);
                                Export_BaseType(result.Tables, tableName);
                                
                                stream.Close();
                            }
                        }
                    }
                    else if (Directory.Exists(directory) && directory.Contains("DungeonDetail"))
                    {
                        dungeonDetailPath = directory;
                    }
                    else if (Directory.Exists(directory) && directory.Contains("MetaHero"))
                    {
                        if (IgnoreCard == false)
                        {
                            //ExcelGenerator generator = new ExcelGenerator(ExportLua);
                            //generator.Load(directory, LuaPath);
                        }
                    }
                    else if (Directory.Exists(directory))
                    {
                        Parse(directory);
                    }
                }

                float time_passed0 = Time.realtimeSinceStartup - BeginStamp;
                Debug.Log("--- INFO --- PARSE DIRECTORY Time Passed " + time_passed0);
                BeginStamp = Time.realtimeSinceStartup;

                Parse(ExcelPath);

                float time_passed2 = Time.realtimeSinceStartup - BeginStamp;
                Debug.Log("--- INFO --- PARSE ExcelPath " + ExcelPath + " Time Passed " + time_passed2);
                BeginStamp = Time.realtimeSinceStartup;

                //------------- 对DetailPath进行处理 -------------//
                // string[] dungeonDirectories = Directory.GetDirectories(dungeonDetailPath);
                // foreach (string dungeon_table_directories in dungeonDirectories)
                // {
                //     string name = Path.GetFileNameWithoutExtension(dungeon_table_directories);
                //     name = name.Substring(2);
                    
                //     LuaFileExtraInfo extra_info = new LuaFileExtraInfo();
                //     extra_info.replace = name + "Table.lua";
                //     ParseCollections(dungeon_table_directories, extra_info, name);

                //     if (name.Equals("MonsterPurpose"))
                //     {
                //         PreGenerateMonsterPurpose();
                //     }

                //     float time_passeddg = Time.realtimeSinceStartup - BeginStamp;
                //     Debug.Log("-- INFO -- PARSE DungeonPath " + name + " " + time_passeddg);
                //     BeginStamp = Time.realtimeSinceStartup;
                // }
                //------------- 对DetailPath进行处理 -------------//
                float time_passed3 = Time.realtimeSinceStartup - BeginStamp;
                Debug.Log("-- INFO -- PARSE DungeonPath Time Passed " + time_passed3);
                BeginStamp = Time.realtimeSinceStartup;

                RecordList.Clear();
                RecordCollectionList.Clear();
            }
            ExportMD5();
            ClearPreGenerate();
        }
    }

    public class LuaFileExtraInfo
    {
        public string sub;
        public string replace;
    }

    public void ImportMD5()
    {
        StreamReader sReader = new StreamReader(MD5Path, Encoding.UTF8);
        string line_content = null;
        FileMD5List.Clear();

        if(ClearMD5 == true)
        {
            if (File.Exists(MD5Path))
            {
                sReader.Close();
                FileStream fs = new FileStream(MD5Path, FileMode.Truncate, FileAccess.ReadWrite);
                fs.Close();
            }
        }
        else
        {
            while ((line_content = sReader.ReadLine()) != null)
            {
                string[] pair = line_content.Split('|');
                string path = pair[0];
                string md5 = pair[1];
                FileMD5List.Add(path, md5);
            }
            sReader.Close();
        }
    }

    public void ExportMD5()
    {
        if (File.Exists(MD5Path))
        {
            FileStream fs = new FileStream(MD5Path, FileMode.Truncate, FileAccess.ReadWrite);
            fs.Close();
        }

        FileStream stream = File.Open(MD5Path, FileMode.Create);
        StringBuilder content = new StringBuilder();
        foreach(var pair in FileMD5List)
        {
            content.Append(pair.Key + "|" + pair.Value + "\r\n");
        }
        byte[] data = System.Text.Encoding.UTF8.GetBytes(content.ToString());
        stream.Write(data, 0, data.Length);
        stream.Flush();
        stream.Close();
    }
    

    public static string GetFileMD5(FileStream fs)
    {
        int bufferSize = 1048576;
        byte[] buff = new byte[bufferSize];
        MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
        md5.Initialize();
        long offset = 0;
        while (offset < fs.Length)
        {
            long readSize = bufferSize;
            if (offset + readSize > fs.Length)
                readSize = fs.Length - offset;
            fs.Read(buff, 0, Convert.ToInt32(readSize));
            if (offset + readSize < fs.Length)
                md5.TransformBlock(buff, 0, Convert.ToInt32(readSize), buff, 0);
            else
                md5.TransformFinalBlock(buff, 0, Convert.ToInt32(readSize));
            offset += bufferSize;
        }
        if (offset >= fs.Length)
        {
            byte[] result = md5.Hash;
            md5.Clear();
            StringBuilder sb = new StringBuilder(32);
            for (int i = 0; i < result.Length; i++)
                sb.Append(result[i].ToString("X2"));
            return sb.ToString();
        }
        else
        {
            return null;
        }
    }

    private string CryptTE(int v)
    {
        if (IsExportingServer == true)
        {
            return Convert.ToString(v);
        }

        return string.Format("Crypt.TE({0})", v);
    }


#endif
}
