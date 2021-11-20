class BaseTable implements Drawable {
  protected LinkedList<Node> table;

  protected LinkedList<Portal> portals;
  BaseTable() {
    table = new LinkedList<Node>();
    columns = (int) sqrt(ntable);
    rows = ceil(ntable * 1.0 / columns);
    for (int i = 1; i <= ntable; i++) {
      table.add(new Node((width - 3 * MARGIN) / columns, (height - 3 * MARGIN) / rows, i));
    }
    for (int i = ntable + 1; i <= columns * rows; i++) {
      table.add(new Node(0, 0, i));
    }
    portals = new LinkedList<Portal>();
  }
  public void addPortal(Portal p) {
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
