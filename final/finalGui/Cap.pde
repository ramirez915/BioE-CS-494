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
    
    // ********************************************************************* delete functionality
    if(this.letters[pos].equals("del") == true){
      deletePrevLetter();
    }
    
    
    inputStr = inputStr + this.letters[pos];
    //this.vocals[pos].play();                            // play the vocal
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
  
  void deletePrevLetter(){
    // if inputStr is NOT empty then break up into char array to get everything but the last letter
    String strAfterDel = "";
    if(inputStr.length() != 0){
      char[] strToChar = inputStr.toCharArray();
      for(int i = 0; i < inputStr.length() - 1; i++){
        strAfterDel = strAfterDel + strToChar[i];
      }
      inputStr = strAfterDel;
    }
  }
  
}    // end of Cap class
