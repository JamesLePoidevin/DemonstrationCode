#include <Servo.h>

#include <SoftwareSerial.h>

/*
  Microcontroller pulses, independent linear control: An R/C servo signal is connected to terminals S1 and S2. A 1000us – 2000us pulse controls speed and direction. 1500us is stop.
*/
/*VARIABLES GENERALES*/
SoftwareSerial mySerial(7, 8); // RX, TX  
//Connect HM10      Arduino Uno
//TXD          Pin 7
//     RXD          Pin 8

Servo servoL;  // create servo object to control a servo
Servo servoR;  // create servo object to control a servo

bool Start = false;

unsigned long time1;
unsigned long timeaux;

bool start = false;
bool init_E0 = true;

//capteur ultrason AVANT (CC)
const byte TRIGGER_PIN = 2; // Broche TRIGGER
const byte ECHO_PIN = 3;    // Broche ECHO

//capteur ultrason GAUCHE (CL)
const byte TRIGGER_PIN_CL = 4;
const byte ECHO_PIN_CL = 7;

//capteur ultrason DROITE (CR)
const byte TRIGGER_PIN_CR = 8;
const byte ECHO_PIN_CR = 9;

/* Constantes pour le timeout */
const unsigned long MEASURE_TIMEOUT = 25000UL; // 25ms = ~8m à 340m/s

/* Vitesse du son dans l'air en mm/us */
const float SOUND_SPEED = 340.0 / 1000;

/*Variables d'entree*/
bool CCT, CCL, CR, CL = false;
/*Variables de sortie*/
bool AVL, AVM, STOP, TR, TL = false;
/*Declaration des etats*/
//enum Etat {E0, E1, E2, E3, E4, E5, E6, E7};
//Etat EtatPresent, EtatSuivant;
int EtatPresent, EtatSuivant;

    float distance_mm;
    float distance_mm_CL;
    float distance_mm_CR;

     long measure;
     long measure_CL;
     long measure_CR;
     

    int i;

    bool StartR,StartL = true;
    float distance_mm_CL_aux;
    float distance_mm_CR_aux;
    
/////////////////////////////////////
void setup() {
  // put your setup code here, to run once:


  Serial.begin(9600);

  servoR.attach(5, 1000, 2000);
  servoL.attach(6, 1000, 2000); // attaches the servo on pin 9 to the servo object

  /* Initialise les broches  capteurS CC, CL, CR*/
  pinMode(TRIGGER_PIN, OUTPUT);
  digitalWrite(TRIGGER_PIN, LOW); // La broche TRIGGER doit être à LOW au repos
  pinMode(ECHO_PIN, INPUT);
  pinMode(TRIGGER_PIN_CL, OUTPUT);
  digitalWrite(TRIGGER_PIN_CL, LOW); // La broche TRIGGER doit être à LOW au repos
  pinMode(ECHO_PIN_CL, INPUT);
  pinMode(TRIGGER_PIN_CR, OUTPUT);
  digitalWrite(TRIGGER_PIN_CR, LOW); // La broche TRIGGER doit être à LOW au repos
  pinMode(ECHO_PIN_CR, INPUT);

  mySerial.begin(9600);

}

