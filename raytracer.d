import std.stdio;
import std.conv: to;
import std.file: append, remove;

import vector;

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
    
    for (int j = ny-1; j >=0; j--) {
        for (int i = 0; i <nx; i++) {
            Vector3 col = Vector3(float(i) / float(nx),
                                  float(j) / float(ny),
                                  0.2);
            int ir = to!int(255.99 * col.r);
            int ig = to!int(255.99 * col.g);
            int ib = to!int(255.99 * col.b);

            append(outputFile, to!string(ir)~" "
                              ~to!string(ig)~" "
                              ~to!string(ib)~"\n");
        }
    }
}
