import vector;

class Ray
{
public:
    Vector3 A;
    Vector3 B;

    this() {}

    this(const Vector3 a, const Vector3 b)
    {
        A = a;
        B = b;
    }

    Vector3 origin() const { return A; }
    Vector3 direction() const { return B; }
    Vector3 pointAtParameter(float t) { return A + t * B; }
}
