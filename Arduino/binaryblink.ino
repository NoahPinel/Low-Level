// Pin Lay
int pinNum[] = {7,8,9,10};

void setup()
{
  int i = 0;
  while ( i < 4)
  {
    pinMode(pinNum[i], OUTPUT);
    i++;
  }
}

// Output the binary 
// set to 15 since this program only uses 4 LED's , 15 is the max u can count to in binary with 4 digits
void loop()
{
  byte i = 0;
  while (i <= 15)
  {
    binOut(i);
    delay(1000);
    i++;
  }
}

// actual binary calc
void binOut(byte num)
{
  
  int i = 0;
  
  while (i < 4)
  {
    if (bitRead(num, i)==1)
    {
      digitalWrite(pinNum[i], HIGH);
    }
    else
    {
      digitalWrite(pinNum[i], LOW);
    }
    i++;
  }

}
