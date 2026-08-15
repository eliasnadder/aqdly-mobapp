// Default connectable address for a physical Android device on the same Wi-Fi
// as the host running the backend. 0.0.0.0 is the SERVER's bind host, not a
// connectable client address — do not use it as baseUrl.
// Users edit this at runtime in Profile & Settings → Backend URL.
const String kDefaultApiBaseUrl = 'http://10.17.81.209:8000';
const String kApiBaseUrlPrefKey = 'api_base_url';