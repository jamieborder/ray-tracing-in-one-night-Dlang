import std.conv: to;

import vector;
import ray;
import material;

struct HitRecord
{
    float t;
    Vector3 p;
    Vector3 normal;
    Material mat;
}

class Hitable
{
public:
    abstract bool hit(Ray r, float t_min, float t_max, ref HitRecord rec);
}

class HitableList : Hitable
{
public:
    Hitable[] list;

    this() {}

    this(Hitable[] l)
    {
        list = l;
    }
    
    override bool hit(Ray r, float t_min, float t_max, ref HitRecord rec)
    {
        HitRecord tempRec;
        bool hitAnything = false;
        double closestSoFar = t_max;
        foreach (int i; 0 .. to!int(list.length)) {
            if (list[i].hit(r, t_min, closestSoFar, tempRec)) {
                hitAnything = true;
                closestSoFar = tempRec.t;
                rec = tempRec;
            }
        }
        return hitAnything;
    }
}
