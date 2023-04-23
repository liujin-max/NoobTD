using NoobTD;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class InputEvent : MonoBehaviour
{

    private TMP_InputField inputField;
    // Start is called before the first frame update
    void Start()
    {
        inputField = transform.GetComponent<TMP_InputField>();
        inputField.onEndEdit.AddListener(OnEditorEnd);
    }

    public void OnEditorEnd(string str)
    {
        EventManager.instance.SendEvent("INPUTFIELD_ENDEDIT", null, inputField);
    }
}
