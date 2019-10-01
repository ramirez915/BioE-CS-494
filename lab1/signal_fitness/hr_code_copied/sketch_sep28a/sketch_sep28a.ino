// Global variables
enum respState {
    Inhaling,
    Exhaling
};
unsigned long prevRespTime = 0;
unsigned long currRespTime = 0;
respState currentRespState = Exhaling;
float breathrate = 0;
int movingAvgRespRate = 0;


void setup() 
{
    Serial.begin(115200);
}


void loop()
{
    //delay(500);  
    // don't need to delay because we'll only fire once per inhalation and once per exhalation
    int sensorValue = analogRead(A0);

    if ((sensorValue > 300) && (currentRespState == Exhaling))
    {
        currentRespState = Inhaling;
        prevRespTime = currRespTime;  // save time from last cycle
        currRespTime = millis();

        float period_respiration = currRespTime - prevRespTime;

        if (period_respiration == 0)
            breathrate = 0;
        else 
            breathrate = 60000 / period_respiration;

        Serial.print("Inhaling /tResp Rate: ");
        Serial.print(breathrate);

        if (movingAvgRespRate == 0)
            movingAvgRespRate = breathrate;
        else 
            movingAvgRespRate = (int) ((0.2 * breathrate) + (0.8 * movingAvgRespRate));

        Serial.print("/tAvg Resp Rate: ");
        Serial.println(movingAvgRespRate);
    }
    else if ((currentRespState == Inhaling) && (sensorValue < 200))
    {
        currentRespState = Exhaling;
        Serial.println("Exhaling");
    }
}
