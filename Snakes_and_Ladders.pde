import java.util.LinkedList; //<>//

BaseTable currentTable;
int ntable;
int columns;
int rows;
static int WIDTH, HEIGHT;
static int MARGIN;
boolean isHoldingPressed = false;

Drawable currentGameActivity;

class PlayTable extends BaseTable{

    PlayTable(int playerCount){
    }
}

class PlayPlayerMenu extends baseMenu {

  PlayPlayerMenu() {
    super(3);

    buttons[0] = new Button(0, "1", new FunctionCarrier() {
      public void function() {
        currentGameActivity = new PlayTable(1);
      }
    }
    );
    buttons[1] = new Button(1, "2", new FunctionCarrier() {
      public void function() {
        currentGameActivity = new PlayTable(2);
      }
    }
    );
    buttons[2] = new Button(2, "3", new FunctionCarrier() {
      public void function() {
        currentGameActivity = new PlayTable(3);
      }
    }
    );
    selectedButton = buttons[1];
    selectedButton.selected = true;
  }
  void draw() {
    super.draw();
    
    textAlign(CENTER);
    text("Player count",width/2, height-MARGIN);
  }
}

class MainMenu extends baseMenu {

  MainMenu() {
    super(3);
    buttons[0] = new Button(0, "Play", new FunctionCarrier() {
      public void function() {
        if (ntable != 0) {
          currentGameActivity = new PlayPlayerMenu();
        } else {
          errorMessage = "Map must first be created / imported.";
          errorTime = millis() + 2000;
        }
      }
    }
    );
    buttons[1] = new Button(1, "Create", new FunctionCarrier() {
      public void function() {
        currentGameActivity = new CreationMenu();
      }
    }
    );
    buttons[2] = new Button(2, "Quit", new FunctionCarrier() {
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
  }
}
class CreationMenu extends baseMenu {
  CreationMenu() {
    super(3);
    buttons[0] = new Button(0, "Import", new FunctionCarrier() {
      public void function() {
        inp();
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
        currentGameActivity =new MainMenu();
      }
    }
    );
    selectedButton = buttons[1];
    selectedButton.selected = true;
  }
}

void inp() {
  selectInput("Select a file to import", "fileSelected");
}
void fileSelected(File selection) {
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
      if (si > ntable || ei > ntable || si < 1 || ei < 1) throw new Exception();
      Node startNode = creationTable.table.get(si-1);
      Node endNode = creationTable.table.get(ei-1);
      startNode.isPortal = true;
      creationTable.addPortal(new Portal(startNode, endNode));
    }


    r.close();
    currentGameActivity = creationTable;
  }
  catch(Exception e) {
    e.printStackTrace();
    //errorMessage = "Failed to import map"; // TODO MAKE ERROR MESSAGE GLOBAL OR TRY REDIRECTING SELECTINPUT TO CLASS METHOD INSTEAD OF THIS STATIC METHOD
    //errorTime = millis() + 2000;
  }
}
void keyReleased() {
  isHoldingPressed = false;
}

void setup() {
  size(1024, 768);
  WIDTH = width;
  HEIGHT = height;
  MARGIN = int((width+height)*0.025);
  background(color(255));
  currentGameActivity = new MainMenu();
  strokeWeight(6);


  //selectInput("Select a file to import", "fileSelected");
}
void draw() {
  background(0);
  currentGameActivity.draw();
}
