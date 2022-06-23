class Transaction {
  String secondsSinceEpoch;
  String temperature;
  String humidity;
  String signer;
  String publicKey;

  Transaction(secondsSinceEpoch, temperature, humidity, signer, publicKey) {
    this.secondsSinceEpoch = secondsSinceEpoch;
    this.temperature = temperature;
    this.humidity = humidity;
    this.signer = signer;
    this.publicKey = publicKey;

    // DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(int.parse(secondsSinceEpoch) * 1000);
  }
}
