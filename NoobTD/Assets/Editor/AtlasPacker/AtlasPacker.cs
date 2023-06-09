﻿using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using UnityEngine;

public static class AtlasPacker
{
#if UNITY_EDITOR_OSX
    private static readonly string _texturePackerExePath = @"/Applications/TexturePacker.app/Contents/MacOS/TexturePacker";
#else
    private static readonly string _texturePackerExePath = @"D:\CodeAndWeb\TexturePacker\bin\TexturePacker.exe";
#endif
    /// <summary>
    /// 添加命令行
    /// </summary>
    /// <param name="sb"></param>
    /// <param name="command"></param>
    private static void AddSubCommand(StringBuilder sb, string command)
    {
        sb.Append(" ");
        sb.Append(command);
    }

    /// <summary>
    /// 打图集的所需的命令行
    /// </summary>
    /// <param name="sheetPath">图集的输出路径，带图集名</param>
    /// <param name="folderPath">图片所在文件夹的路径</param>
    /// <returns></returns>
    ///

//    StringBuilder sb = new StringBuilder();
//    AddSubCommand(sb, "--sheet " + sheetPath + ".png");
//    AddSubCommand(sb, "--data " + sheetPath + ".tpsheet");
//    AddSubCommand(sb, "--format unity-texture2d");
//        if(polygonTrimMode == true)
//        {
//            AddSubCommand(sb, "--trim-mode Polygon");
//}
//        else
//{
//    AddSubCommand(sb, "--trim-mode None");
//}
//AddSubCommand(sb, "--algorithm Basic");
//AddSubCommand(sb, "--max-size 2048");
//AddSubCommand(sb, "--size-constraints POT");
//AddSubCommand(sb, folderPath);

private static string GetCommand(string folderPath, string sheetPath, bool polygonTrimMode)
    {
        StringBuilder sb = new StringBuilder();
        AddSubCommand(sb, "--sheet " + sheetPath + ".png");
        AddSubCommand(sb, "--data " + sheetPath + ".tpsheet");
        AddSubCommand(sb, "--format unity-texture2d");
        if(polygonTrimMode == true)
        {
            AddSubCommand(sb, "--trim-mode Polygon");
        }
        else
        {
            AddSubCommand(sb, "--trim-mode None");
        }
        AddSubCommand(sb, "--algorithm Basic");
        AddSubCommand(sb, "--max-size 2048");
        AddSubCommand(sb, "--size-constraints POT");
        AddSubCommand(sb, folderPath);
        return sb.ToString();
    }

    /// <summary>
    /// 返回一个执行TexturePacker.exe的带有打图集命令的进程
    /// </summary>
    /// <param name="exePath"></param>
    /// <param name="command"></param>
    /// <returns></returns>
    private static ProcessStartInfo GetStartInfo(string exePath, string command)
    {
        ProcessStartInfo info = new ProcessStartInfo(exePath);
        info.Arguments = command;
        info.ErrorDialog = true;
        info.UseShellExecute = false;
        info.RedirectStandardOutput = true;
        info.RedirectStandardError = true;
        return info;
    }

    /// <summary>
    /// 执行打图集的进程
    /// </summary>
    /// <param name="info"></param>
    private static void ExcuteProcess(ProcessStartInfo info)
    {
        Process process = Process.Start(info);

        UnityEngine.Debug.Log(process.StandardOutput.ReadToEnd());

        string error = process.StandardError.ReadToEnd();
        if (!string.IsNullOrEmpty(error))
        {
            UnityEngine.Debug.LogError(error);
        }

        process.Close();
    }

    public static void GenerateAtlas(string folderPath, string sheetPath, bool ploygonTrim)
    {
        ProcessStartInfo info;
        info = GetStartInfo(_texturePackerExePath, GetCommand(folderPath, sheetPath, ploygonTrim));
        ExcuteProcess(info);
    }
}
