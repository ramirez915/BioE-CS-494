class Cap{
  boolean capState;
  int counter;
  StopWatch watch;
  String[] letters;
  
  // constructor
  Cap(String[] letters){
    this.capState = false;
    this.counter = 0;
    this.watch = new StopWatch();
    this.letters = letters;
  }
  
  // setts the letter for the cap based off of how many times its been tapped
  void setLetter(){
    inputStr = inputStr + this.letters[this.counter - 1];
    this.counter = 0;
    this.watch.stop();
    this.watch.reset();
  }
  
  void incCounter(){
    // if we're at the upper bound we loop back
    if(this.counter == this.letters.length){
      this.counter = 0;
    }
    this.counter++;
  }
}