/////////////////////////////////////
void loop() {

  char c;
  if (Serial.available()) {
    c = Serial.read();
    mySerial.print(c);   
  }
  if (mySerial.available()) {
    c = mySerial.read();
    Serial.print(c);     
  }

  if(c == 's')
  {
    start = true;
  }

  if(start)
  {
    for(i=0;i<25;i++){
    digitalWrite(TRIGGER_PIN, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIGGER_PIN, LOW);
  
    /* 2. Mesure le temps entre l'envoi de l'impulsion ultrasonique et son écho (si il existe) */
    measure = pulseIn(ECHO_PIN, HIGH, MEASURE_TIMEOUT);
  
  
    digitalWrite(TRIGGER_PIN_CL, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIGGER_PIN_CL, LOW);
    measure_CL = pulseIn(ECHO_PIN_CL, HIGH, MEASURE_TIMEOUT);
  
  
    digitalWrite(TRIGGER_PIN_CR, HIGH);
    delayMicroseconds(10);
    digitalWrite(TRIGGER_PIN_CR, LOW);
    measure_CR = pulseIn(ECHO_PIN_CR, HIGH, MEASURE_TIMEOUT);
  
    /* 3. Calcul la distance à partir du temps mesuré */
    distance_mm =distance_mm +measure / 2.0 * SOUND_SPEED;
    distance_mm_CL =distance_mm_CL+ measure_CL / 2.0 * SOUND_SPEED;
    distance_mm_CR =distance_mm_CR+ measure_CR / 2.0 * SOUND_SPEED;
    }

    distance_mm = distance_mm/25;
    distance_mm_CL =  distance_mm_CL/25;
    distance_mm_CR = distance_mm_CR/25;

    Serial.print("distance_mm : ");
    Serial.println(distance_mm);
    Serial.print("distance_mm_CL : ");
    Serial.println(distance_mm_CL);
    Serial.print("distance_mm_CR : ");
    Serial.println(distance_mm_CR);
  
    //Test de commande des motors par liaison serie
    /*if (distance_mm > 750.0) {
      avancerMOY();
      } else if (distance_mm > 250.0) {
      avancerLENT();
      } else if (distance_mm < 250.0) {
      arret();
      if (start == true) {
        tournergauche(distance_mm);
        start = false;
      }
      arret();
      start = true;
      }*/
  
    
  
    /*affectation valeur variables*/
    if (distance_mm < 750.0) {
      CCL = true;
    } else {
      CCL = false;
    }
    if (distance_mm <= 400.0) {
      CCT = true;
    } else {
      CCT = false;
    }
    if (distance_mm_CL <= 225.0) {
      CL = true;
    } else {
      CL = false;
    }
    if (distance_mm_CR <= 225.0) {
      CR = true;
    } else {
      CR = false;
    }
  
    /*BLOC F*/
    switch (EtatPresent) {
      case 0:
        if (!CCL) {
          EtatSuivant = 1;
        } else if(CCL){
          EtatSuivant = 2;
        } else {
          EtatSuivant = EtatPresent;
        }
        break;
      case 1:
        if (CCL) {
          EtatSuivant = 2;
        } else {
          EtatSuivant = EtatPresent;
        }
        break;
      case 2:
        if (CCT && !CR) {
          EtatSuivant = 3;
        } else if (CCT && !CL && CR) {
          EtatSuivant = 4;
        } else {
          EtatSuivant = EtatPresent;
        }
        break;
      case 3:
        if (true) {
          EtatSuivant = 0;
        } else {
          EtatSuivant = EtatPresent;
        }
        break;
      case 4:
        if (true) {
          EtatSuivant = 0;
        }else{
          EtatSuivant = EtatPresent;
        }
        break;
    }
  
    /*BLOC M*/
    if (init_E0) {
      EtatPresent = 0;
    } else {
      EtatPresent = EtatSuivant;
    }
    //Serial.println("init");
    //Serial.println(init_E0);
//    Serial.println("EtatSuivant");
//    Serial.println(EtatSuivant);
  
    /*BLOC G*/
    if (EtatPresent == 0) {
      //STOP = true;
      arret();
    }
    if (EtatPresent == 1) {
      //AVM = true;
      avancerMOY();
    }
    if (EtatPresent == 2) {
      //AVL = true;
      avancerLENT();
    }
    if (EtatPresent == 3) {
      //if (!CL && !CCL) {
        TAR();
      //}
    }
    if (EtatPresent == 4) {
      //if (!CR && !CCL) {
        TAL();
      //}
    }
  
    init_E0 = false;
  }
}

void arret() {
  servoL.write(90);
  servoR.write(90);
}

void avancerMAX() {
  servoL.write(35);
  servoR.write(35);
}

void avancerMOY() {
  if(StartL){
    
  }
  servoL.write(55);
  servoR.write(55);
  
}

void avancerLENT() {
  servoL.write(75);
  servoR.write(75);
}

void reculeMAX() {
  servoL.write(145);
  servoR.write(145);
}

void reculeMOY() {
  servoL.write(125);
  servoR.write(125);
}

void reculeLENT() {
  servoL.write(105);
  servoR.write(105);
}

void tournergauche() {
  servoR.write(55);
  servoL.write(125);
}

void tournerdroite() {
  servoR.write(125);
  servoL.write(55);
}

void TAR() {
  time1 = millis() + 3000;

  timeaux = millis();
  while (timeaux < time1) {
      servoL.write(50);
      servoR.write(110);
      timeaux = millis();
  }
}

void TAL() {
  time1 = millis() + 3000;

  timeaux = millis();
  while (timeaux < time1) {
      servoR.write(50);
      servoL.write(110);
      timeaux = millis();
  }
}
