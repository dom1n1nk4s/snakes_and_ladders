class Portal {
  int sx, sy; //startx,starty
  int ex, ey; //endx,endy
  int si,ei; //startindex,endindex
  PImage portalImage;
  int imageHeight, imageWidth;

  Portal(Node startNode, Node endNode) {
    si = startNode.index;
    ei = endNode.index;
    sx = startNode.x + startNode.xsize/2;
    sy = startNode.y + startNode.ysize/2;
    ex = endNode.x + startNode.xsize/2;
    ey = endNode.y + startNode.ysize/2;
    int a =ey-sy;
    int b = ex-sx;
    portalImage = loadImage((si<ei ? "ladder.png" : "snake.png"));
    imageHeight = (int)sqrt(a*a+b*b);
    imageWidth = 70;
    portalImage.resize(imageWidth, imageHeight);
  }
  void draw() {
    imageMode(CENTER);
    pushMatrix();
    translate(sx + (ex-sx) / 2, sy + (ey -sy)/2);
    float sine = float(sy-ey)/imageHeight;
    if (sx > ex) {
      rotate(asin( sine )+PI/2.0);
    } else {
      rotate( PI - asin( sine )+PI/2.0);
    }
    image(portalImage, 0, 0);
    popMatrix();
  }
}

class Node {
  int index;
  int x, y;
  int xsize;
  int ysize;
  boolean isPortal = false;
  boolean isSelected = false;
  int portalExitIndex;
  public Node(int xs, int ys, int i) {
    xsize = xs;
    ysize = ys;
    index = i;
    int rowIndex = ceil(float(index)/columns);
    y = int(height - 1.5*MARGIN- rowIndex*ysize);

    int columnIndex;
    if (rowIndex % 2 == 0) { // eile eina is desines i kaire
      columnIndex = (index-1)%columns +1;
    } else { // eile eina is kaires i desine
      columnIndex = columns - (index-1)%columns;
    }
    x = int (width - 1.5*MARGIN - columnIndex*xsize);
  }
  void draw() {
    if (!isDisabled()) {
      rectMode(CORNER);
      fill(0);
      stroke(255);
      rect(x, y, xsize, ysize);

      textSize(floor((xsize*ysize)*0.0019975031211)); // scaling
      textAlign(CENTER, CENTER);
      if (isSelected) {
        fill(255);
        stroke(30);
        rect(x, y, xsize, ysize);
        fill(0);
      } else {
        fill(0);
        stroke(255);
        rect(x, y, xsize, ysize);
        fill(255);
      }
      text(index, x+xsize/2, y+ysize/2);
    }
  }
  boolean isDisabled() {
    return xsize == 0;
  }
}

class BaseTable implements Drawable {
  LinkedList<Node> table;
  Node selectedNode;
  LinkedList<Portal> portals;
  BaseTable() {
    table = new LinkedList<Node>();
    columns = (int) sqrt(ntable);
    rows = ceil(ntable*1.0 / columns);
    for (int i = 1; i<= ntable; i++) {
      table.add(new Node( (width-3*MARGIN)/columns, (height -3*MARGIN)/rows, i) );
    }
    for (int i = ntable+1; i <= columns*rows; i++) {
      table.add( new Node(0, 0, i));
    }
    portals = new LinkedList<Portal>();
  }
  public void addPortal(Portal p){
    portals.add(p);
   table.get(p.si).isPortal = true;
 
  }
  void draw() {
    for (Node x : table) {
      x.draw();
    }
    for (Portal x : portals) {
      x.draw();
    }
  }
}
