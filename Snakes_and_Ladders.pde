import java.util.LinkedList; //<>// //<>// //<>// //<>//

BaseTable currentTable;
int ntable;
int columns;
int rows;
static int WIDTH, HEIGHT;
static int MARGIN;
boolean isHoldingPressed = false;

Drawable currentGameActivity;

interface Drawable {
  public void draw();
}

class MainMenu extends BaseMenu {

  MainMenu() {
    super(3);
    buttons[0] =new Button(0, "Play", new FunctionCarrier() {
      public void function() {
        if (ntable != 0) {
          currentGameActivity = new PlayPlayerMenu();
        } else {
          errorMessage= "Map must first be created / imported.";
          errorTime = millis() + 2000;
        }
      }
    }
    );
    buttons[1] =new Button(1, "Create", new FunctionCarrier() {
      public void function() {
        currentGameActivity = new CreationMenu();
      }
    }
    );
    buttons[2] =new Button(2, "Quit", new FunctionCarrier() {
      public void function() {
        exit();
      }
    }
    );
    selectedButton = buttons[1];
    selectedButton.selected = true;
  }

  void draw() {
    super.draw();
    text("SPACE to select", width / 4, height - 3 * MARGIN);
    text("ARROW KEYS to move", width - width / 4, height - 3 * MARGIN);
  }
}
public class CreationMenu extends BaseMenu {
  CreationMenu cm = this; // needed for callbackObject selectInput
  CreationMenu() {
    super(3);
    buttons[0] = new Button(0, "Import", new FunctionCarrier() {
      public void function() {
        selectInput("Select a file to import", "fileSelected", null, cm);
      }
    }
    );
    buttons[1] = new Button(1, "Make now", new FunctionCarrier() {
      public void function() {
        if (ntable == 0)
        currentGameActivity = new CreationEnterN();
        else
          currentGameActivity = new CreationStartNew();
      }
    }
    );
    buttons[2] = new Button(2, "Back", new FunctionCarrier() {
      public void function() {
        currentGameActivity = new MainMenu();
      }
    }
    );
    selectedButton = buttons[1];
    selectedButton.selected = true;
  }
  public void fileSelected(File selection) {
    BufferedReader r;
    try {
      r = createReader(selection);
      String line = r.readLine();
      ntable = Integer.parseInt(line);
      if (ntable < 7) throw new Exception();
      CreationTable creationTable = new CreationTable();
      while ((line = r.readLine()) != null) {
        String[] array = line.split(" ");
        if (array.length > 2) throw new Exception();
        int si = Integer.parseInt(array[0]);
        int ei = Integer.parseInt(array[1]);
        if (si> ntable || ei > ntable || si < 1 || ei < 1 || si == ei) throw new Exception();
        /*would probably be wise to add a check whether a portal's entrance and exit is on the same row,
         but that would be bad ux since the user doesnt know what the table's dimensions will be*/

        Node startNode = creationTable.table.get(si - 1);
        if(startNode.isPortal) throw new Exception();
        Node endNode = creationTable.table.get(ei - 1);
        creationTable.addPortal(new Portal(startNode, endNode));
      }
      r.close();
      currentGameActivity = creationTable;
    }
    catch(Exception e) {
      e.printStackTrace();
      errorMessage = "Failed to import map";
      errorTime = millis() + 2000;
    }
  }
}



void keyReleased() {
  isHoldingPressed = false;
}
void setup() {
  size(1024, 768);
  WIDTH = width;
  HEIGHT = height;
  MARGIN = int((width + height) * 0.025);
  background(color(255));
  currentGameActivity = new MainMenu();
  strokeWeight(6);
}
void draw() {
  background(0);
  currentGameActivity.draw();
}
