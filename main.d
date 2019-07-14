import std.stdio;
import std.conv: to;
import std.file: append, remove;
import std.random: Random, uniform01;

import vector;
import ray;
import hitable;
import sphere;
import camera;
import material;

auto rnd = Random(13);

Vector3 color(Ray r, Hitable world, int depth)
{
    HitRecord rec;
    if (world.hit(r, 0.001, float.max, rec)) {
        Ray scattered;
        Vector3 attenuation;
        if (depth < 1 && rec.mat.scatter(r, rec, attenuation, scattered)) {
            writeln("depth = ", depth);
            return attenuation * color(scattered, world, depth + 1);
        }
        else {
            return Vector3(0., 0., 0.);
        }
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

    Hitable[4] list;
    list[0] = new Sphere(Vector3(0., 0., -1.), 0.5,
                                 new Lambertian(Vector3(0.8, 0.3, 0.4)));
    list[1] = new Sphere(Vector3(0., -100.5, -1.), 100.,
                                 new Lambertian(Vector3(0.8, 0.8, 0.0)));
    list[2] = new Sphere(Vector3(1., 0., -1.), 0.5,
                                 new Metal(Vector3(0.8, 0.6, 0.2), 1.0));
    list[3] = new Sphere(Vector3(-1., 0., -1.), 0.5,
                                 new Metal(Vector3(0.8, 0.8, 0.9), 0.3));

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
                col += color(r, world, 0);
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
