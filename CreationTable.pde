class CreationStartNew extends BaseMenu { //<>// //<>//
  public CreationStartNew() {
    super(2);

    buttons[0] = new Button(0, "Yes", new FunctionCarrier() {
      public void function() {
        currentGameActivity = new CreationEnterN();
      }
    }
    );
    buttons[1] = new Button(1, "No", new FunctionCarrier() {
      public void function() {
        currentGameActivity = (CreationTable) currentTable;
      }
    }
    );
    selectedButton = buttons[1];
    selectedButton.selected = true;
  }
  public void draw() {
    super.draw();
    textAlign(CENTER);
    fill(255);
    stroke(255);
    text("Start new table?", width / 2, height - MARGIN);
  }
}

class CreationEnterN implements Drawable {
  private String sNumber = "";

  void draw() {
    update();
    textAlign(CENTER, CENTER);
    text("Enter total table size: " + sNumber, width / 2, height / 2);
    fill(255);
    stroke(255);
  }
  private void update() {
    if (keyPressed && !isHoldingPressed) {
      isHoldingPressed = true;
      if (key >= '0' && key <= '9') {
        sNumber += key;
      } else if (key == ' ') {
        try {
          int temp =Integer.parseInt(sNumber);
          if (temp <7) throw new Exception();
          ntable = temp;
        }
        catch(Exception e) {
          sNumber = "";
          fill(color(255, 0, 0));
          return;
        }

        currentGameActivity = new CreationTable();
      } else if (key == BACKSPACE) {
        if (sNumber.length() != 0)
          sNumber = sNumber.substring(0, sNumber.length() - 1);
      }
    }
  }
}

class CreationTable extends BaseTable {
  private Node selectedNode;
  private Node portalStartNode;
  private boolean newestVersionExported = false;
  private String fileName;
  public CreationTable() {
    super();
    selectedNode = table.getFirst();
    selectedNode.isSelected = true;
  }

  void draw() {
    update();
    super.draw();

    if (portalStartNode != null) {
      line(portalStartNode.x + selectedNode.xsize / 2, portalStartNode.y + selectedNode.ysize / 2, selectedNode.x + selectedNode.xsize / 2, selectedNode.y + selectedNode.ysize / 2); // disgusting but its only one line
    }

    textSize(24);
    textAlign(LEFT);
    text("E - Export map", MARGIN, MARGIN);
    textAlign(CENTER);
    text("SPACE - Add/Remove shortcut", width / 2, MARGIN);
    textAlign(RIGHT);
    text("Q - Back to mainmenu", width - MARGIN, MARGIN);

    if (newestVersionExported) {
      textAlign(CENTER);
      text("Table has been exported as "+fileName, width / 2, height - MARGIN / 2);
    }
  }
  private boolean sameStartCoords(Portal p, Node n) {
    return  p.sx == n.x + n.xsize / 2 && p.sy == n.y + n.ysize / 2;
  }
  private void update() {
    if (keyPressed && !isHoldingPressed) {
      isHoldingPressed = true;
      if (keyCode == DOWN) {
        moveVertical(1);
      } else if (keyCode == UP) {
        moveVertical( - 1);
      } else if (keyCode == LEFT) {
        moveHorizontal( - 1);
      } else if (keyCode == RIGHT) {
        moveHorizontal(1);
      } else if (key == ' ') {
        if (portalStartNode == null && !selectedNode.isPortal) {
          portalStartNode = selectedNode;
        } else if (portalStartNode == null && selectedNode.isPortal) {
          for (Portal x : portals) {
            if (sameStartCoords(x, selectedNode)) {
              portals.remove(x);
              selectedNode.isPortal = false;
              break;
            }
          }
          newestVersionExported = false;
        } else if (portalStartNode != null && portalStartNode.y != selectedNode.y) {
          portals.add(new Portal(portalStartNode, selectedNode));
          portalStartNode.isPortal = true;
          portalStartNode.portalExitIndex = selectedNode.index - 1;
          portalStartNode = null;
          newestVersionExported = false;
        } else if (portalStartNode == selectedNode) {
          portalStartNode.isPortal = false;
          portalStartNode = null;
        }
      } else if (key == 'q' || key == 'Q') {
        selectedNode.isSelected = false;
        currentTable = (BaseTable) this;

        currentGameActivity = new MainMenu();
      } else if (key == 'e' || key == 'E') {
        if (!newestVersionExported) {
          fileName = Integer.toString((((((year() - 1970) * 365 + day()) * 24 + hour()) * 60 + minute()) * 60 + second()) * 1000 + millis()) + ".txt";
          PrintWriter file = createWriter(fileName); //  NOT A UNIX TIMESTAMP AND NOT MEANT TO BE ONE
          file.println(ntable);
          for (Portal x : portals)
          {
            file.println(x.si + " " + x.ei);
          }

          file.flush();
          file.close();
          newestVersionExported = true;
        }
      }
    }
  }
  private void moveVertical(int q) {
    selectedNode.isSelected = false;

    int columnIndex = columns - (selectedNode.index - 1) % columns;

    int nToMove = 2 * columnIndex - 1; // steps to move
    if (q == 1) {
      nToMove = -(2 * columns - nToMove);
    }

    if (selectedNode.index - 1 + nToMove >= columns * rows) {
      selectedNode = table.get((rows % 2 == 0 ? columnIndex - 1 : columns - columnIndex));
    } else if (selectedNode.index - 1 + nToMove < 0) {
      selectedNode = table.get(columns * rows + (rows % 2 == 0 ? - (columns - columnIndex) - 1 : - columnIndex));
    } else
      selectedNode = table.get(selectedNode.index - 1 + nToMove);

    selectedNode.isSelected = true;
    if (selectedNode.isDisabled()) {
      moveVertical(q);
    }
  }
  private void moveHorizontal(int q) {
    selectedNode.isSelected = false;

    int cRowIndex = ceil(float(selectedNode.index) / columns); //current row index

    if (cRowIndex % 2 == 0)
      q *= -  1;

    int fRowIndex = ceil(float(selectedNode.index + q) / columns); // future row index

    selectedNode = table.get(selectedNode.index - 1 + q + (cRowIndex != fRowIndex ? - q * columns : 0));

    selectedNode.isSelected = true;

    if (selectedNode.isDisabled()) {
      moveHorizontal(q);
    }
  }
}
