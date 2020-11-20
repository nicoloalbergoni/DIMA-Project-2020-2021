using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class ObjectSpawner : MonoBehaviour {
    private GameObject objectToSpawn;

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

    public GameObject Activate () {
        GameObject obj = Instantiate(objectToSpawn,
                placementIndicator.transform.position, placementIndicator.transform.rotation);

        return obj;
    }

    public void SetupObject(string bundlePath) {
        Debug.Log ("bundlePath:" + bundlePath);
        AssetBundle assetBundle = AssetBundle.LoadFromFile(bundlePath);
        Debug.Log ("bundle loaded correctly:" + (assetBundle != null));
        objectToSpawn = assetBundle.LoadAsset<GameObject>("Capsule");
        Debug.Log ("object loaded correctly:" + (objectToSpawn != null));
    }

}
