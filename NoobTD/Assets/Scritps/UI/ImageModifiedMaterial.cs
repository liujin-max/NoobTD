using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


namespace NoobTD
{
    public class ImageModifiedMaterial : Image
    {
        public override Material GetModifiedMaterial(Material baseMaterial)
        {
            Material cModifiedMat = base.GetModifiedMaterial(baseMaterial);
            return cModifiedMat;

        }
    }
}