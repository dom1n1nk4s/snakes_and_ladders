class Player implements Drawable { //<>// //<>//
  int index;
  int x, y;
  int tIndex = 0; //tableIndex
  Player(int i, Node node ) {
    index = i;
    x = node.x + node.xsize/2;
    y = node.y + node.ysize/2;
  }
  void draw() {
    textAlign(CENTER, CENTER);
    text(index+1, x, y);
  }
}

enum gameState {
  Rolling, Rolled, Moving, GameOver
};

class PlayTable extends BaseTable {
  int speedPerTick = 2;
  int xdest, ydest;


  Player[] players;
  Player currentlyPlayingPlayer;
  gameState currentState = gameState.Rolling;
  int rolledNum;
  int rolledTime;

  PlayTable(BaseTable baseTable, int playerCount) {
    super();
    portals = (LinkedList)baseTable.portals.clone();
    table = (LinkedList)baseTable.table.clone();
    players = new Player[playerCount];
    for (int i = 0; i < playerCount; i++)
      players[i] = new Player(i, table.get(0));
    currentlyPlayingPlayer = players[0];
    setDestination(0);
  }

  private void setDestination(int tIndex) {
    Node temp = table.get(tIndex);
    xdest = temp.x+ temp.xsize /2;
    ydest = temp.y+ temp.ysize /2;
    currentlyPlayingPlayer.tIndex = tIndex;
  }

  void draw() {
    update();
    super.draw();

    String bottomMessage;
    switch(currentState) {
    case GameOver:
      bottomMessage = "Player " + currentlyPlayingPlayer.index+1 + " has won!";

      break;

    case Rolling:
      bottomMessage = "Press SPACE to roll";
      break;
    case Moving:
      bottomMessage = "Moving...";


      if ( abs(currentlyPlayingPlayer.x -  xdest) <=speedPerTick && abs(currentlyPlayingPlayer.y -  ydest) <=speedPerTick   ) { // arrived at dest;
        if (currentlyPlayingPlayer.tIndex == ntable) {
          currentState = gameState.GameOver;
          return;
        }
        if (rolledNum == 0) {
          //if portal move to portal
          Node currPlayerStandingOn = table.get(currentlyPlayingPlayer.tIndex);
          if (currPlayerStandingOn.isPortal) {
            setDestination(currPlayerStandingOn.portalExitIndex);
          } else { // else next players turn
            if (currentlyPlayingPlayer.index+1 >= players.length)
              currentlyPlayingPlayer = players[0];
            else
              currentlyPlayingPlayer = players[currentlyPlayingPlayer.index+1];

            setDestination(currentlyPlayingPlayer.tIndex);
            currentState = gameState.Rolling;
          }
        } else {
          setDestination(currentlyPlayingPlayer.tIndex+1);

          rolledNum--;
        }
      } else { //keep moving towards it
        currentlyPlayingPlayer.x += speedPerTick * ( xdest < currentlyPlayingPlayer.x? -1: ( xdest == currentlyPlayingPlayer.x ? 0:1));
        //currentlyPlayingPlayer.x +=  /*theres probably a better way*/
        currentlyPlayingPlayer.y += speedPerTick * ( ydest < currentlyPlayingPlayer.y? -1: ( ydest == currentlyPlayingPlayer.y ? 0:1));
      }




      break;
    case Rolled:
      bottomMessage = "You rolled " + rolledNum;
      break;
    default:
      bottomMessage = "ERROR";
    }

    for (int i = 0; i < players.length; i++)
      players[i].draw();


    if (currentState == gameState.Rolled) {
      if (millis() > rolledTime) {
        currentState = gameState.Moving;
      }
    }


    textSize(24);
    textAlign(CENTER);
    text("Player " + currentlyPlayingPlayer.index+1 + " round", width/2, height-MARGIN/2);

    text(bottomMessage, width/2, MARGIN);
    textAlign(RIGHT);
    text("Q - Back to mainmenu", width-MARGIN, MARGIN);
  }
  void update() {
    if (keyPressed && !isHoldingPressed) {

      isHoldingPressed = true;

      if (key == ' ') {
        if (currentState == gameState.Rolling) {
          rolledNum = (int)random(6)+1;
          rolledTime = millis()+1000;
          currentState = gameState.Rolled;
        }
      } else if (key == 'q' || key == 'Q') {
        currentGameActivity = new MainMenu();
      }
      else if (key == 'b'){
      println("debug"); //<>//
      }
    }
  }
}
