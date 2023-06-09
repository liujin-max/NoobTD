
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;

/// <summary>
/// 批量修改UI字体脚本，脚本位于Endit文件夹
/// </summary>
public class ChangeFontWindow : EditorWindow
{

    //默认字体
    Font toFont;
    //切换到的字体
    static Font toChangeFont;
    //字体类型
    FontStyle toFontStyle;
    //切换到的字体类型
    static FontStyle toChangeFontStyle;

    private void OnEnable()
    {
        //
        toFont = new Font("Arial");
    }

    //window菜单下
    [MenuItem("Window/Change Font")]
    private static void ShowWindow()
    {
        ChangeFontWindow cw = EditorWindow.GetWindow<ChangeFontWindow>(true, "Window/Change Font");
    }



    private void OnGUI()
    {
        GUILayout.Space(10);
        GUILayout.Label("目标字体:");
        toFont = (Font)EditorGUILayout.ObjectField(toFont, typeof(Font), true, GUILayout.MinWidth(100f));
        toChangeFont = toFont;
        GUILayout.Space(10);
        GUILayout.Label("字体类型:");
        toFontStyle = (FontStyle)EditorGUILayout.EnumPopup(toFontStyle, GUILayout.MinWidth(100f));
        toChangeFontStyle = toFontStyle;
        if (GUILayout.Button("确认修改"))
        {
            Change();
        }
    }

    public static void Change()
    {
        //获取所有UILabel组件
        if (Selection.objects == null || Selection.objects.Length == 0) return;
        Object[] labels = Selection.GetFiltered(typeof(Text), SelectionMode.Deep);
        foreach (Object item in labels)
        {
            Text label = (Text)item;
            label.font = toChangeFont;
            label.fontStyle = toChangeFontStyle;
            //  如果是NGUI将Text换成UILabel就可以
            //  UILabel label = (UILabel)item;
            //  label.trueTypeFont = toChangeFont;

            EditorUtility.SetDirty(item); //重要
        }
    }
}