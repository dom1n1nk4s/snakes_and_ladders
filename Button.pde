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
    buttonSize = int((width + height) * 0.08);
    x = int(width / 2 - buttonSize / 2);
    y = MARGIN + i * (buttonSize + 10);
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
