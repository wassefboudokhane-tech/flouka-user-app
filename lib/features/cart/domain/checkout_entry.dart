/// Whether the cart "Place order" action should stop on the login dialog.
///
/// Guests already have a local cart. Checkout itself collects an address,
/// so the login dialog is not the entry gate.
bool checkoutEntryBlockedForGuest({required bool isLoggedIn}) {
  // Checkout collects the address. Guests are not stopped on the login dialog.
  if (!isLoggedIn) return false;
  return false;
}
