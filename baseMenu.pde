interface Drawable {
  public void draw();
}

interface FunctionCarrier {
  public void function();
}

class Button {

  private boolean selected = false;
  private int x, y;
  private int buttonSize;
  private int highlightColor = color(255);
  private int regularColor = color(0);
  private String text;
  private int index;

  public FunctionCarrier functionCarrier;
  public Button(int i, String t, FunctionCarrier fc) {
    buttonSize = int((width+height)*0.08);
    x = int(width / 2 - buttonSize/2  );
    y = MARGIN + i*(buttonSize + 10);
    text = t;
    index = i;
    functionCarrier = fc;
  }
  public void draw() {
    textSize(45);
    textAlign(CENTER, CENTER);
    if (selected) {
      fill(highlightColor);
      stroke(255);
      rect(x, y, buttonSize, buttonSize);
      fill(regularColor);
      text(text, x, y, buttonSize, buttonSize);
    } else {
      fill(highlightColor);
      text(text, x, y, buttonSize, buttonSize);
    }
  }
}
class baseMenu implements Drawable {
  protected int n;
  protected Button[] buttons;
  protected Button selectedButton;
  protected String errorMessage = null;
  protected int errorTime;

  private void displayError() {
    if (millis() < errorTime) {
      textAlign(CENTER, CENTER);
      fill(255);
      text(errorMessage, width/2, height-MARGIN);
    } else {
      errorTime = 0;
      errorMessage = null;
    }
  }

  public baseMenu(int n) {
    this.n = n;
    buttons = new Button[n];
  }
  void draw() {
    update();
    for (Button x : buttons) {
      x.draw();
    }
    if (errorMessage != null)
      displayError();
  }
  private  void update() {
    if (keyPressed && !isHoldingPressed) {

      isHoldingPressed = true;

      if (keyCode == UP) {
        selectedButton.selected = false;
        if (selectedButton.index-1 < 0) {
          selectedButton = buttons[n-1];
        } else {
          selectedButton = buttons[selectedButton.index-1];
        }
        selectedButton.selected = true;
      } else if (keyCode == DOWN) {
        selectedButton.selected = false;
        if (selectedButton.index+1 >= n) {
          selectedButton = buttons[0];
        } else {
          selectedButton = buttons[selectedButton.index+1];
        }
        selectedButton.selected = true;
      } else if (key == ' ') { // space
        selectedButton.functionCarrier.function();
      }
    }
  }
}
