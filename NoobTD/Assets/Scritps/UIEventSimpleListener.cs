using UnityEngine;
using UnityEngine.EventSystems;
using LuaInterface;
using UnityEngine.UI;




namespace NoobTD
{
    public class UISimpleEventListener : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler, IPointerDownHandler, IPointerUpHandler, IPointerClickHandler
    {
        public static bool EnableInteration = true;

        public delegate void VoidDelegate(GameObject go);
        public delegate void ParamedDelegate(object parameter, GameObject go);
        public delegate void PointerDelegate(GameObject go, PointerEventData eventData);
        public delegate void ParamedPointerDelegate(object parameter, GameObject go, PointerEventData eventData);
        public ParamedDelegate onClick_P;
        public VoidDelegate onClick;
        public VoidDelegate onDown;
        public ParamedDelegate onDown_P;
        public VoidDelegate onEnter;
        public ParamedDelegate onEnter_P;
        public VoidDelegate onExit;
        public ParamedDelegate onExit_P;
        public VoidDelegate onUp;
        public ParamedDelegate onUp_P;
        public ParamedDelegate onLongPress_P;
        public VoidDelegate onLongPress;
        public VoidDelegate onSelect;
        public VoidDelegate onUpdateSelect;

        //public PointerDelegate onDrag;
        //public ParamedPointerDelegate onDrag_P;

        public object parameter;
        public object delegateObject;

        public void Awake()
        {
            Image img = this.GetComponent<Image>();
            if(img != null)
            {
                img.raycastTarget = true;
            }
        }

        static public UISimpleEventListener Get(GameObject go)
        {
            UISimpleEventListener listener = go.GetComponent<UISimpleEventListener>();
            if (listener == null) listener = go.AddComponent<UISimpleEventListener>();
            return listener;
        }

        static public UISimpleEventListener PGet(GameObject go, object delegateObject)
        {
            UISimpleEventListener listener = go.GetComponent<UISimpleEventListener>();
            if (listener == null) listener = go.AddComponent<UISimpleEventListener>();
            listener.delegateObject = delegateObject;
            return listener;
        }

        public void OnPointerClick(PointerEventData eventData)
        {
            if (EnableInteration == false) return;

            GameFacade.Instance.AssetManager.LoadSync("Prefab/Audio/sound_click");

            if (onClick != null) onClick(gameObject);
            else if (onClick_P != null) onClick_P(delegateObject, gameObject);
        }

        public void OnLongPressed()
        {
            if (EnableInteration == false) return;

            if (onLongPress != null) onLongPress(gameObject);
            else if (onLongPress_P != null) onLongPress_P(delegateObject, gameObject);
        }

        public void OnPointerDown(PointerEventData eventData)
        {
            if (EnableInteration == false) return;

            if (onDown != null) onDown(gameObject);
            else if (onDown_P != null) onDown_P(delegateObject, gameObject);
        }
        public void OnPointerEnter(PointerEventData eventData)
        {
            if (EnableInteration == false) return;

            if (onEnter != null) onEnter(gameObject);
            else if (onEnter_P != null) onEnter_P(delegateObject, gameObject);
        }
        public void OnPointerExit(PointerEventData eventData)
        {
            if (EnableInteration == false) return;

            if (onExit != null) onExit(gameObject);
            else if (onExit_P != null) onExit_P(delegateObject, gameObject);
        }
        public void OnPointerUp(PointerEventData eventData)
        {
            if (EnableInteration == false) return;

            if (onUp != null) onUp(gameObject);
            else if (onUp_P != null) onUp_P(delegateObject, gameObject);
        }
        public void OnSelect(BaseEventData eventData)
        {
            if (EnableInteration == false) return;

            if (onSelect != null) onSelect(gameObject);
        }
        public void OnUpdateSelected(BaseEventData eventData)
        {
            if (EnableInteration == false) return;

            if (onUpdateSelect != null) onUpdateSelect(gameObject);
        }

        //public void OnDrag(PointerEventData eventData)
        //{
        //    if (onDrag != null) onDrag(gameObject, eventData);
        //    else if (onDrag_P != null) onDrag_P(delegateObject, gameObject, eventData);
        //}

        void OnDestroy()
        {
            if (parameter != null)
            {
                if(parameter is LuaInterface.LuaTable)
                {
                    ((LuaInterface.LuaTable)parameter).Dispose(true);
                }
                parameter = null;
            }

            if (delegateObject != null)
            {
                if (delegateObject is LuaInterface.LuaTable)
                {
                    ((LuaInterface.LuaTable)delegateObject).Dispose(true);
                }
                delegateObject = null;
            }
        }
    }
}
