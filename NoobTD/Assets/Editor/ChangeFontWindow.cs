
using UnityEngine;
using UnityEngine.UI;
using UnityEditor;

/// <summary>
/// �����޸�UI����ű����ű�λ��Endit�ļ���
/// </summary>
public class ChangeFontWindow : EditorWindow
{

    //Ĭ������
    Font toFont;
    //�л���������
    static Font toChangeFont;
    //��������
    FontStyle toFontStyle;
    //�л�������������
    static FontStyle toChangeFontStyle;

    private void OnEnable()
    {
        //
        toFont = new Font("Arial");
    }

    //window�˵���
    [MenuItem("Window/Change Font")]
    private static void ShowWindow()
    {
        ChangeFontWindow cw = EditorWindow.GetWindow<ChangeFontWindow>(true, "Window/Change Font");
    }



    private void OnGUI()
    {
        GUILayout.Space(10);
        GUILayout.Label("Ŀ������:");
        toFont = (Font)EditorGUILayout.ObjectField(toFont, typeof(Font), true, GUILayout.MinWidth(100f));
        toChangeFont = toFont;
        GUILayout.Space(10);
        GUILayout.Label("��������:");
        toFontStyle = (FontStyle)EditorGUILayout.EnumPopup(toFontStyle, GUILayout.MinWidth(100f));
        toChangeFontStyle = toFontStyle;
        if (GUILayout.Button("ȷ���޸�"))
        {
            Change();
        }
    }

    public static void Change()
    {
        //��ȡ����UILabel���
        if (Selection.objects == null || Selection.objects.Length == 0) return;
        Object[] labels = Selection.GetFiltered(typeof(Text), SelectionMode.Deep);
        foreach (Object item in labels)
        {
            Text label = (Text)item;
            label.font = toChangeFont;
            label.fontStyle = toChangeFontStyle;
            //  �����NGUI��Text����UILabel�Ϳ���
            //  UILabel label = (UILabel)item;
            //  label.trueTypeFont = toChangeFont;

            EditorUtility.SetDirty(item); //��Ҫ
        }
    }
}