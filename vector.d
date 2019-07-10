import std.stdio;
import std.math;

// alias inline() = pragma(inline, true);
// alias pragma(inline, true) inline;

struct Vector3
{
public:
    float[3] e;

    this (float e0, float e1, float e2)
    {
        e[0] = e0;
        e[1] = e1;
        e[2] = e2;
    }

    pragma(inline, true) float x() const { return e[0]; }
    pragma(inline, true) float y() const { return e[1]; }
    pragma(inline, true) float z() const { return e[2]; }
    pragma(inline, true) float r() const { return e[0]; }
    pragma(inline, true) float g() const { return e[1]; }
    pragma(inline, true) float b() const { return e[2]; }

    pragma(inline, true) float* opUnary(string s)() if (s == "+") 
    { 
        return &this; 
    }
    pragma(inline, true) Vector3 opUnary(string s)() if (s == "-") 
    { 
        return Vector3(-e[0], -e[1], -e[2]); 
    }

    pragma(inline, true) float opIndex(size_t i) { return e[i]; }
    // pragma(inline, true) float* opIndex(size_t i) { return &e[i]; }

    pragma(inline, true) size_t length() { return e.length; }

    pragma(inline, true) Vector3 opBinary(string op)(const Vector3 rhs)
    { 
        mixin("return Vector3(e[0] "~op~" rhs.e[0],"
                            ~"e[1] "~op~" rhs.e[1],"
                            ~"e[2] "~op~" rhs.e[2]);");
    }

    pragma(inline, true) Vector3 opBinary(string op)(float scalar)
    {
        mixin("return Vector3(e[0] "~op~" scalar, "
                            ~"e[1] "~op~" scalar, "
                            ~"e[2] "~op~" scalar);");
    }
    
    pragma(inline, true) Vector3 opBinaryRight(string op)(float scalar)
    {
        mixin("return Vector3(e[0] "~op~" scalar, "
                            ~"e[1] "~op~" scalar, "
                            ~"e[2] "~op~" scalar);");
    }

    pragma(inline, true) void opOpAssign(string op)(const Vector3 rhs)
    {
        mixin("e[0] "~op~"= rhs.e[0];"
             ~"e[1] "~op~"= rhs.e[1];"
             ~"e[2] "~op~"= rhs.e[2];");
    }

    pragma(inline, true) void opOpAssign(string op)(const float scalar)
        if (op == "*" || op == "/")
    {
        mixin("e[0] "~op~"= scalar;"
             ~"e[1] "~op~"= scalar;"
             ~"e[2] "~op~"= scalar;");
    }
    
    pragma(inline, true) float dot(const Vector3* rhs)
    {
        return e[0] * rhs.e[0] + e[1] * rhs.e[1] + e[2] * rhs.e[2];
    }

    pragma(inline, true) Vector3 cross(const Vector3* rhs)
    {
        return Vector3(e[1] * rhs.e[2] - e[2] * rhs.e[1],
                       e[2] * rhs.e[0] - e[0] * rhs.e[2],
                       e[0] * rhs.e[1] - e[1] * rhs.e[0]);
    }

    pragma(inline, true) void makeUnitVector()
    {
        float k = 1.0 / sqrt(e[0]*e[0] + e[1]*e[1] + e[2]*e[2]);
        e[0] *= k; e[1] *= k; e[2] *= k;
    }
}

pragma(inline, true) Vector3 unitVector(Vector3 vec)
{
    return Vector3(vec[0] / vec.length, vec[1] / vec.length, vec[2] / vec.length);
}
