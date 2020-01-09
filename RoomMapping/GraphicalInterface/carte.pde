import processing.serial.*;

Serial port; //port serie
String c; //caractere recu par le bluetooth
int base_x = 1500; //milieu x
int base_y = 900; // milieu y
int x=0; //x incremente
int y=0; //y ince=remente
float distance_parc = 0; 
float distance_parc_aux =0; // distance parcourue precedente
int pos = 0; //direction du robot

int tailleFenetreX = 3000;
int tailleFenetreY = 1800;

String recu = new String(); //Chaine recue par Bluetooth

boolean start = true; //sert a remettre a zero la distance

//button
boolean connectionOver;
boolean modeAuto = false;
boolean modeManuel = true;
boolean zoneAuto;
boolean zoneManuel;
boolean avant, droite, gauche, arriere, arret;
PImage up, down, left, right;
PImage stop;

//couleur button
color normalButton, survoleButton;

//capteurs
int CL, CR, CCL, CCT;

//Couleurs capteurs
color capteurActif, capteurInactif;

//Vitesse
boolean lent = false;
boolean moyen = true; 
boolean max = false;
boolean zoneLent, zoneMoy, zoneMax;


void setup() {
  //Initialisations port serie
  println(Serial.list());    // Affichage dans la console de la liste des ports serie du PC
  port = new Serial(this, "COM10", 9600);   //Initialisation de la communicaiton port serie
  port.bufferUntil('\n'); //Attend la reception d'une fin de ligne pour genener un serialEvent()

  //Initialisations graphiques
  size (3000, 1800);
  background(255);

  //Couleurs
  normalButton = color(255);
  survoleButton = color(204);
  capteurActif = color(0, 255, 0);
  capteurInactif = color(255, 0, 0);

  //Echelle
  line(50, 50, 100, 50);
  textSize(20);
  fill(0);
  text("0", 50, 45);
  textSize(20);
  fill(0);
  text("50 cm", 100, 45);
}

void draw() {
  update(mouseX, mouseY);
  //dessin de la trajectoire
  fill(0);
  strokeWeight(5);
  line(base_x+x, base_y+y, base_x+x, base_y+y-1);
  //println(base_x+x);
  //println(base_y+y);
  //println(base_x+x);
  //println(base_y+y-1);

  strokeWeight(1);
  //Distance parcourue + rectangle qui l'entoure
  fill(255);
  rect(tailleFenetreX-450, 0, 430, 100);
  textSize(25);
  fill(0);
  text("Distance parcourue : "+distance_parc, tailleFenetreX-400, 70);

  delay(100);

  //Bouton Connection
  if (connectionOver) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }

  rect(25, 150, 250, 50);
  textSize(25);
  fill(0);
  text("Connexion", 85, 185);

  //Bouton Mode Auto
  if (modeAuto) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }

  rect(2725, 1450, 250, 50);
  textSize(30);
  fill(0);
  text("AUTO", 2802, 1485);

  //Bouton Mode Manuel
  if (modeManuel) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }

  rect(2725, 1350, 250, 50);
  textSize(30);
  fill(0);
  text("MANUEL", 2790, 1385);

  //Bouton avant
  up = loadImage("up.png");

  if (avant) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }

  rect(115, 1350, 60, 60);
  image(up, 115, 1350, 60, 60);


  //Bouton arriere
  down = loadImage("down.png");

  if (arriere) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }

  rect(115, 1490, 60, 60);
  image(down, 115, 1490, 60, 60);

  //Bouton gauche
  left = loadImage("left.png");

  if (gauche) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }

  rect(35, 1420, 60, 60);
  image(left, 35, 1420, 60, 60);

  //Bouton droite
  right = loadImage("right.png");

  if (droite) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }

  rect(190, 1420, 60, 60);
  image(right, 190, 1420, 60, 60);

  //Bouton arret
  stop = loadImage("arret.jpg");

  if (arret) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }
  image(stop, 60, 990, 170, 170);

  //Capteurs
  textSize(25);
  fill(0);
  text("Etat des capteurs :", 2735, 300);

  if (CCL == 1 && modeAuto) {
    fill(capteurActif);
  } else {
    fill(capteurInactif);
  }
  rect(2815, 400, 60, 60);
  textSize(25);
  fill(0);
  text("Avant", 2810, 490);

  if (CCT == 1 && modeAuto) {
    fill(capteurActif);
  } else {
    fill(capteurInactif);
  }
  rect(2815, 550, 60, 60);
  textSize(25);
  fill(0);
  text("Tourner", 2800, 640);

  if (CL == 1 && modeAuto) {
    fill(capteurActif);
  } else {
    fill(capteurInactif);
  }
  rect(2735, 700, 60, 60);
  textSize(25);
  fill(0);
  text("Gauche", 2720, 790);

  if (CR == 1 && modeAuto) {
    fill(capteurActif);
  } else {
    fill(capteurInactif);
  }
  rect(2905, 700, 60, 60);
  textSize(25);
  fill(0);
  text("Droite", 2900, 790);

  //Boutons vitesses
  textSize(25);
  fill(0);
  text("Vitesse :", 25, 350);

  if (lent) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }
  rect(25, 400, 250, 50);
  fill(0);
  textSize(25);
  text("Lent", 120, 435);

  if (moyen) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }
  rect(25, 500, 250, 50);
  fill(0);
  textSize(25);
  text("Moyen", 110, 535);


  if (max) {
    fill(survoleButton);
  } else {
    fill(normalButton);
  }
  rect(25, 600, 250, 50);
  fill(0);
  textSize(25);
  text("Maximum", 95, 635);
  delay(100);
  if (port.available()>0) {
    //Recuperation sur le port serie du caractere
    recu = port.readStringUntil('\n');
    println("trame :" + recu);
    if (recu != null && !recu.isEmpty()) {
      c = recu.substring(0, 1);
      if(!c.equals("s")){
      println ("caractère : " + c);
      CR = parseInt(recu.substring(1, 2));
      println("CR :" + CR);
      CL = parseInt(recu.substring(2, 3));
      println("CL :" + CL);
      CCT = parseInt(recu.substring(3, 4));
      println("CCT :" + CCT);
      CCL = parseInt(recu.substring(4, 5));
      println("CCL :" + CCL);
      distance_parc = parseFloat(recu.substring(5, recu.length()-1));
      
      if(start){
        distance_parc_aux = distance_parc;
        start=false;
      }
      println(c.charAt(0)=='z');

      //dessin carte
      if (pos == 0) {
        if (c.charAt(0)=='z') {
          //line(200,200,300,300);
          y=y-parseInt(distance_parc - distance_parc_aux); // memorisation ordonnee precedente
        } else if (c.charAt(0)=='q') {
          x=x-parseInt(distance_parc - distance_parc_aux);
          pos = 1;
        } else if (c.charAt(0)=='d') {
          pos = 3;
        }
      } else if (pos == 1) {
        if (c.charAt(0)=='z') {
          x=x-parseInt(distance_parc - distance_parc_aux);
        } else if (c.charAt(0)=='q') {
          pos = 2;
        } else if (c.charAt(0)=='d') {
          pos = 0;
        }
      } else if (pos == 2) {
        if (c.charAt(0)=='z') {
          y = y+parseInt(distance_parc - distance_parc_aux);
        } else if (c.charAt(0)=='q') {
          pos = 3;
        } else if (c.charAt(0)=='d') {
          pos = 1;
        }
      } else if (pos == 3) {
        if (c.charAt(0)=='z') {
          x = x+parseInt(distance_parc - distance_parc_aux);
        } else if (c.charAt(0)=='q') {
          pos = 0;
        } else if (c.charAt(0)=='d') {
          pos = 2;
        }
      }
      distance_parc_aux = distance_parc;
    }
  }
  }
}

