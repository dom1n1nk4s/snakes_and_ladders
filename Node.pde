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
    int rowIndex = ceil(float(index) / columns);
    y = int(height - 1.5 * MARGIN - rowIndex * ysize);

    int columnIndex;
    if (rowIndex % 2 == 0) { // eile eina is desines i kaire
      columnIndex = (index - 1) % columns + 1;
    } else { // eile eina is kaires i desine
      columnIndex = columns - (index - 1) % columns;
    }
    x = int(width - 1.5 * MARGIN - columnIndex * xsize);
  }
  void draw() {
    if (!isDisabled()) {
      rectMode(CORNER);
      fill(0);
      stroke(255);
      rect(x, y, xsize, ysize);

      textSize(floor((xsize * ysize) * 0.0019975031211)); // scaling
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
      text(index, x + xsize / 2, y + ysize / 2);
    }
  }
  boolean isDisabled() {
    return xsize == 0;
  }
}
