#include <Arduino.h>

const int RPWM_pin = 1;
const int LPWM_pin = 2;

void driveForward(int speed) {
    analogWrite(LPWM_pin, 0);
    analogWrite(RPWM_pin, speed);
}

void driveBackward(int speed) {
    analogWrite(RPWM_pin, 0);
    analogWrite(LPWM_pin, speed);
}