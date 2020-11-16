using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.ARFoundation;
using UnityEngine.XR.ARSubsystems;

public class PlacementIndicator : MonoBehaviour
{

    private ARRaycastManager rayManager;
    private GameObject indicator;
    public ObjectSpawner spawner;
    private bool spawned = false;
    private GameObject model;

     void Start()
    {
        // get the component
        rayManager = FindObjectOfType<ARRaycastManager>();
        indicator = transform.GetChild(0).gameObject;

        // hide the placement visual
        indicator.SetActive(false);
    }

     void Update()
    {
        List<ARRaycastHit> hits = new List<ARRaycastHit>();
        rayManager.Raycast(new Vector2(Screen.width / 2, Screen.height / 2), hits, TrackableType.Planes);

        // if we hit AR Plane, Update the postion and rotation
        if (hits.Count > 0) {
            transform.position = hits[0].pose.position;
            transform.rotation = hits[0].pose.rotation;

            if (!indicator.activeInHierarchy && !spawned)
                indicator.SetActive(true);

            if (Input.touchCount > 0) {
                if (!spawned) {
                    spawned = true;
                    indicator.SetActive(false);
                    model = spawner.Activate();
                }
                else {
                    model.transform.position = this.gameObject.transform.position;
                }
            }
        }
    }

}
