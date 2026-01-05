# Smart Finance Wallet

A premium, high-performance Flutter fintech application featuring a "Dark Mode" aesthetic, advanced glassmorphism UI, and simulated financial intelligence.

## Features

### Core Experience
*   **Premium Dark UI**: Deep black backgrounds with vibrant neon accents and glassmorphism.
*   **Dashboard**: Real-time Net Worth tracking, Credit Utilization gauge, and Expense Analysis.
*   **Wallet**: Send money, Add balance, and view transaction history with rich animations.
*   **BNPL (Buy Now Pay Later)**: Manage credit flow, mock bill payments, and track upcoming dues.
*   **Rewards**: Gamified "Smart Coins" system with a redeemable marketplace.

### Advanced Financial Intelligence (New)
*   **Financial Digital Twin**: "What-if" simulation engine to forecast your balance for the next 30/90 days.
*   **Credit Health Engine**: Dynamic credit scoring (0-100) that updates based on your payment behavior.
*   **Spending DNA**: Automatic persona analysis (e.g., "Impulse Optimizer", "Stability Seeker") based on transaction patterns.
*   **Explainable AI**: Smart recommendations to help you optimize cash flow and reduce risk.

---

## Prerequisites

*   **Flutter SDK**: Version 3.10.0 or higher.
*   **Dart SDK**: Version 3.0.0 or higher.
*   **Platform**: Chrome (for Web) or iOS/Android Simulator.

---

## Setup & Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/smart_finance_wallet.git
    cd smart_finance_wallet
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Generate code (Hive Adapters)**:
    Required for local database storage models.
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

---

## Running the App

### Web (Recommended for Development)
```bash
flutter run -d chrome
```

### Mobile
```bash
# For iOS Simulator
open -a Simulator
flutter run -d iphone

# For Android Emulator
flutter run -d android
```

**Note**: If you encounter a blank screen on Web launch, ensure you perform a **Hot Restart** (`R` in the terminal) inside the running flutter process.

---

## How to Use

### 1. Authentication
*   **Login**: Use any email/password (e.g., `user@example.com` / `password`). This is a mock authentication flow.
*   **Sign Up**: Create a new account to start with a fresh wallet simulation.

### 2. Dashboard
*   View your **Total Balance** and **Reward Points** at the top.
*   Check your **Credit Utilization** and **Expense Split** in the bottom grid.
*   Use **Quick Actions** to navigate to specific features.

### 3. Wallet Operations
*   Tap **"Wallet"** to verify history.
*   Tap **"Add Money"** to top up your simulated balance.
*   Tap **"Send Money"** to create simulated expense transactions.

### 4. Financial Intelligence (The "Analysis" Tab)
*   Tap the **Teal "Analysis"** button on the Dashboard.
*   **Credit Gauge**: See your real-time risk tier. Pay off BNPL bills to improve this.
*   **Spending DNA**: See your current financial persona badge.
*   **Digital Twin**: Scroll down to the **Simulation** card.
    *   Adjust **Income/Expense sliders** to see how your 30-day projected balance changes.
    *   Toggle **"Simulate Delayed Payment"** to see the negative impact on your forecast.
*   **Recommendations**: Click any AI Recommendation card to expand and read the impact analysis.

---

## Project Structure

*   `lib/src/features`: Modular feature code (Auth, Wallet, BNPL, Intelligence).
*   `lib/src/core`: Shared widgets (GlassCard) and theming.
*   `test/`: Unit and Widget tests.
