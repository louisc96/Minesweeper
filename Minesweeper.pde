import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUMROWS = 20;
public final static int NUMCOLS = 20;
public final static int NUMMINES = 1;
private boolean gameOver = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton> (); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );


  //your code to initialize buttons goes here
  //INITIALIZE 2D ARRAY OF MSBUTTON OBJECTS
  buttons = new MSButton[NUMROWS][NUMCOLS];
  for (int r = 0; r < NUMROWS; r++) {
    for (int c = 0; c < NUMCOLS; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  // ADD MINES TO THE BOARD
  setMines();

  //for(int i = 0; i < mines.size(); i++){
  //  System.out.println(mines.get(i).myRow + mines.get(i).myCol);}
}
public void setMines()
{
  //your code
  while (mines.size() < 30) {
    int r = (int)(Math.random()* NUMROWS);
    int c = (int)(Math.random()* NUMCOLS);
    if (!mines.contains(buttons[r][c])) {
      mines.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
  background( 0 );
  text("No. of bombs: " + mines.size(), 350, 390);
  if (isWon() == true)
    displayWinningMessage();

  // CREATE UP TO NUM_MINES RANDOMLY LOCATED MINES
  // ADD THEM TO ARRAYLIST OF MINES
  // CALL IN SETUP() ONLY
}
public boolean isWon()
{
  //your code here
  for (int i=0; i<NUMROWS; i++) {
    for (int j=0; j<NUMCOLS; j++) {
      if (!buttons[i][j].isClicked()==true&&!mines.contains(buttons[i][j])) {
        return false;
      }
    }
  }
  return true;
}
public void displayLosingMessage()
{
  //your code here
  //for(int r = 0; r<NUMROWS; r++){
  //  for(int c = 0; c<NUMCOLS; c++){
  //    if(mines.contains(buttons[r][c])){
  //      buttons[r][c].flagged=false;
  //      buttons[r][c].clicked=true;
  for (int i = 0; i < mines.size(); i++) {
    if (mines.get(i).flagged == false) {
      mines.get(i).clicked = true;
    }
  }
  buttons[0][0].setLabel("Y");
  buttons[0][1].setLabel("O");
  buttons[0][2].setLabel("U");
  buttons[0][4].setLabel("L");
  buttons[0][5].setLabel("O");
  buttons[0][6].setLabel("S");
  buttons[0][7].setLabel("T");
}
public void displayWinningMessage()
{
  //your code here
  buttons[0][0].setLabel("Y");
  buttons[0][1].setLabel("O");
  buttons[0][2].setLabel("U");
  buttons[0][4].setLabel("W");
  buttons[0][5].setLabel("O");
  buttons[0][6].setLabel("N");
}
public boolean isValid(int r, int c)
{
  //your code here
  if (r >= 0 && r < NUMROWS && c >= 0 && c < NUMCOLS)
    return true;
  return false;
}
public int countMines(int row, int col)
{
  int numMines = 0;
  //your code here
  int[][] directions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}, {-1, 1}, {1, 1}, {1, -1}, {-1, -1}};
  for (int i = 0; i < directions.length; i++) {
    int row1 = row + directions[i][0];
    int col1 = col + directions[i][1]; 
    if (isValid(row1, col1) && mines.contains(buttons[row1][col1])) { 
      numMines++;
    }
  }
  return numMines;
}
public class MSButton
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )
  {
    width = 400/NUMCOLS;
    height = 400/NUMROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
     //your code here
    if(mouseButton == LEFT && !flagged){
      clicked = true;
   
    if (mines.contains(this)) {
      displayLosingMessage();
    } 
    else if (countMines(myRow, myCol)>0) {
      clicked=true;
      setLabel(""+countMines(myRow, myCol));
    } 
    else {
      //call mousePressed for the blob on left
      clicked = true;
      for (int i = myRow-1; i<=myRow+1; i++) {
        for (int j = myCol-1; j<=myCol+1; j++) {
          if (isValid(i, j) && !buttons[i][j].isClicked()) {
            buttons[i][j].mousePressed();
          }
        }
      }
    }
    }
        if (mouseButton == RIGHT) {
      flagged =!flagged;
      //if (flagged == false) {
      //  flagged = true;
      //} else if (flagged == true) {
      //  flagged = false;
      //}
      //if (flagged == false) {
      //  clicked = false;
      //}
    }
  }
  public void draw () 
  {    
    // CASE 1: FLAGGED TILE IN BLACK
    if (flagged)
      fill(0);
    // CASE 2: EXPLODED MINE IN RED
    else if ( clicked && mines.contains(this) )
      fill(255, 0, 0);
    // CASE 3: REVEALED TILE IN LIGHT GRAY
    else if (clicked)
      fill( 200 );
    // CASE 4: HIDDEN TILE IN DARK GRAY
    else
      fill( 100 );
    // DISPLAY TILE AND LABEL IF IT HAS NEIGHBORING MINES

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked() {
    return clicked;
  }
}
