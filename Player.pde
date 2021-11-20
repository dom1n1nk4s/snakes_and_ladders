class Player implements Drawable { //<>// //<>// //<>//
  private boolean isSelected = false;
  private int index;
  private int x, y;
  private int tIndex = 0; //tableIndex
  private PImage img;
  private int xoffset, yoffset;
  Player(int i, Node node) {
    index = i;
    x = node.x + node.xsize / 2;
    y = node.y + node.ysize / 2;
    img = loadImage(index + 1 + ".png");
    img.resize(node.xsize / 3, node.ysize / 3);
    xoffset = node.xsize / 5;
    yoffset = node.ysize / 5;
  }
  void draw() {
    imageMode(CENTER);
    if (!isSelected)
      image(img, x + xoffset * (index % 2 ==  0 ? 1 :-  1), y + yoffset * (int(index / 2) ==  0 ? 1 :-  1));
    else
      image(img, x, y);
  }
}
