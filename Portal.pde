class Portal {
  int sx, sy; //startx,starty
  int ex, ey; //endx,endy
  int si, ei; //startindex,endindex
  PImage portalImage;
  int imageHeight, imageWidth;

  Portal(Node startNode, Node endNode) {
    si = startNode.index;
    ei = endNode.index;
    sx = startNode.x + startNode.xsize / 2;
    sy = startNode.y + startNode.ysize / 2;
    ex = endNode.x + startNode.xsize / 2;
    ey = endNode.y + startNode.ysize / 2;
    int a = ey - sy;
    int b = ex - sx;
    portalImage = loadImage((si<ei ? "ladder.png" : "snake.png"));
    imageHeight = (int)sqrt(a * a + b * b);
    imageWidth = 70;
    portalImage.resize(imageWidth, imageHeight);
  }
  void draw() {
    imageMode(CENTER);
    pushMatrix();
    translate(sx + (ex - sx) / 2, sy + (ey - sy) / 2);
    float sine = float(sy - ey) / imageHeight;
    if (sx > ex) {
      rotate(asin(sine) + PI / 2.0);
    } else {
      rotate(PI - asin(sine) + PI / 2.0);
    }
    image(portalImage, 0, 0);
    popMatrix();
  }
}
