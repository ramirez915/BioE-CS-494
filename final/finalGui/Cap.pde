class Cap{
  boolean capState;
  int counter;
  StopWatch watch;
  String[] letters;
  SoundFile[] vocals;
  
  // constructor
  Cap(String[] letters,SoundFile[] vocals){
    this.capState = false;
    this.counter = 0;
    this.watch = new StopWatch();
    this.letters = letters;
    this.vocals = vocals;
    
    println("letters for cap ");
    for(String s: this.letters){
      println(s);
    }
  }
  
  // setts the letter for the cap based off of how many times its been tapped
  void setLetter(){
    int pos = this.counter - 1;
    if(pos == -1){
      pos = 0;        // sometimes we ge this error not sure why
    }
    println("pos is: " + pos);
    
    // delete functionality
    //if(this.letters[pos].equals("del") == true){
    //  char[] strToChar = inputStr.toCharArray();
      
    //}
    
    
    inputStr = inputStr + this.letters[pos];
    this.vocals[pos].play();                            // play the vocal
    //delay(500);
    this.counter = 0;
    this.watch.stop();
    this.watch.reset();
    this.capState = false;
    prevCap = "";
    
    println("setting " + this.letters[pos]);
  }
  
  void incCounter(){
    // if we're at the upper bound we loop back
    if(this.counter == this.letters.length){
      this.counter = 0;
    }
    this.counter++;
  }
}