/*void serialEvent(Serial port) {
  
}*/

//Fonction qui met à jour les variables de "zones" et de directions
void update(int x, int y) {
  connectionOver = setOverConnection(25, 150, 275, 50);

  zoneAuto = setModeAuto(2725, 1450, 250, 50);
  zoneManuel = setModeManuel(2725, 1350, 250, 50);

  avant = setAvant(115, 1350, 60, 60);
  arriere = setArriere(115, 1490, 60, 60);
  gauche = setGauche(35, 1420, 60, 60);
  droite = setDroite(190, 1420, 60, 60);
  arret = setArret(60, 990, 170, 170);

  zoneLent = setLent(25, 400, 250, 50);
  zoneMoy = setMoy(25, 500, 250, 50);
  zoneMax = setMax(25, 600, 250, 50);
}

void mousePressed() {
  //
  if (connectionOver) {
  } else if (modeAuto) {
    
  } 
  //si mode manuel, envoi des commandes droite et gauche
  else if (modeManuel) {
    if (mousePressed) {
      if (gauche) {
        port.write("q");
      } else if (droite) {
        port.write("d");
      }
    }
  }
}

void mouseClicked() {
  //passe du mode auto au mode manuel
  if (zoneAuto ^ zoneManuel) {
    modeAuto = !modeAuto;
    modeManuel = !modeManuel;
    port.write("s");
    println("s");
  }
  //envoi des directions
  if (avant) {
    port.write("z");
  } else if (arriere) {
    port.write("w");
  } else if (arret) {
    port.write("a");
  }
  //envoi de la vitesse
  if (zoneLent) {
    port.write("l");
    lent = true;
    max = false;
    moyen = false;
  } else if (zoneMoy) {
    port.write("m");
    lent = false;
    max = false;
    moyen = true;
  } else if (zoneMax) {
    port.write("r");
    lent = false;
    moyen = false;
    max = true;
  }
}  

//Fonctions de mise à jour des variables qui permettent
//de savoir si la souris est sur un bouton
boolean setOverConnection(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean setModeAuto(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean setModeManuel(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean setAvant(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean setArriere(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean setGauche(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean setDroite(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean setLent(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
boolean setMoy(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
boolean setMax(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
boolean setArret(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}
