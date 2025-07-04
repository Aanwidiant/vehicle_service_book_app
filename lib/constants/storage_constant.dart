/// Base URL untuk bucket 'moto-track'
const String supabaseStorageBaseUrl =
    'https://kuioqzcrokizrtaoeosc.supabase.co/storage/v1/object/public/moto-track/';

/// Helper function full URL
String getStorageUrl(String relativePath) {
  return '$supabaseStorageBaseUrl$relativePath';
}
