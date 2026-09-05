      ******************************************************************
      * CPYTRANS - TRANSACTION RECORD COPYBOOK
      * POLICY ADMIN SYSTEM - ANNUITIES
      ******************************************************************
       01  WS-TRANSACTION-RECORD.
           05  TR-TRX-ID                PIC 9(12).
           05  TR-POLICY-NUMBER         PIC X(12).
           05  TR-TRX-TYPE              PIC X(04).
               88  TR-PREMIUM               VALUE 'PREM'.
               88  TR-WITHDRAWAL            VALUE 'WDRL'.
               88  TR-SURRENDER             VALUE 'SURR'.
               88  TR-INTEREST-CREDIT       VALUE 'INTC'.
               88  TR-DEATH-BENEFIT         VALUE 'DTHB'.
               88  TR-FEE                    VALUE 'FEE '.
           05  TR-TRX-DATE              PIC 9(08).
           05  TR-TRX-AMOUNT           PIC S9(11)V99 COMP-3.
           05  TR-GROSS-AMOUNT         PIC S9(11)V99 COMP-3.
           05  TR-SURR-CHARGE-AMT      PIC S9(09)V99 COMP-3.
           05  TR-TAX-WITHHELD         PIC S9(09)V99 COMP-3.
           05  TR-NET-AMOUNT           PIC S9(11)V99 COMP-3.
           05  TR-TRX-STATUS           PIC X(01).
               88  TR-POSTED                VALUE 'P'.
               88  TR-REVERSED              VALUE 'R'.
               88  TR-REJECTED              VALUE 'X'.
           05  TR-REVERSAL-FLAG        PIC X(01).
               88  TR-IS-REVERSAL           VALUE 'Y'.
               88  TR-NOT-REVERSAL          VALUE 'N'.
           05  TR-ERROR-CODE           PIC X(04).
