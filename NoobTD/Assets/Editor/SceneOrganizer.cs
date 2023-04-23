using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using UnityEditor;
using UnityEngine;

/// <summary>
///  特效整理器
///  1. prefab下, 扫描所有的特效, 找到其对应的依赖文件;
///  2. 将其对应的依赖文件进行标记, 显示出一份SnapShot;
///  3. 这份SnapShot会显示:
///     1) 每个特效依赖于哪些资源;
///     2) 记录下这些被依赖的资源;
/// </summary>
public class SceneOrganizer
{
    //-----------------------------------------------------------------------------------
    //这两者可以相互查找
    public class ObjectRef
    {
        public string ResPath = null;                       //资源路径
        public List<string> Refs = new List<string>();      //所有引用该资源的prefab的路径
    }

    public class ObjectPrefab
    {
        public string ResPath = null;
        public List<string> Deps = new List<string>();      //其依赖的资源路径
    }
    //-------------------------------------------------------------------------------------

    public static string PrefabRootPath      = "/Prefabs/UI";
    
    public Dictionary<string, ObjectPrefab>   _DependentList          = new Dictionary<string, ObjectPrefab>();
    public Dictionary<string, ObjectRef>      _ReverseDepenentList    = new Dictionary<string, ObjectRef>();
    public List<string>                         _PrefabList             = new List<string>();

    public string _Selected_Prefab_Path = null;
    public string _Selected_Dependent_Path = null;
    public string _Selected_Dependent_Detail_Path = null;

    public bool IsContainDependencies(string asset_path, string dependent_path)
    {
        string[] dependencies = AssetDatabase.GetDependencies(asset_path);
        return dependencies.Contains<string>(dependent_path);
    }

    public string TransferToRef(string abusolute)
    {
        return abusolute.Replace(Application.dataPath, "Assets");
    }

    public void GetAllPrefabs(string directory, List<string> prefabPaths)
    {
        //if (string.IsNullOrEmpty(directory) || !directory.StartsWith("Assets"))
        //    throw new ArgumentException("folderPath");

        string[] subFolders = Directory.GetDirectories(directory);
        string[] guids = null;
        string[] assetPaths = null;

        string trim_folder = TransferToRef(directory);
        guids = AssetDatabase.FindAssets("t:Prefab", new string[] { trim_folder });
        assetPaths = new string[guids.Length];

        int i = 0, iMax = 0;
        for (i = 0, iMax = assetPaths.Length; i < iMax; ++i)
        {
            assetPaths[i] = AssetDatabase.GUIDToAssetPath(guids[i]);
            prefabPaths.Add(assetPaths[i]);
        }

        //foreach (var folder in subFolders)
        //{
        //    GetAllPrefabs(folder, prefabPaths);
        //}
    }

    //根据prefabPaths, 来生成[ParticleRef]和[ParticlePrefab]
    public void GenerateSnapShot()
    {
        _DependentList.Clear();
        _ReverseDepenentList.Clear();
        foreach (var prefab_asset_path in _PrefabList)
        {
            //找到其所有的依赖
            string[] dependencies = AssetDatabase.GetDependencies(prefab_asset_path);
            ObjectPrefab snap = new ObjectPrefab();
            snap.ResPath = prefab_asset_path;
            foreach(string d in dependencies)
            {
                if(d.EndsWith(".dll") || d.EndsWith(".cs") || d.EndsWith(".txt") || d.EndsWith(".sdf") || d.EndsWith(".asset") || d.EndsWith(".json") || d.EndsWith(".wav") || d.EndsWith(".mp3") || prefab_asset_path.Equals(d) == true)
                {

                }
                else
                {
                    snap.Deps.Add(d);
                    if (_ReverseDepenentList.ContainsKey(d) == false)
                    {
                        ObjectRef rev_snap = new ObjectRef();
                        rev_snap.ResPath = d;
                        _ReverseDepenentList.Add(d, rev_snap);
                    }

                    _ReverseDepenentList[d].Refs.Add(prefab_asset_path);
                }
            }
            Debug.Log("_DependentList " + prefab_asset_path);
            _DependentList.Add(prefab_asset_path, snap);
        }
    }
}
