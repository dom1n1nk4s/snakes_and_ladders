class BaseTable implements Drawable {
  protected LinkedList<Node> table;

  protected LinkedList<Portal> portals;
  BaseTable() {
    table = new LinkedList<Node>();
    rows = (int) sqrt(ntable);
    columns = ceil(ntable * 1.0 / rows);

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
    Node startNode = table.get(p.si-1);
    startNode.isPortal = true;
    startNode.portalExitIndex = p.ei-1;
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
