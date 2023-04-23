using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class EditorUtil : EditorWindow
{
    public static string TransferToRef(string abusolute)
    {
        return abusolute.Replace(Application.dataPath, "Assets");
    }

    public static string TransferToAbusolate(string relavant)
    {
        return relavant.Replace("Assets", Application.dataPath);
    }

    private static void DOPackIconInSecs(string abusolute_folder_path, string folder_path)
    {
        var sec_directories = System.IO.Directory.GetDirectories(abusolute_folder_path);
        var prefix_sec = abusolute_folder_path.Split('/', '\\');
        var prefix = prefix_sec[prefix_sec.Length - 1] + "_Icon";
        string container_folder = "Assets/UI_Dynamic/" + prefix;

        for (int i = 0; i < sec_directories.Length; i++)
        {
            string sec_dir = sec_directories[i];
            string[] sections = sec_dir.Split('/', '\\');
            string sec = sections[sections.Length - 1] + "_Icon";
            string to_path = EditorUtil.TransferToAbusolate(container_folder + "/" + sec);

            AtlasPacker.GenerateAtlas(sec_dir, to_path, false);
        }

        List<string> texture_paths = new List<string>();
        var guids = AssetDatabase.FindAssets("t:Texture", new string[] { container_folder });   //图片
        foreach (string guid in guids)
        {
            var relative_path = AssetDatabase.GUIDToAssetPath(guid);    //当前的相对路径
            TextureImporter textureImporter = AssetImporter.GetAtPath(relative_path) as TextureImporter;

            var platFormat = textureImporter.GetPlatformTextureSettings("Android");
            platFormat.overridden = true;
            platFormat.format = TextureImporterFormat.ETC2_RGBA8;
            textureImporter.SetPlatformTextureSettings(platFormat);
            AssetDatabase.ImportAsset(relative_path);
            texture_paths.Add(relative_path);

            //
            var platFormat_iphone = textureImporter.GetPlatformTextureSettings("iphone");
            platFormat_iphone.overridden = true;
            platFormat_iphone.format = TextureImporterFormat.ASTC_5x5;
            textureImporter.SetPlatformTextureSettings(platFormat_iphone);

            AssetDatabase.Refresh();
        }

        //生成对应的Prefab
        GameObject go = new GameObject(prefix);
        NoobTD.UIDynamic d = go.AddComponent<NoobTD.UIDynamic>();
        string prefab_path = "Assets/Prefab/Icon/" + prefix + ".prefab";  //"Assets/Prefab/Icon/" + prefix + ".prefab";
        d.Tag = prefix;

        List<Texture2D> atlases = new List<Texture2D>();
        List<Sprite> spr_list = new List<Sprite>();
        for (int i = 0; i < texture_paths.Count; i++)
        {
            var relative_path = texture_paths[i];
            var atlas_tex = AssetDatabase.LoadAssetAtPath<Texture2D>(relative_path);
            atlases.Add(atlas_tex);
            UnityEngine.Object[] objs = AssetDatabase.LoadAllAssetsAtPath(relative_path);
            foreach (var obj in objs)
            {
                if (obj.GetType() == typeof(Sprite))
                {
                    spr_list.Add((Sprite)obj);
                }
            }
        }
        d.Atlas = atlases.ToArray();
        d.Sprites = spr_list.ToArray();
        PrefabUtility.CreatePrefab(prefab_path, go);
        DestroyImmediate(go);
    }

    [MenuItem("Assets/PackIconInSecs")]
    public static void PackIconInSecs()
    {
        UnityEngine.Object[] arr = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.TopLevel);
        if (arr.Length != 1)
        {
            Debug.LogError("打包图集失败! 只能选择一个对象进行打包");
            return;
        }

        var folder_obj = arr[0];
        var folder_path = AssetDatabase.GetAssetPath(folder_obj);
        var abusolute_folder_path = EditorUtil.TransferToAbusolate(folder_path);
        if (System.IO.Directory.Exists(abusolute_folder_path) == false)
        {
            Debug.LogError("打包图集失败! 改对象必须是文件夹");
            return;
        }

        DOPackIconInSecs(abusolute_folder_path, folder_path);

        AssetDatabase.Refresh();
        EditorUtility.DisplayDialog("打包完成", "打包完成 " + abusolute_folder_path, "OK");
    }


    [MenuItem("Assets/PackIcon")]
    public static void PackIcon()
    {
        UnityEngine.Object[] arr = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.TopLevel);
        if (arr.Length != 1)
        {
            Debug.LogError("打包图集失败! 只能选择一个对象进行打包");
            return;
        }

        var folder_obj = arr[0];
        var folder_path = AssetDatabase.GetAssetPath(folder_obj);
        var abusolute_folder_path = EditorUtil.TransferToAbusolate(folder_path);
        if (System.IO.Directory.Exists(abusolute_folder_path) == false)
        {
            Debug.LogError("打包图集失败! 改对象必须是文件夹");
            return;
        }

        string[] sections = abusolute_folder_path.Split('/');
        string sec = sections[sections.Length - 1] + "_Icon";
        string container_folder = "Assets/UI_Dynamic/" + sec;
        string to_path = EditorUtil.TransferToAbusolate(container_folder + "/" + sec);

        AtlasPacker.GenerateAtlas(folder_path, to_path, false);

        var guids = AssetDatabase.FindAssets("t:Texture", new string[] { container_folder });   //图片
        foreach (string guid in guids)
        {
            var relative_path = AssetDatabase.GUIDToAssetPath(guid);    //当前的相对路径
            TextureImporter textureImporter = AssetImporter.GetAtPath(relative_path) as TextureImporter;

            var platFormat = textureImporter.GetPlatformTextureSettings("Android");
            platFormat.overridden = true;
            platFormat.format = TextureImporterFormat.ETC2_RGBA8;
            textureImporter.SetPlatformTextureSettings(platFormat);

            //
            var platFormat_iphone = textureImporter.GetPlatformTextureSettings("iphone");
            platFormat_iphone.overridden = true;
            platFormat_iphone.format = TextureImporterFormat.ASTC_5x5;
            textureImporter.SetPlatformTextureSettings(platFormat_iphone);


            AssetDatabase.ImportAsset(relative_path);

            AssetDatabase.Refresh();

            //生成对应的Prefab
            GameObject go = new GameObject(sec);
            NoobTD.UIDynamic d = go.AddComponent<NoobTD.UIDynamic>();
            string prefab_path = "Assets/Prefab/Icon/" + sec + ".prefab";
            d.Tag = sec;
            d.Atlas = new Texture2D[] { AssetDatabase.LoadAssetAtPath<Texture2D>(relative_path) };  //AssetDatabase.LoadAssetAtPath<Texture2D>(relative_path);
            UnityEngine.Object[] objs = AssetDatabase.LoadAllAssetsAtPath(relative_path);
            List<Sprite> spr_list = new List<Sprite>();
            foreach (var obj in objs)
            {
                if (obj.GetType() == typeof(Sprite))
                {
                    spr_list.Add((Sprite)obj);
                }
            }
            d.Sprites = spr_list.ToArray();
            PrefabUtility.CreatePrefab(prefab_path, go);
        }
        AssetDatabase.Refresh();
        EditorUtility.DisplayDialog("打包完成", "打包完成 " + to_path, "OK");
    }

    [MenuItem("Assets/PackOne")]
    public static void PackOne()
    {
        UnityEngine.Object[] arr = Selection.GetFiltered(typeof(UnityEngine.Object), SelectionMode.TopLevel);
        if (arr.Length != 1)
        {
            Debug.LogError("打包图集失败! 只能选择一个对象进行打包");
            return;
        }

        var folder_obj = arr[0];
        var folder_path = AssetDatabase.GetAssetPath(folder_obj);
        var abusolute_folder_path = EditorUtil.TransferToAbusolate(folder_path);
        if (System.IO.Directory.Exists(abusolute_folder_path) == false)
        {
            Debug.LogError("打包图集失败! 改对象必须是文件夹");
        }

        string[] sections = abusolute_folder_path.Split('/');
        string container_folder = "Assets/UI_Atlas/" + sections[sections.Length - 1];
        string to_path = EditorUtil.TransferToAbusolate(container_folder + "/" + sections[sections.Length - 1]);

        AtlasPacker.GenerateAtlas(folder_path, to_path, true);

        var guids = AssetDatabase.FindAssets("t:Texture", new string[] { container_folder });   //图片
        foreach (string guid in guids)
        {
            var relative_path = AssetDatabase.GUIDToAssetPath(guid);    //当前的相对路径
            TextureImporter textureImporter = AssetImporter.GetAtPath(relative_path) as TextureImporter;

            var platFormat = textureImporter.GetPlatformTextureSettings("Android");
            platFormat.overridden = true;
            platFormat.format = TextureImporterFormat.ETC2_RGBA8;
            textureImporter.SetPlatformTextureSettings(platFormat);

            var platFormat_iphone = textureImporter.GetPlatformTextureSettings("iphone");
            platFormat_iphone.overridden = true;
            platFormat_iphone.format = TextureImporterFormat.ASTC_5x5;
            textureImporter.SetPlatformTextureSettings(platFormat_iphone);

            AssetDatabase.ImportAsset(relative_path);
        }
        AssetDatabase.Refresh();
        EditorUtility.DisplayDialog("打包完成", "打包完成 " + to_path, "OK");
    }

}
