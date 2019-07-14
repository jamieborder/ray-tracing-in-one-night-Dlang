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
        // writeln("00");
        float a = dot(r.direction, r.direction);
        // writeln("0");
        float b = dot(oc, r.direction);
        // writeln("1");
        float c = dot(oc, oc) - radius * radius;
        // writeln("2");
        float discriminant = b * b - a * c;
        // writeln("3");
        // writeln("discriminant = ", discriminant);
        // writefln("%3.40f", discriminant);
        // writeln("typeof(discriminant) = ", typeid(discriminant));
        // writeln("typeid(0.) = ",  typeid(to!float(0)));
        scope (failure) return false;
        try {
            // writeln("aa");
            // writeln("discriminant = ", discriminant);
            // writeln("typeof(discriminant) = ", typeid(to!float(discriminant)));
            // writeln("typeid(0.) = ",  typeid(to!float(0)));
            if (to!float(discriminant) > to!float(0)) {
                // writeln("4");
                float temp = (-b - sqrt(discriminant)) / a;
                // writeln("5");
                if (temp < t_max && temp > t_min) {
                    // writeln("a");
                    rec.t = temp;
                    rec.p = r.pointAtParameter(rec.t);
                    // writeln("b");
                    rec.normal = (rec.p - centre) / radius;
                    rec.mat = mat;
                    // writeln("c");
                    return true;
                }
                temp = (-b + sqrt(discriminant)) / a;
                if (temp < t_max && temp > t_min) {
                    // writeln("d");
                    rec.t = temp;
                    rec.p = r.pointAtParameter(rec.t);
                    // writeln("e");
                    rec.normal = (rec.p - centre) / radius;
                    rec.mat = mat;
                    // writeln("f");
                    return true;
                }
            }
        }
        catch (ConvOverflowException e) {
            writeln("caught exception ", e);
            return false;
        }
        finally {
        }
        return false;
    }
}
