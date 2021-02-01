using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;

public class ObjectSpawner : MonoBehaviour {
    // TODO: delete after debugging
    public GameObject test;

    private GameObject objectToSpawn;
    private GameObject instantiatedObject = null;
    private Color defaultColor;
    private PlacementIndicator placementIndicator;
    private Vector3 offsetPos;
    private Quaternion offsetRotation;


    void Start() {
        placementIndicator = FindObjectOfType<PlacementIndicator>();


        /*AssetBundle assetBundle = AssetBundle.LoadFromFile(Path.Combine("D:/Workspace/Flutter_projects/dima_test/unity/AR_fondation_test/Assets", "AssetBundles", "Android", "capsule"));
        objectToSpawn = assetBundle.LoadAsset<GameObject>("Capsule");

        GameObject obj = Instantiate(objectToSpawn);*/
    }

    /// <summary>
    /// This function is called only if the object is not already instantiated, otherwise it is moved by the PlacementIndicator script.
    /// </summary>
    /// <returns>Instantiated GameObject</returns>
    public GameObject Activate() {
        offsetPos = objectToSpawn.transform.position;
        offsetRotation = objectToSpawn.transform.rotation;
        Debug.Log("[Unity] model offset: " + offsetPos.ToString());
        Debug.Log("[Unity] model rotation offset: " + offsetRotation.eulerAngles.ToString());
        instantiatedObject = Instantiate(objectToSpawn, placementIndicator.transform.position + offsetPos, placementIndicator.transform.rotation * offsetRotation);

        Renderer renderer = instantiatedObject.GetComponentInChildren<Renderer>();
        defaultColor = renderer.material.GetColor("_Color");

        UnityMessageManager.Instance.SendMessageToFlutter("model placed");

        return instantiatedObject;
    }

    public Vector3 ComputeOffsetPosition(Vector3 pos) {
        return pos + offsetPos;
    }

    public void ChangeColor(string colorEncoding) {
        Color colorToApply;
        if (instantiatedObject == null) {
            Debug.Log("[Unity] Instantiate the object before switching the color");
            return;
        }

        if (colorEncoding == "default") {
            colorToApply = defaultColor;
        }
        else {
            float[] colorValues = colorEncoding.Split(',').Select(val => int.Parse(val) / 255.0f).ToArray();
            colorToApply = new Color(colorValues[0], colorValues[1], colorValues[2]);
        }

        Renderer[] objRenderers = instantiatedObject.GetComponentsInChildren<Renderer>();
        foreach (Renderer objRenderer in objRenderers) {
            objRenderer.material.SetColor("_Color", colorToApply);
        }


        // Testing code, delete after debugging
        /*Renderer[] objRenderers = test.GetComponentsInChildren<Renderer> ();

        foreach (Renderer objRenderer in objRenderers) {
            objRenderer.material.SetColor("_Color", Color.red);
        }
        actualColor = Color.red;*/
    }

    public void SetupObject(string bundlePath) {
        Debug.Log("[Unity] bundlePath:" + bundlePath);
        AssetBundle assetBundle = AssetBundle.LoadFromFile(bundlePath);
        Debug.Log("[Unity] bundle loaded correctly:" + (assetBundle != null));

        string prefabName = bundlePath.Split('/').Last();
        Debug.Log("[Unity] try to load prefab named " + prefabName);
        objectToSpawn = assetBundle.LoadAsset<GameObject>(prefabName);
        Debug.Log("[Unity] object loaded correctly:" + (objectToSpawn != null));
    }

    public void UnloadAssetBundle(string uselessParam) {
        AssetBundle.UnloadAllAssetBundles(true);
        Debug.Log("[Unity] asset bundles unloaded");
    }

}
