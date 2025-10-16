/// Build-time config (override with --dart-define=KEY=VALUE)
const kParkingApiBaseUrl = String.fromEnvironment(
  'PARKING_API_BASE_URL',
  defaultValue: 'https://parking.titanpark.online', // parking service
);

const kCreditApiBaseUrl = String.fromEnvironment(
  'CREDIT_API_BASE_URL',
  defaultValue: 'http://localhost:8001', // credit service
);
