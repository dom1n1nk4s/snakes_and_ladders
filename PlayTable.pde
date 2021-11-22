enum gameState {
  Rolling, Rolled, Moving, GameOver
};

class PlayPlayerMenu extends BaseMenu {

  PlayPlayerMenu() {
    super(3);

    buttons[0] = new Button(0, "1", new FunctionCarrier() {
      public void function() {
        currentGameActivity = new PlayTable(currentTable, 1);
      }
    }
    );
    buttons[1] = new Button(1, "2", new FunctionCarrier() {
      public void function() {
        currentGameActivity = new PlayTable(currentTable, 2);
      }
    }
    );
    buttons[2] = new Button(2, "3", new FunctionCarrier() {
      public void function() {
        currentGameActivity = new PlayTable(currentTable, 3);
      }
    }
    );
    selectedButton = buttons[1];
    selectedButton.selected = true;
  }
  void draw() {
    super.draw();

    textAlign(CENTER);
    text("Player count", width / 2, height - MARGIN);
  }
}

class PlayTable extends BaseTable {
  int speedPerTick;
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
    currentlyPlayingPlayer.isSelected = true;

    Node firstNode = table.get(0);
    speedPerTick = ceil(ntable * 0.1) + 1;
    if (firstNode.isPortal)
      setDestination(firstNode.portalExitIndex);
    else
      setDestination(0);
  }

  private void setDestination(int tIndex) {
    Node temp = table.get(tIndex);
    xdest = temp.x + temp.xsize / 2;
    ydest = temp.y + temp.ysize / 2;
    currentlyPlayingPlayer.tIndex = tIndex;
  }

  void draw() {
    update();
    super.draw();

    String topMessage;
    switch(currentState) {
    case GameOver:
      topMessage = "Player " + (currentlyPlayingPlayer.index + 1) + " has won!";

      break;

    case Rolling:
      topMessage = "Press SPACE to roll";
      break;
    case Moving:
      topMessage = "Moving...";

      if (abs(currentlyPlayingPlayer.x -  xdest) <= speedPerTick && abs(currentlyPlayingPlayer.y -  ydest) <= speedPerTick) { // arrived at dest;
        if (currentlyPlayingPlayer.tIndex >= ntable - 1) {
          currentState = gameState.GameOver;
          return;
        }
        if (rolledNum == 0) {
          //if portal move to portal
          Node currPlayerStandingOn = table.get(currentlyPlayingPlayer.tIndex);
          if (currPlayerStandingOn.isPortal) {
            setDestination(currPlayerStandingOn.portalExitIndex);
          } else { // else next players turn
            currentlyPlayingPlayer.isSelected = false;
            if (currentlyPlayingPlayer.index + 1 >= players.length)
              currentlyPlayingPlayer = players[0];
            else
              currentlyPlayingPlayer = players[currentlyPlayingPlayer.index + 1];
            currentlyPlayingPlayer.isSelected = true;
            currPlayerStandingOn = table.get(currentlyPlayingPlayer.tIndex);
            if (currPlayerStandingOn.isPortal) // if hes already standing on a portal before even rolling (game start)
              setDestination(currPlayerStandingOn.portalExitIndex);
            else
              setDestination(currentlyPlayingPlayer.tIndex);

            currentState = gameState.Rolling;
          }
        } else {
          setDestination(currentlyPlayingPlayer.tIndex + 1);

          rolledNum--;
        }
      } else { //keep moving towards it
        currentlyPlayingPlayer.x += speedPerTick * (xdest < currentlyPlayingPlayer.x ? - 1 : (abs(xdest - currentlyPlayingPlayer.x)  <= speedPerTick ? 0 : 1));

        currentlyPlayingPlayer.y += speedPerTick * (ydest < currentlyPlayingPlayer.y ? - 1 : (abs(ydest - currentlyPlayingPlayer.y)  <= speedPerTick ? 0 : 1));
      }

      break;
    case Rolled:
      topMessage = "You rolled " + rolledNum;
      break;
    default:
      topMessage = "ERROR";
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
    text("Player " + (currentlyPlayingPlayer.index + 1) + " round", width / 2, height - MARGIN / 2);

    text(topMessage, width / 2, MARGIN);
    textAlign(RIGHT);
    text("Q - Back to mainmenu", width - MARGIN, MARGIN);
  }
  void update() {
    if (keyPressed && !isHoldingPressed) {

      isHoldingPressed = true;

      if (key == ' ') {
        if (currentState == gameState.Rolling) {
          rolledNum = (int)random(6) + 1;
          rolledTime = millis() + 1000;
          currentState = gameState.Rolled;
        }
      } else if (key == 'q' || key == 'Q') {
        currentGameActivity = new MainMenu();
      }
    }
  }
}
