import vector;
import ray;

class Material
{
}

struct HitRecord
{
    float t;
    Vector3 p;
    Vector3 normal;
    Material* mat_ptr;
}

class Hitable
{
public:
    abstract bool hit(Ray r, float t_min, float t_max, HitRecord* rec);
}

class HitableList : Hitable
{
public:
    Hitable** list;
    int listSize;

    this() {}

    this(Hitable **l, int n)
    {
        list = l;
        listSize = n;
    }
    
    override bool hit(Ray r, float t_min, float t_max, HitRecord* rec)
    {
        HitRecord tempRec;
        bool hitAnything = false;
        double closestSoFar = t_max;
        foreach (int i; 0 .. listSize) {
            if (list[i].hit(r, t_min, closestSoFar, tempRec)) {
                hitAnything = true;
                closestSoFar = tempRec.t;
                rec = tempRec;
            }
        }
        return hitAnything;
    }
}
