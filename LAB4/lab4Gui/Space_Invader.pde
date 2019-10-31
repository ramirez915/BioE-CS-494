int pixelsize = 10; //original was 4    the infinite shooting is normal from orignal code....
int gridsize  = pixelsize * 7 + 5;
Player player;
ArrayList enemies = new ArrayList();
ArrayList bullets = new ArrayList();
int direction = 1;
boolean incy = false;

// do points system
int totalPoints = 0;
ControlP5 siCp5;
Textlabel pointsLbl;
Textlabel points;
PFont siFont;

void spaceInvaderSetup() {
    background(0);
    noStroke();
    fill(255);
    player = new Player();
    createEnemies();
    
    siFont = createFont("MS Gothic",20);

    //-------------------------------------------------------- space invader cp5
    siCp5 = new ControlP5(this);
    pointsLbl = siCp5.addLabel("pointsLbl")
      .setText("Points")
      .setPosition(width-300,0)      // top right corner
      .setColorValue(color(0,255,0))
      .setFont(siFont)
      .show()
      ;
    
    points = siCp5.addLabel("points")
      .setText(Integer.toString(totalPoints))
      .setPosition(width-100,0)      // top right corner
      .setColorValue(color(0,255,0))
      .setFont(siFont)
      .show()
      ;
    //----------------------------------------------------------------
}

void spaceInvaderReset(){
  background(200,0,100);
  deleteEnemies();
  totalPoints = 0;
  
  siCp5.hide();        // hide all the point stuff
}

void spaceInvaderDraw() {
    background(0);

    player.draw();

    for (int i = 0; i < bullets.size(); i++) {
        Bullet bullet = (Bullet) bullets.get(i);
        bullet.draw();
    }

    for (int i = 0; i < enemies.size(); i++) {
        Enemy enemy = (Enemy) enemies.get(i);
        if (enemy.outside() == true) {
            direction *= (-1);
            incy = true;
            break;
        }
    }

    for (int i = 0; i < enemies.size(); i++) {
        Enemy enemy = (Enemy) enemies.get(i);
        if (!enemy.alive()) {
            enemies.remove(i);
            totalPoints += 20;
            println("HIT points: "+ totalPoints);
        } 
        else {
            enemy.draw();
        }
    }

    incy = false;
    
    //DRAW POINTS
    points.setText(Integer.toString(totalPoints));      // updates points
}

void createEnemies() {
  int c = 0;
  for (int i = 0; i < width/gridsize/2; i++) {
      for (int j = 0; j <= 5; j++) {
          enemies.add(new Enemy(i*gridsize, j*gridsize));
          c++;
      }
  }
  println(c +" created "+ enemies.size());
}

void deleteEnemies(){
  int enemyCount = 0;
  while(enemies.size() != 0){
    enemies.remove(0);
    enemyCount++;
  }
  println(enemyCount + " deleted " + enemies.size());
}

class SpaceShip {
    int x, y;
    String sprite[];

    void draw() {
        updateObj();
        drawSprite(x, y);
    }

    void drawSprite(int xpos, int ypos) {
        for (int i = 0; i < sprite.length; i++) {
            String row = (String) sprite[i];

            for (int j = 0; j < row.length(); j++) {
                if (row.charAt(j) == '1')
                    rect(xpos+(j * pixelsize), ypos+(i * pixelsize), pixelsize, pixelsize);
            }
        }
    }

    void updateObj() {
    }
}

class Player extends SpaceShip {
    boolean canShoot = true;
    int shootdelay = 0;

    Player() {
        x = width/gridsize/2;
        y = height - (10 * pixelsize);
        sprite    = new String[5];
        sprite[0] = "0010100";
        sprite[1] = "0110110";
        sprite[2] = "1111111";
        sprite[3] = "1111111";
        sprite[4] = "0111110";
    }

    void updateObj() {
        if (keyPressed && keyCode == LEFT) x -= 10;
        if (keyPressed && keyCode == RIGHT) x += 10;
        if (keyPressed && keyCode == CONTROL && canShoot) {
            bullets.add(new Bullet(x, y));
            canShoot = false;
            shootdelay = 0;
        }

        shootdelay++;
        if (shootdelay >= 20) {
            canShoot = true;
        }
    }
}

class Enemy extends SpaceShip {
    Enemy(int xpos, int ypos) {
        x = xpos;
        y = ypos;
        sprite    = new String[5];
        sprite[0] = "1011101";
        sprite[1] = "0101010";
        sprite[2] = "1111111";
        sprite[3] = "0101010";
        sprite[4] = "1000001";
    }

    void updateObj() {
        if (frameCount%30 == 0) x += direction * (gridsize +100);
        if (incy == true) y += gridsize / 2;
    }

    boolean alive() {
        for (int i = 0; i < bullets.size(); i++) {
            Bullet bullet = (Bullet) bullets.get(i);
            if (bullet.x > x && bullet.x < x + 7 * pixelsize + 5 && bullet.y > y && bullet.y < y + 5 * pixelsize) {
                bullets.remove(i);
                return false;
            }
        }

        return true;
    }

    boolean outside() {
        if (x + (direction*gridsize) < 0 || x + (direction*gridsize) > width - gridsize) {
            return true;
        } 
        else {
            return false;
        }
    }
}

class Bullet {
    int x, y;

    Bullet(int xpos, int ypos) {
        x = xpos + gridsize/2 - 4;
        y = ypos;
    }

    void draw() {
        rect(x, y, pixelsize, pixelsize);
        y -= pixelsize;
    }
}
