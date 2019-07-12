import std.stdio;
import std.conv: to;
import std.file: append, remove;

import vector;
import ray;

bool hitSphere(const Vector3 centre, float radius, const Ray r)
{
    Vector3 oc = r.origin - centre;
    float a = dot(r.direction, r.direction);
    float b = 2.0 * dot(oc, r.direction);
    float c = dot(oc, oc) - radius * radius;
    float discriminant = b * b - 4 * a * c;
    return discriminant > 0;
}

Vector3 color(Ray r)
{
    if (hitSphere(Vector3(0., 0., -1.), 0.5, r))
        return Vector3(1., 0., 0.);
    Vector3 unitDirection = unitVector(r.direction);
    float t = 0.5 * (unitDirection.y() + 1.0);
    return (1.0 - t) * Vector3(1.0, 1.0, 1.0) + t * Vector3(0.5, 0.7, 1.0);
}

void main()
{
    string outputFile = "./data.ppm";
    try {
        remove(outputFile);
    }
    finally {}

    int nx = 200;
    int ny = 100;
    append(outputFile, "P3\n "~to!string(nx)~" "~to!string(ny)~"\n255\n");
    Vector3 lowerLeftCorner = Vector3(-2.0, -1.0, -1.0);
    Vector3 horizontal = Vector3(4.0, 0.0, 0.0);
    Vector3 vertical = Vector3(0.0, 2.0, 0.0);
    Vector3 origin = Vector3(0.0, 0.0, 0.0);
    
    for (int j = ny-1; j >=0; j--) {
        for (int i = 0; i <nx; i++) {
            float u = float(i) / float(nx);
            float v = float(j) / float(ny);
            Ray r = new Ray(origin, 
                            lowerLeftCorner + u * horizontal + v * vertical);
            Vector3 col = color(r);
            int ir = to!int(255.99 * col.r);
            int ig = to!int(255.99 * col.g);
            int ib = to!int(255.99 * col.b);

            append(outputFile, to!string(ir)~" "
                              ~to!string(ig)~" "
                              ~to!string(ib)~"\n");
        }
    }
}
