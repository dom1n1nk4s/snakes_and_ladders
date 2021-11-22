class BaseMenu implements Drawable {
  String errorMessage = null;
  int errorTime;
  protected int n;
  protected Button[] buttons;
  protected Button selectedButton;

  private void displayError() {
    if (millis() < errorTime) {
      textAlign(CENTER, CENTER);
      fill(255);
      text(errorMessage, width / 2, height - MARGIN);
    } else {
      errorTime = 0;
      errorMessage = null;
    }
  }

  public BaseMenu(int n) {
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
        if (selectedButton.index - 1 < 0) {
          selectedButton = buttons[n - 1];
        } else {
          selectedButton = buttons[selectedButton.index - 1];
        }
        selectedButton.selected = true;
      } else if (keyCode == DOWN) {
        selectedButton.selected = false;
        if (selectedButton.index + 1 >= n) {
          selectedButton = buttons[0];
        } else {
          selectedButton = buttons[selectedButton.index + 1];
        }
        selectedButton.selected = true;
      } else if (key == ' ') {
        selectedButton.functionCarrier.function();
      }
    }
  }
}
