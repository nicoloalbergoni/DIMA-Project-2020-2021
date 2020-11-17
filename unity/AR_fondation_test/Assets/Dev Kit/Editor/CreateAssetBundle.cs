/* Create a folder (right click in the Assets folder and go to Create>Folder), and name it “Editor” if it doesn’t already exist
* Place this script in the Editor folder
*
* This script creates a new Menu named “Build Asset” and new options within the menu named “Normal” and “Strict Mode”.
* Click these menu items to build an AssetBundle into a folder with either no extra build options, or a strict build.
*
* IMPORTANT: make sure you have installed unity platform modules of platforms you are building for, or the build process for that
*            platform will fail!
*/

using UnityEngine;
using UnityEditor;
using System;
using System.IO;
using UnityEditor.SceneManagement;
using UnityEngine.SceneManagement;

public class CreateAssetBundle : MonoBehaviour {
    private const string assetsFolder = "Assets";
    private const string newFolderName = "AssetBundles";
    private static readonly string[] ext = { "iOS", "Android", "WSA", "Standalone" };

    private const string folderPath = assetsFolder + "/" + newFolderName;
    private static readonly string outputPathIOS = assetsFolder + "/" + newFolderName + "/" + ext[0];
    private static readonly string outputPathAndroid = assetsFolder + "/" + newFolderName + "/" + ext[1];
    private static readonly string outputPathWSA = assetsFolder + "/" + newFolderName + "/" + ext[2];
    private static readonly string outputPathStandalone = assetsFolder + "/" + newFolderName + "/" + ext[3];

    /// <summary>
    /// Create folders where assetBundles will be placed.
    /// </summary>
    private static void CreateFolders () {
        if (!AssetDatabase.IsValidFolder (folderPath)) { 
            AssetDatabase.CreateFolder (assetsFolder, newFolderName);
            foreach (string s in ext) {
                AssetDatabase.CreateFolder (folderPath, s);
            }
        }
        //TODO: potrebbe essere che alcune sottocartelle siano presenti e altre no in un progetto generato da un utente (potrebbe cancellarle)
        //ma in uno automatico dovrebbe andare bene.
    }

    /// <summary>
    /// Build asset bundle for all platforms specified
    /// </summary>
    /// <param name="option">Build option</param>
    private static void BuildForAllPlatforms (BuildAssetBundleOptions option) {
        //BuildPipeline.BuildAssetBundles (outputPathIOS, option, BuildTarget.iOS);
        BuildPipeline.BuildAssetBundles (outputPathAndroid, option, BuildTarget.Android);
        //BuildPipeline.BuildAssetBundles (outputPathStandalone, option, BuildTarget.StandaloneWindows);
        //BuildPipeline.BuildAssetBundles (outputPathWSA, option, BuildTarget.WSAPlayer);
    }

    /// <summary>
    /// Build asset bundle for Android
    /// </summary>
    /// <param name="option">Build option</param>
    private static void BuildForAndroid (BuildAssetBundleOptions option) {
        BuildPipeline.BuildAssetBundles (outputPathAndroid, option, BuildTarget.Android);
    }

    /// <summary>
    /// Build asset bundle for Android
    /// </summary>
    /// <param name="option">Build option</param>
    private static void BuildForiOS (BuildAssetBundleOptions option) {
        BuildPipeline.BuildAssetBundles (outputPathIOS, option, BuildTarget.iOS);
    }

    /// <summary>
    /// Build asset bundle for Android
    /// </summary>
    /// <param name="option">Build option</param>
    private static void BuildForHololens (BuildAssetBundleOptions option) {
        BuildPipeline.BuildAssetBundles (outputPathWSA, option, BuildTarget.WSAPlayer);
    }

    //Creates a new menu (Build Asset Bundles) and item (Normal) in the Editor
    [MenuItem("Build Asset Bundles/Normal")]
    static void BuildABsNone() {
        //Create folders to put the Asset Bundle in.
        CreateFolders ();

        // This puts the bundles in your custom folder (this case it's "MyAssetBuilds") within the Assets folder.
        //Build AssetBundles with no special options
        BuildForAllPlatforms (BuildAssetBundleOptions.None);
        Debug.Log ("Assets Built!");
    }

    //Creates a new item (Strict Mode) in the new Build Asset Bundles menu
    [MenuItem("Build Asset Bundles/Strict Mode ")]
    static void BuildABsStrict()
    {
        //Create folders to put the Asset Bundle in.
        CreateFolders ();

        //Build the AssetBundles in strict mode (build fails if any errors are detected)
        BuildForAllPlatforms (BuildAssetBundleOptions.StrictMode);
        Debug.Log("Asset StrictMode Built");
    }

