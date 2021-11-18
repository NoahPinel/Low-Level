#include <LiquidCrystal.h>

// LCD pin --> ard pin #
int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

void setup() 
{
  //16x2 screen
  lcd.begin(16, 2);
  //acos find pi/2
  // --> ** 2 = ~pi
  float Pi = 2 * acos(0.0);

  //print pi to 22 places
  lcd.print(Pi,22);
}

void loop() 
{
  int pixel = 0;

  while (pixel < 16)
  {
    lcd.scrollDisplayLeft();

     delay(500);
     pixel++;
  }

}