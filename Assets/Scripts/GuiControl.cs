﻿using UnityEngine;
using System.Collections;
//[ExecuteInEditMode]
public class GuiControl : MonoBehaviour {

    float Choppiness;
    float Height;
    float Speed;
    float TSpeed;
    int Size;
    float Scale;
    public GameObject Ocean;
    Ocean oceanPlane;

	// Use this for initialization
	void Start () {
        oceanPlane = Ocean.GetComponent<Ocean>();
        Choppiness = oceanPlane.Choppiness;
        Height = oceanPlane.Height;
        Speed = oceanPlane.Speed;
        TSpeed = oceanPlane.TransverseSpeed;
        Size = oceanPlane.LengthWidth;
        Scale = oceanPlane.PlaneScale;

	}
	
	// Update is called once per frame
	void Update () {
	
	}

    void OnGUI()
    {
        if (GUI.Button(new Rect(10, 10, 32, 32), "-"))
            Choppiness -= 0.01f;
        if (GUI.Button(new Rect(42, 10, 32, 32), "+"))
            Choppiness += 0.01f;
        GUI.Box(new Rect(74, 10, 128, 32), "Choppiness = " + Choppiness);

        if (GUI.Button(new Rect(10, 42, 32, 32), "-"))
            Height--;//= 0.01f;
        if (GUI.Button(new Rect(42, 42, 32, 32), "+"))
            Height++;//= 0.01f;
        GUI.Box(new Rect(74, 42, 128, 32), "Height = " + Height);

        if (GUI.Button(new Rect(10, 74, 32, 32), "-"))
        {
            Speed/=2;
            TSpeed/=2;
            //Speed-=0.0001f;
            //TSpeed -= 0.0001f;
        }
        if (GUI.Button(new Rect(42, 74, 32, 32), "+"))
        {
            Speed++;
            TSpeed++;
            //Speed+=0.0001f;
            //TSpeed+=0.0001f;
        }
        GUI.Box(new Rect(74, 74, 128, 32), "Speed = " + Speed);

        //if (GUI.Button(new Rect(10, 106, 32, 32), "-"))
        //    Scale -= 0.1f;
        //if (GUI.Button(new Rect(42, 106, 32, 32), "+"))
        //    Scale += 0.1f;
        //GUI.Box(new Rect(74, 106, 128, 32), "Scale = " + Scale);
        //
        if (GUI.Button(new Rect(10, 138, 32, 32), "-") && Size>2)
        {
            Scale *= 2;
            Size--;
            Size /= 2;
            Size++;
        }
        if (GUI.Button(new Rect(42, 138, 32, 32), "+") && Size < 9)
        {
            Scale /= 2;
            Size--;
            Size *= 2;
            Size++;
        }

        GUI.Box(new Rect(74, 138, 128, 32), "Grid Size = " + (Size-1) + "x" + (Size-1));

        if (Choppiness != oceanPlane.Choppiness)
            oceanPlane.Choppiness = Choppiness;
        if (Height != oceanPlane.Height)
            oceanPlane.Height = Height;
        if (Speed != oceanPlane.Speed)
            oceanPlane.Speed = Speed;
        if (Scale != oceanPlane.PlaneScale)
            oceanPlane.PlaneScale = Scale;
        if (Size != oceanPlane.LengthWidth)
            oceanPlane.LengthWidth = Size;
    }
}
