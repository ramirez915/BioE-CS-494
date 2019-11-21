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
    println("this.counter: " + (this.counter));
    inputStr = inputStr + this.letters[pos];
    this.counter = 0;
    this.watch.stop();
    this.watch.reset();
    
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
