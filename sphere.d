import std.stdio;
import std.math: sqrt;

import ray;
import vector;
import hitable;

class Sphere : Hitable
{
public:
    Vector3 centre;
    float radius;

    this (Vector3 centre_, float radius_)
    {
        centre = centre_;
        radius = radius_;
    }

    override bool hit(const Ray r, float t_min, float t_max, ref HitRecord rec)
    {
        Vector3 oc = r.origin - centre;
        float a = dot(r.direction, r.direction);
        float b = dot(oc, r.direction);
        float c = dot(oc, oc) - radius * radius;
        float discriminant = b * b - a * c;
        if (discriminant > 0) {
            float temp = (-b - sqrt(discriminant)) / a;
            if (temp < t_max && temp > t_min) {
                rec.t = temp;
                rec.p = r.pointAtParameter(rec.t);
                rec.normal = (rec.p - centre) / radius;
                return true;
            }
            temp = (-b + sqrt(discriminant)) / a;
            if (temp < t_max && temp > t_min) {
                rec.t = temp;
                rec.p = r.pointAtParameter(rec.t);
                rec.normal = (rec.p - centre) / radius;
                return true;
            }
        }
        return false;
    }
}
