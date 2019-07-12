import std.stdio;
import std.conv: to;
import std.file: append, remove;
import std.random: Random, uniform01;

import vector;
import ray;
import hitable;
import sphere;
import camera;

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

Vector3 color(Ray r, Hitable world)
{
    HitRecord rec;
    if (world.hit(r, 0.001, float.max, rec)) {
        Vector3 target = rec.p + rec.normal + randomInUnitSphere;
        return 0.5 * color(new Ray(rec.p, target - rec.p), world);
    }
    else {
        Vector3 unitDirection = unitVector(r.direction);
        float t = 0.5 * (unitDirection.y() + 1.0);
        return (1.0 - t) * Vector3(1.0, 1.0, 1.0) + t * Vector3(0.5, 0.7, 1.0);
    }
}

void main()
{
    string outputFile = "./data.ppm";
    try {
        remove(outputFile);
    }
    catch (Throwable) {
    }
    finally {}

    int nx = 200;
    int ny = 100;
    int ns = 100;
    append(outputFile, "P3\n "~to!string(nx)~" "~to!string(ny)~"\n255\n");

    Vector3 lowerLeftCorner = Vector3(-2.0, -1.0, -1.0);
    Vector3 horizontal = Vector3(4.0, 0.0, 0.0);
    Vector3 vertical = Vector3(0.0, 2.0, 0.0);
    Vector3 origin = Vector3(0.0, 0.0, 0.0);

    Hitable[2] list;
    list[0] = new Sphere(Vector3(0., 0., -1.), 0.5);
    list[1] = new Sphere(Vector3(0., -100.5, -1.), 100.);

    Hitable world = new HitableList(list);

    Camera camera = new Camera();

    Ray r;

    for (int j = ny-1; j >=0; j--) {
        for (int i = 0; i <nx; i++) {
            Vector3 col = Vector3(0., 0., 0.);
            for (int s = 0; s < ns; s++) {
                float u = float(i + uniform01(rnd)) / float(nx);
                float v = float(j + uniform01(rnd)) / float(ny);
                // float u = float(i) / float(nx);
                // float v = float(j) / float(ny);
                r = camera.getRay(u, v);
                col += color(r, world);
            }

            col /= float(ns);
            int ir = to!int(255.99 * col.r);
            int ig = to!int(255.99 * col.g);
            int ib = to!int(255.99 * col.b);

            append(outputFile, to!string(ir)~" "
                              ~to!string(ig)~" "
                              ~to!string(ib)~"\n");
        }
    }
}