    //Creates a new menu (Build Asset Bundles) and item (Normal) in the Editor
    [MenuItem("Build Asset Bundles/Name+Asset")]
    static void BuildABsNoneName()
    {
        //Create folders to put the Asset Bundle in.
        CreateFolders ();

        // This puts the bundles in your custom folder (this case it's "MyAssetBuilds") within the Assets folder.
        //Build AssetBundles with name of selected object
        string assetName = Selection.activeGameObject.name;
        string variant = "";
        string assetPath = AssetDatabase.GetAssetPath(Selection.activeInstanceID);
        AssetImporter.GetAtPath(assetPath).SetAssetBundleNameAndVariant(assetName, variant);
        BuildForAllPlatforms (BuildAssetBundleOptions.None);
        Debug.Log("Assets+Name Built!");

        AssetDatabase.Refresh ();
    }

    [MenuItem ("Build Asset Bundles/Scene/Scene for all platforms")]
    static void BuildSceneForAllPlatforms () {
        BuildABsScene (BuildForAllPlatforms);
    }

    [MenuItem ("Build Asset Bundles/Scene/Android Scene")]
    static void BuildSceneForAndroid () {
        BuildABsScene (BuildForAndroid);
    }

    [MenuItem ("Build Asset Bundles/Scene/iOS Scene")]
    static void BuildSceneForiOS () {
        BuildABsScene (BuildForiOS);
    }

    [MenuItem ("Build Asset Bundles/Scene/Hololens Scene")]
    static void BuildSceneForHololens () {
        BuildABsScene (BuildForHololens);
    }

    static void BuildABsScene (Action<BuildAssetBundleOptions> action) {
        //Create folders to put the Asset Bundle in.
        CreateFolders ();

        // This puts the bundles in your custom folder (this case it's "MyAssetBuilds") within the Assets folder.
        //Build AssetBundles with name of selected object
        //string assetName = Selection.activeGameObject.name;
        string assetName = Selection.activeObject.name;
        string variant = "";
        string assetPath = AssetDatabase.GetAssetPath (Selection.activeInstanceID);
        AssetImporter.GetAtPath (assetPath).SetAssetBundleNameAndVariant (assetName, variant);

        action (BuildAssetBundleOptions.None);
        Debug.Log ("Asset " + assetName + " Built!");

        AssetDatabase.Refresh ();
    }

    [MenuItem ("Build Asset Bundles/Create Vuforia Scene Bundles")]
    static void BuildBundles () {
        var modelDir = "Assets/Test/";
        var exportDir = "Assets/TestScene";

        //AssetDatabase.RemoveUnusedAssetBundleNames ();
        Debug.Log ("Starting scene creation");
        string[] assetPaths = AssetDatabase.GetAllAssetPaths ();

        // create bundle for each fbx model in target folder
        foreach (string assetPath in assetPaths) {
            if (assetPath.StartsWith (modelDir) && assetPath.EndsWith(".fbx", StringComparison.CurrentCultureIgnoreCase)) {
                Debug.Log ("File: " + assetPath);

                //set custom model import setting, right now only add colliders to model
                ModelImporter modelImporter = (ModelImporter)AssetImporter.GetAtPath (assetPath);
                modelImporter.addCollider = true;
                modelImporter.SaveAndReimport ();

                // open default scene
                Scene newScene = EditorSceneManager.OpenScene ("Assets/Scenes/Vuforia standard scene.unity", OpenSceneMode.Single);

                // find Vuforia plane
                GameObject plane = GameObject.Find ("Ground Plane Stage");

                // load gameObject and add scripts to it to enable gesture listeners 
                var obj = AssetDatabase.LoadAssetAtPath<GameObject> (assetPath);
                var newObj = GameObject.Instantiate (obj);
                //GestureResponseInitializer.AddScriptsToTarget (newObj);

                //make object child of Vuforia plane
                newObj.transform.parent = plane.transform;
                newObj.name = obj.name;

                // save scene in same location of the model as a new scene (doesn't override the default scene)
                string scenePath = modelDir + obj.name + ".unity";
                EditorSceneManager.SaveScene (newScene, scenePath);

                /*AssetImporter asset = AssetImporter.GetAtPath (scenePath);
                asset.assetBundleName = obj.name;
                asset.SaveAndReimport ();*/

                if (!AssetDatabase.IsValidFolder (exportDir)) {
                    AssetDatabase.CreateFolder (assetsFolder, "TestScene");
                    AssetDatabase.CreateFolder (assetsFolder + "/TestScene", "Android");
                    AssetDatabase.CreateFolder (assetsFolder + "/TestScene", "iOS");
                }

                // create a build map to make sure to build only the new scene
                AssetBundleBuild[] buildMap = new AssetBundleBuild[1];

                //set bundle name to the model one
                buildMap[0].assetBundleName = obj.name;
                string[] sceneAssets = new string[1];
                sceneAssets[0] = scenePath;
                buildMap[0].assetNames = sceneAssets;

                BuildPipeline.BuildAssetBundles (Path.Combine (exportDir, "Android"), buildMap, BuildAssetBundleOptions.None, BuildTarget.Android);
                //BuildPipeline.BuildAssetBundles (Path.Combine (exportDir, "iOS"), buildMap, BuildAssetBundleOptions.None, BuildTarget.iOS);

                AssetDatabase.Refresh ();
            }
        }
    }
}