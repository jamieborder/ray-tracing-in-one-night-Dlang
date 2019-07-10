import std.stdio;
import std.conv: to;
import std.file: append;

void main()
{
    string outputFile = "./data.ppm";
    int nx = 200;
    int ny = 100;
    append(outputFile, "P3\n "~to!string(nx)~" "~to!string(ny)~"\n255\n");
    
    for (int j = ny-1; j >=0; j--) {
        for (int i = 0; i <nx; i++) {
            float r = float(i) / float(nx);
            float g = float(j) / float(ny);
            float b = 0.2;
            int ir = to!int(255.99 * r);
            int ig = to!int(255.99 * g);
            int ib = to!int(255.99 * b);

            append(outputFile, to!string(ir)~" "
                              ~to!string(ig)~" "
                              ~to!string(ib)~"\n");
        }
    }
}
