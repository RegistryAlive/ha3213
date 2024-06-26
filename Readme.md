# WLM 980x Steam Multi Client Guide

## Introduction

To run multiple Steam clients, you'll need several Steam accounts. It's best if these accounts don't have Steam Guard enabled, as it complicates the process.

- You'll need one Steam account for each client you want to run.
  - For example, to run 4 clients, you'll need 4 Steam accounts.

## Setting Up

1. **Create Steam Accounts**
   - Ensure you have the necessary number of Steam accounts.

2. **Download the Batch File**
   - [Download BAT File](https://github.com/RegistryAlive/ha3213/releases/download/V1.0/Multi-Client.WLM.bat)

3. **Edit the Batch File**
   - Right-click the downloaded file and select "Edit" (use Notepad or any text editor).
   - Find the lines that say:
     ```
     Set username="replace with your steam account username example : WLSteamaccount04"
     ```
   - Replace `"replace with your steam account username"` with your actual Steam username. For example:
     ```
     Set username="WLSteamAccount1"
     ```
   - Do this for each of the 4 accounts, updating the corresponding sections:
     ```
     Set username="WLSteamAccount1"  // :1
     Set username="WLSteamAccount2"  // :2
     Set username="WLSteamAccount3"  // :3
     Set username="WLSteamAccount4"  // :4
     ```

## Running the Batch File

Follow these steps to run the batch file and log into each account:

1. **Run the Batch File**
   - Double-click the batch file to run it.

2. **Choose the Account**
   - Enter the number of the account you want to log into (e.g., type "1" for the first account).

3. **Log into Steam**
   - Enter the login details for the Steam account that corresponds to the number you chose (e.g., `WLSteamAccount1` for account 1).

4. **Launch Your Game**
   - After logging into the Steam account, launch your game and log in.

5. **Repeat for Other Accounts**
   - Repeat steps 1 to 4 for each additional account.

**Important:** Ensure each account is logged in before running the batch file again; otherwise, your game may close unexpectedly.

## Adding More Clients

To add more clients, modify the batch file as follows:

1. **Add More `echo` Lines**
   - Find the existing `echo` lines and add new ones for each additional account:
     ```
     echo 1)
     echo 2)
     echo 3)
     echo 4)
     echo 5) "Description for account 5"
     echo 6) "Description for account 6"
     ```

2. **Update the `CHOICE` Command**
   - Modify the `CHOICE` line to include the new accounts:
     ```
     CHOICE /M Select /C 123456
     ```
   - Add more numbers if you have more accounts.

3. **Add New Account Sections**
   - For each new account, add a new section before the existing ones:
     ```
     :6
     set username="YourSteamUsername6"
     Goto end

     :5
     set username="YourSteamUsername5"
     Goto end

     :4
     set username="YourSteamUsername4"
     Goto end
     ```

   - Continue this pattern for as many accounts as needed. Ensure the sections are in descending order.

By following these steps, you can efficiently run multiple Steam clients.
