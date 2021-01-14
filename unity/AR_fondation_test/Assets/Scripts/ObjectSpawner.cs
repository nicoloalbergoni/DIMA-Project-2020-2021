using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;

public class ObjectSpawner : MonoBehaviour {
    private GameObject objectToSpawn;
    private GameObject instantiatedObject = null;
    private Color defaultColor;
    private Color actualColor;
    // TODO: delete after debugging
    public GameObject test;

    private PlacementIndicator placementIndicator;


    void Start () {
        placementIndicator = FindObjectOfType<PlacementIndicator>();


        /*AssetBundle assetBundle = AssetBundle.LoadFromFile(Path.Combine("D:/Workspace/Flutter_projects/dima_test/unity/AR_fondation_test/Assets", "AssetBundles", "Android", "capsule"));
        objectToSpawn = assetBundle.LoadAsset<GameObject>("Capsule");

        GameObject obj = Instantiate(objectToSpawn);*/
    }

    /*  void Update()
      {
          if (Input.touchCount > 0 && Input.touches[0].phase == TouchPhase.Began)
          {
              GameObject obj = Instantiate(objectToSpawn, 
                  placementIndicator.transform.position, placementIndicator.transform.rotation);

          }

      } */

    public GameObject Activate() {
        instantiatedObject = Instantiate(objectToSpawn, placementIndicator.transform.position, placementIndicator.transform.rotation);
        // move actual object instead of instantiating it again?

        return instantiatedObject;
    }

    public void ChangeColor(string colorEncoding) {
        float[] colorValues = colorEncoding.Split(',').Select(val => int.Parse(val) / 255.0f).ToArray();
        Renderer[] objRenderers = instantiatedObject.GetComponentsInChildren<Renderer>();

        actualColor = new Color (colorValues[0], colorValues[1], colorValues[2]);
        foreach (Renderer objRenderer in objRenderers) {
            objRenderer.material.SetColor("_Color", actualColor);
        }

        // Testing code, delete after debugging
        /*Renderer[] objRenderers = test.GetComponentsInChildren<Renderer> ();

        foreach (Renderer objRenderer in objRenderers) {
            objRenderer.material.SetColor("_Color", Color.red);
        }
        actualColor = Color.red;*/
    }

    public void SetupObject(string bundlePath) {
        Debug.Log ("bundlePath:" + bundlePath);
        AssetBundle assetBundle = AssetBundle.LoadFromFile(bundlePath);
        Debug.Log ("bundle loaded correctly:" + (assetBundle != null));

        string prefabName = bundlePath.Split ('/').Last ();
        Debug.Log ("try to load prefab named " + prefabName);
        objectToSpawn = assetBundle.LoadAsset<GameObject>(prefabName);
        Debug.Log ("object loaded correctly:" + (objectToSpawn != null));
    }

}
