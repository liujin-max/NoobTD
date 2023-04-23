using UnityEngine;
using UnityEngine.EventSystems;
using LuaInterface;
using UnityEngine.UI;
using System.Collections.Generic;

namespace NoobTD
{
    public class UIEventListener : MonoBehaviour, IPointerEnterHandler, IPointerExitHandler, IPointerDownHandler, IPointerUpHandler, IPointerClickHandler, IDragHandler, ICanvasRaycastFilter, IBeginDragHandler, IEndDragHandler
    {
        public bool PassThrough = false;
        public static bool EnableInteration = true;

        public delegate void VoidDelegate(GameObject go);
        public delegate void ParamedDelegate(object parameter, GameObject go);
        public delegate void PointerDelegate(GameObject go, PointerEventData eventData);
        public delegate void ParamedPointerDelegate(object parameter, GameObject go, PointerEventData eventData);
        public ParamedDelegate onClick_P;
        public VoidDelegate onClick;
        public VoidDelegate onDown;
        public ParamedPointerDelegate onDown_P;
        public VoidDelegate onEnter;
        public ParamedDelegate onEnter_P;
        public VoidDelegate onExit;
        public ParamedDelegate onExit_P;
        public VoidDelegate onUp;
        public ParamedPointerDelegate onUp_P;
        public VoidDelegate onSelect;
        public VoidDelegate onUpdateSelect;
        public ParamedDelegate onLongPress_P;
        public VoidDelegate onLongPress;

        public PointerDelegate onDrag;
        public ParamedPointerDelegate onDrag_P;

        public PointerDelegate onDragBegin;
        public ParamedPointerDelegate onDragBegin_P;

        public PointerDelegate onDragEnd;
        public ParamedPointerDelegate onDragEnd_P;

        public object parameter;
        public object delegateObject;

        public void Awake()
        {
            Image img = this.GetComponent<Image>();
            if (img != null)
            {
                img.raycastTarget = true;
            }
        }

        public bool IsRaycastLocationValid(Vector2 screenPoint, Camera eventCamera)
        {
            return !PassThrough;
        }


        //public void PassEvent<T>(PointerEventData data, ExecuteEvents.EventFunction<T> function) where T : IEventSystemHandler
        //{
        //    List<RaycastResult> results = new List<RaycastResult>();
        //    EventSystem.current.RaycastAll(data, results);
        //    GameObject current = data.pointerCurrentRaycast.gameObject;
        //    for (int i = 0; i < results.Count; i++)
        //    {
        //        if (current != results[i].gameObject)
        //        {
        //            ExecuteEvents.Execute(results[i].gameObject, data, function);
        //        }
        //    }
        //}

        static public void SetPassThrough(GameObject go, bool flag)
        {
            UIEventListener listener = go.GetComponent<UIEventListener>();
            if (listener != null)
            {
                listener.PassThrough = flag;
            }
        }

        static public void ClearListener(GameObject go)
        {
            UIEventListener listener = go.GetComponent<UIEventListener>();
            if (listener != null)
            {
                Destroy(listener);
            }
        }


        static public UIEventListener Get(GameObject go)
        {
            UIEventListener listener = go.GetComponent<UIEventListener>();
            if (listener == null) listener = go.AddComponent<UIEventListener>();
            return listener;
        }

        static public UIEventListener PGet(GameObject go, object delegateObject)
        {
            UIEventListener listener = go.GetComponent<UIEventListener>();
            if (listener == null) listener = go.AddComponent<UIEventListener>();
            listener.delegateObject = delegateObject;
            return listener;
        }

        public void OnLongPressed()
        {
            if (EnableInteration == false) return;

            if (onLongPress != null) onLongPress(gameObject);
            else if (onLongPress_P != null) onLongPress_P(delegateObject, gameObject);
        }

        public void OnPointerClick(PointerEventData eventData)
        {
            if (EnableInteration == false) return;

            GameFacade.Instance.AssetManager.LoadSync("Prefab/Audio/sound_click");

            if (onClick != null) onClick(gameObject);
            else if (onClick_P != null) onClick_P(delegateObject, gameObject);

            if (PassThrough)
            {
                //PassEvent(eventData, ExecuteEvents.submitHandler);
                //PassEvent(eventData, ExecuteEvents.pointerClickHandler);
            }
        }

        public void OnPointerDown(PointerEventData eventData)
        {
            if (EnableInteration == false) return;

            if (onDown != null) onDown(gameObject);
            else if (onDown_P != null) onDown_P(delegateObject, gameObject, eventData);

            if (PassThrough)
            {
                //PassEvent(eventData, ExecuteEvents.pointerDownHandler);
            }
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
            else if (onUp_P != null) onUp_P(delegateObject, gameObject, eventData);

            if (PassThrough)
            {
                //PassEvent(eventData, ExecuteEvents.pointerUpHandler);
            }
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

        public void OnDrag(PointerEventData eventData)
        {
            if (EnableInteration == false) return;

            if (onDrag != null) onDrag(gameObject, eventData);
            else if (onDrag_P != null) onDrag_P(delegateObject, gameObject, eventData);
        }

        void OnDestroy()
        {
            onClick_P   = null;
            onClick     = null; 
            onDown      = null;
            onDown_P    = null;
            onEnter     = null;
            onEnter_P   = null;
            onExit      = null;
            onExit_P    = null;
            onUp        = null;
            onUp_P      = null;
            onSelect    = null;
            onUpdateSelect  = null;
            onLongPress_P   = null;
            onLongPress     = null;
            onDrag          = null;
            onDrag_P        = null;
            if (parameter != null)
            {
                if (parameter is LuaInterface.LuaTable)
                {
                    ((LuaInterface.LuaTable)parameter).Dispose();
                }
                else
                {
                    Debug.Log("怎么可能还是别的呢！！");
                }
                parameter = null;
            }

            if (delegateObject != null)
            {
                if (delegateObject is LuaInterface.LuaTable)
                {
                    ((LuaInterface.LuaTable)delegateObject).Dispose();
                }
                else
                {
                    Debug.Log("怎么可能还是别的呢！！");
                }
                delegateObject = null;
            }
        }

        public void OnBeginDrag(PointerEventData eventData)
        {
            if (EnableInteration == false) return;

            if (onDragBegin != null) onDragBegin(gameObject, eventData);
            else if (onDragBegin_P != null) onDragBegin_P(delegateObject, gameObject, eventData);
        }

        public void OnEndDrag(PointerEventData eventData)
        {
            if (EnableInteration == false) return;

            if (onDragEnd != null) onDragEnd(gameObject, eventData);
            else if (onDragEnd_P != null) onDragEnd_P(delegateObject, gameObject, eventData);
        }
    }
}