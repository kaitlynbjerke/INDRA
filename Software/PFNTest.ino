#define GATE_PIN 22
#define CHARGE_PIN 23

void setup() {
  pinMode(GATE_PIN, OUTPUT);
  pinMode(CHARGE_PIN, OUTPUT);

  digitalWrite(GATE_PIN, LOW);
  digitalWrite(CHARGE_PIN, HIGH);
}

void loop() {
  pinMode(CHARGE_PIN, OUTPUT);
  digitalWrite(CHARGE_PIN, HIGH);
  digitalWrite(GATE_PIN, LOW);

  delay(250);

  digitalWrite(CHARGE_PIN, LOW);
  pinMode(CHARGE_PIN, INPUT); // switch to input for high impedance
  digitalWrite(GATE_PIN, HIGH);

  delay(500);
}
