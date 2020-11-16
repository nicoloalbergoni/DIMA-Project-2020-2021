using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Move : MonoBehaviour
{
    public void setObjPosition(string val) {
        float value = float.Parse(val);
        this.gameObject.transform.position = new Vector3(value, value, value);
    }
}
