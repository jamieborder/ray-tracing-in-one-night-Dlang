import std.stdio;
import std.math: sqrt;
import std.conv: to, ConvOverflowException;

import ray;
import vector;
import hitable;
import material;

class Sphere : Hitable
{
public:
    Vector3 centre;
    float radius;
    Material mat;

    this (Vector3 centre_, float radius_, Material m)
    {
        centre = centre_;
        radius = radius_;
        mat = m;
    }

    override bool hit(const Ray r, float t_min, float t_max, ref HitRecord rec)
    {
        Vector3 oc = r.origin - centre;
        float a = dot(r.direction, r.direction);
        float b = dot(oc, r.direction);
        float c = dot(oc, oc) - radius * radius;
        float discriminant = b * b - a * c;
        if (to!float(discriminant) > to!float(0)) {
            float temp = (-b - sqrt(discriminant)) / a;
            if (temp < t_max && temp > t_min) {
                rec.t = temp;
                rec.p = r.pointAtParameter(rec.t);
                rec.normal = (rec.p - centre) / radius;
                rec.mat = mat;
                return true;
            }
            temp = (-b + sqrt(discriminant)) / a;
            if (temp < t_max && temp > t_min) {
                rec.t = temp;
                rec.p = r.pointAtParameter(rec.t);
                rec.normal = (rec.p - centre) / radius;
                rec.mat = mat;
                return true;
            }
        }
        return false;
    }
}
