# Smart Finance Wallet

A Flutter-based financial management application featuring Wallet tracking, BNPL (Buy Now Pay Later) simulation, Rewards system, and Dashboard analytics. This app uses Riverpod for state management and Hive for local storage.

## Prerequisites

Before drawing, ensure you have the following installed:

*   **Flutter SDK**: [Install Flutter](https://docs.flutter.dev/get-started/install) (Ensure you are on the `stable` channel).
*   **Browser**: Google Chrome (for web debugging).
*   **VS Code** or **Android Studio**: With Flutter and Dart extensions installed.

## Setup & Installation

1.  **Clone the repository** (or unzip the project folder).
2.  **Open the terminal** in the project directory.
3.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Generate code** (for Riverpod & Hive adapters):
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

## Running the Web Application

To start the application on Chrome:

```bash
flutter run -d chrome
```

*Note: The first launch might take a minute to download the Flutter Web SDK.*

## Configuration

### Firebase Configuration (Crucial Step)

Currently, the app is configured with **placeholder/dummy credentials** for the web platform to allow the UI to launch without crashing. To connect it to your actual Firebase backend:

1.  **Go to Firebase Console**:
    *   Create a new project or select an existing one.
    *   Navigate to **Project settings** > **General**.
    *   Under **Your apps**, click the **Web (</>)** icon to create a web app.
    *   Copy the `firebaseConfig` object (apiKey, authDomain, projectId, etc.).

2.  **Update `lib/main.dart`**:
    *   Open the file `lib/main.dart` in your editor.
    *   Locate the `Firebase.initializeApp` call inside the `main()` function (around lines 18-30).
    *   Replace the dummy strings in the `FirebaseOptions` constructor with your actual keys from the Firebase Console.

    ```dart
    // lib/main.dart

    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'PASTE_YOUR_API_KEY_HERE', 
          appId: 'PASTE_YOUR_APP_ID_HERE', 
          messagingSenderId: 'PASTE_YOUR_SENDER_ID_HERE',
          projectId: 'PASTE_YOUR_PROJECT_ID_HERE',
          // authDomain: '...', // Optional, add if needed
          // storageBucket: '...', // Optional, add if needed
        ),
      );
    }
    ```

3.  **Restart the App**:
    *   Perform a "Hot Restart" (`r` in the terminal) or stop and re-run `flutter run -d chrome`.

### Better Way (Recommended for Production)

For a more robust setup, use the FlutterFire CLI:

1.  Install the CLI: `npm install -g firebase-tools` and `dart pub global activate flutterfire_cli`.
2.  Run: `flutterfire configure`.
3.  This will automatically generate `lib/firebase_options.dart` with the correct keys for all platforms.
4.  Update `lib/main.dart` to use the generated options:
    ```dart
    import 'firebase_options.dart';
    // ...
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    ```

## Features & Usage Guide

### 1. Authentication
*   **Sign Up**: Create a new account using email and password.
*   **Login**: Access your dashboard with existing credentials.
*   **Logout**: Securely sign out from the profile/settings area.
*   **Manual Test**:
    1.  Launch the app.
    2.  Click "Sign Up". Enter a valid email (e.g., `test@example.com`) and password (min 6 chars).
    3.  Verify successful navigation to the Dashboard.
    4.  Logout and try logging in with the same credentials.

### 2. Dashboard
*   **Overview**: View your total balance, recent transactions, and financial health score.
*   **Charts**: Visual representation of your spending habits (Weekly/Monthly).
*   **Manual Test**:
    1.  Observe the "Total Balance" card.
    2.  Check if the chart renders correctly.
    3.  Verify that recent transactions added in the Wallet section appear here.

### 3. Wallet (Transactions)
*   **Add Money**: Top up your wallet balance.
*   **Send Money**: Simulate transferring funds to another user.
*   **Transaction History**: List of all credits and debits with categories.
*   **Manual Test**:
    1.  Go to the **Wallet** tab.
    2.  Click **"Add Money"**. Enter $1000 and select category "Salary". Confirm.
    3.  Verify balance increases by $1000.
    4.  Click **"Send Money"**. Enter $50 and a recipient name. Confirm.
    5.  Verify balance decreases by $50 and a new "Send" transaction appears in the list.

### 4. BNPL (Buy Now Pay Later)
*   **Simulate Purchase**: Create a new BNPL obligation (split payment).
*   **View Bills**: See upcoming and settled bills.
*   **Pay Bill**: Settle an outstanding BNPL bill using your wallet balance.
*   **Manual Test**:
    1.  Go to the **BNPL** section (via Dashboard or Navigation).
    2.  Create a new BNPL purchase of $200.
    3.  Go to **"Upcoming"** bills. You should see the $200 bill.
    4.  Click **"Pay Now"**.
    5.  Verify the bill moves to **"Settled"** tab.
    6.  Check Wallet balance; it should be deducted by $200.
    7.  **Bonus**: You should earn rewards coins for paying this bill!

### 5. Rewards Engine
*   **Earn Coins**: Gain coins for adding money, sending money, or paying BNPL bills.
*   **Redeem Rewards**: Use coins to claim simulated cashback or vouchers.
*   **Manual Test**:
    1.  Go to the **Rewards** screen.
    2.  Note your current "Coin Balance".
    3.  Perform a transaction in the Wallet or pay a BNPL bill.
    4.  Return to Rewards; verify the coin balance has increased.
    5.  Select a reward (e.g., "$5 Cashback") and click **"Redeem"**.
    6.  Verify coins are deducted and a success message is shown.

## Running Tests

To run the automated unit and widget tests:

```bash
flutter test
```

This will execute checks for:
*   Wallet logic (Balance updates).
*   BNPL constraints (Credit limits).
*   Rewards calculations.
*   Authentication state flows.
