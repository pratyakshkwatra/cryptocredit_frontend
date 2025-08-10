String shortenAddress(String address) {
  if (address.length <= 10) return address;
  return '${address.substring(0, 5)}...${address.substring(address.length - (address.length * 0.3).round())}';
}
