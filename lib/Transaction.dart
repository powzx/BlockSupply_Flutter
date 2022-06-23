class Transaction {
  final String date;
  final String time;
  final String temperature;
  final String humidity;
  final String signer;
  final String publicKey;

  Transaction(this.date, this.time, this.temperature, this.humidity,
      this.signer, this.publicKey);
}
