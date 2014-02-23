
public class BezierAnchorPointHandle extends BaseInteractiveRectangle
{
  public BezierAnchorPointHandle(PVector position, float size) 
  {
    super(position, size, size);
  }
}

public class BezierControlPointHandle extends BaseInteractiveCircle
{
  public BezierControlPointHandle(PVector position, float r) 
  {
    super(position, r);
  }
}

