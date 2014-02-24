
// This class does not add anything to the BaseInteractiveRectangle
// But it can easily override the draw method, etc.
public class BezierAnchorPointHandle extends BaseInteractiveRectangle
{
  public BezierAnchorPointHandle(PVector position, float size) 
  {
    super(position, size, size);
  }
}

// This class does not add anything to the BaseInteractiveCircle
// But it can easily override the draw method, etc.
public class BezierControlPointHandle extends BaseInteractiveCircle
{
  public BezierControlPointHandle(PVector position, float r) 
  {
    super(position, r);
  }
}
