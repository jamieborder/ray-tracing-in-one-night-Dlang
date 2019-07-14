
import ray;
import hitable;
import vector;
import std.random: Random, uniform01;

auto rnd = Random(13);

Vector3 randomInUnitSphere()
{
    Vector3 p;
    do {
        p = 2.0 * Vector3(uniform01(rnd),
                          uniform01(rnd),
                          uniform01(rnd)) - Vector3(1., 1., 1.);
    } while (p.squaredLength >= 1.0);
    return p;
}

Vector3 reflect(const Vector3 v, const Vector3 n)
{
    return v - 2. * dot(v, n) * n;
}

abstract class Material
{
public:
    abstract bool scatter(const Ray rIn, const HitRecord rec, 
                          Vector3 attenuation, out Ray scattered) const;
}

class Lambertian : Material
{
public:
    Vector3 albedo;
    this (const Vector3 a)
    {
        albedo = a;
    }

    override bool scatter(const Ray rIn, const HitRecord rec, 
                          Vector3 attenuation, out Ray scattered) const
    {
        Vector3 target = rec.p + rec.normal + randomInUnitSphere;
        scattered = new Ray(rec.p, target - rec.p);
        attenuation = albedo;
        return true;
    }
}

class Metal : Material
{
public:
    Vector3 albedo;
    float fuzz;

    this (const Vector3 a, float f)
    {
        albedo = a;
        fuzz = f < 1. ? f : 1.;
    }

    override bool scatter(const Ray rIn, const HitRecord rec, 
                          Vector3 attenuation, out Ray scattered) const
    {
        Vector3 reflected = reflect(unitVector(rIn.direction), rec.normal);
        scattered = new Ray(rec.p, reflected + fuzz * randomInUnitSphere);
        attenuation = albedo;
        return (dot(scattered.direction(), rec.normal) > 0.);
    }
}
