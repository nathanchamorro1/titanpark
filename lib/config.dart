// Build-time config (override with --dart-define=API_BASE_URL=...)
const kApiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:8000',
);
