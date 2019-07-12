
import vector;
import ray;

class Camera
{
public:
    Vector3 lowerLeftCorner;
    Vector3 horizontal;
    Vector3 vertical;
    Vector3 origin;

    this ()
    {
        lowerLeftCorner = Vector3(-2.0, -1.0, -1.0);
        horizontal      = Vector3(4.0, 0.0, 0.0);
        vertical        = Vector3(0.0, 2.0, 0.0);
        origin          = Vector3(0.0, 0.0, 0.0);
    }

    Ray getRay(float u, float v)
    {
        return new Ray(origin, lowerLeftCorner + u * horizontal + v * vertical); 
    }
}
