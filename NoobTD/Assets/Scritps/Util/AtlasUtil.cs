using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEditor.U2D;
using UnityEngine;
using UnityEngine.U2D;

namespace NoobTD
{
    public class AtlasUtil
    {
        static SpriteAtlasPackingSettings packSetting = new SpriteAtlasPackingSettings()
        {
            blockOffset = 1,
            padding = 2,
            enableRotation = false,
            enableTightPacking = false
        };

        private static SpriteAtlasTextureSettings textureSetting = new SpriteAtlasTextureSettings()
        {
            sRGB = true,
            filterMode = FilterMode.Bilinear,
        };

        private static TextureImporterPlatformSettings importerSetting = new TextureImporterPlatformSettings()
        {
            maxTextureSize = 2048,
            compressionQuality = 50,
        };

        [MenuItem("Assets/创建图集", false, 19)]
        static void CreateAtlas()
        {
            var select = Selection.activeObject;
            var path = AssetDatabase.GetAssetPath(select);
            CreateAtlasOfAssetDir(path);
        }

        public static void CreateAtlasOfAssetDir(string dirAssetPath)
        {
            if (string.IsNullOrEmpty(dirAssetPath) || Path.HasExtension(dirAssetPath))
            {
                Debug.LogError("当前选中对象不是文件夹，请选择对应文件夹重新创建图集");
                return;
            }

            SpriteAtlas atlas = new SpriteAtlas();
            atlas.SetPackingSettings(packSetting);
            atlas.SetTextureSettings(textureSetting);
            atlas.SetPlatformSettings(importerSetting);

            var atlasPath = $"{dirAssetPath}/New Atlas.spriteatlas";
            TryAddSprites(atlas, dirAssetPath);
            AssetDatabase.CreateAsset(atlas, atlasPath);
            AssetDatabase.SaveAssets();
            Selection.activeObject = AssetDatabase.LoadAssetAtPath<Object>(atlasPath);
        }

        static void TryAddSprites(SpriteAtlas atlas, string dirPath)
        {
            string[] files = Directory.GetFiles(dirPath);
            if (files == null || files.Length == 0) return;

            Sprite sprite;
            List<Sprite> spriteList = new List<Sprite>();
            foreach (var file in files)
            {
                if (file.EndsWith(".meta")) continue;
                sprite = AssetDatabase.LoadAssetAtPath<Sprite>(file);
                if (sprite == null) continue;
                spriteList.Add(sprite);
            }

            if (spriteList.Count > 0) atlas.Add(spriteList.ToArray());
        }
    }
}

