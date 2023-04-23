using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class TextureUtil : AssetPostprocessor
{

    private void OnPreprocessTexture()
    {
        TextureImporter importer = (TextureImporter)assetImporter;
        importer.textureType = TextureImporterType.Sprite;
    }
}
