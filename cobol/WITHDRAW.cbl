      ******************************************************************
      * PROGRAM : WITHDRAW - PARTIAL WITHDRAWAL PROCESSING
      * SYSTEM  : POLICY ADMIN SYSTEM - ANNUITIES
      * FUNCTION: PROCESSES A PARTIAL WITHDRAWAL. APPLIES SURRENDER
      *           CHARGE ABOVE THE FREE-WITHDRAWAL ALLOWANCE, COMPUTES
      *           TAX WITHHOLDING FOR QUALIFIED PLANS, UPDATES VALUES.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. WITHDRAW.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY CPYPOLCY.
       COPY CPYTRANS.
       01  WS-FREE-WD-ALLOW         PIC 9(11)V99 COMP-3.
       01  WS-EXCESS-AMT            PIC 9(11)V99 COMP-3.
       01  WS-SURR-CHARGE          PIC 9(09)V99 COMP-3.
       01  WS-TAXABLE-AMT          PIC 9(11)V99 COMP-3.
       01  WS-TAX-RATE             PIC 9V9(04) COMP-3 VALUE 0.1000.
       01  WS-FREE-WD-PCT          PIC 9V9(04) COMP-3 VALUE 0.1000.
       LINKAGE SECTION.
       01  LK-WD-IN.
           05  LK-POLICY-NUMBER     PIC X(12).
           05  LK-POLICY-STATUS     PIC X(01).
           05  LK-PLAN-TYPE         PIC X(01).
           05  LK-ACCT-VALUE        PIC 9(11)V99.
           05  LK-WD-AMOUNT         PIC 9(09)V99.
           05  LK-SURR-CHARGE-PCT   PIC 9(02)V9(04).
           05  LK-PRIOR-WD-YTD      PIC 9(11)V99.
       01  LK-WD-OUT.
           05  LK-GROSS-WD          PIC 9(09)V99.
           05  LK-SURR-CHARGE-OUT   PIC 9(09)V99.
           05  LK-TAX-WITHHELD      PIC 9(09)V99.
           05  LK-NET-WD            PIC 9(09)V99.
           05  LK-NEW-ACCT-VALUE    PIC 9(11)V99.
           05  LK-RETURN-CODE       PIC X(04).
           05  LK-MESSAGE           PIC X(60).
       PROCEDURE DIVISION USING LK-WD-IN LK-WD-OUT.
       0000-MAIN.
           MOVE '0000' TO LK-RETURN-CODE
           MOVE SPACES TO LK-MESSAGE
           MOVE ZEROES TO LK-SURR-CHARGE-OUT LK-TAX-WITHHELD
           PERFORM 1000-VALIDATE
           IF LK-RETURN-CODE = '0000'
               PERFORM 2000-CALC-WITHDRAWAL
           END-IF
           GOBACK.
       1000-VALIDATE.
           IF LK-POLICY-STATUS NOT = 'I'
               MOVE 'E301' TO LK-RETURN-CODE
               MOVE 'POLICY NOT INFORCE FOR WITHDRAWAL' TO LK-MESSAGE
           ELSE
               IF LK-WD-AMOUNT <= 0
                   MOVE 'E302' TO LK-RETURN-CODE
                   MOVE 'WITHDRAWAL MUST BE POSITIVE' TO LK-MESSAGE
               ELSE
                   IF LK-WD-AMOUNT > LK-ACCT-VALUE
                       MOVE 'E303' TO LK-RETURN-CODE
                       MOVE 'WITHDRAWAL EXCEEDS ACCOUNT VALUE'
                            TO LK-MESSAGE
                   END-IF
               END-IF
           END-IF.
       2000-CALC-WITHDRAWAL.
           MOVE LK-WD-AMOUNT TO LK-GROSS-WD
           COMPUTE WS-FREE-WD-ALLOW =
               (LK-ACCT-VALUE * WS-FREE-WD-PCT) - LK-PRIOR-WD-YTD
           IF WS-FREE-WD-ALLOW < 0
               MOVE ZEROES TO WS-FREE-WD-ALLOW
           END-IF
           IF LK-WD-AMOUNT > WS-FREE-WD-ALLOW
               COMPUTE WS-EXCESS-AMT =
                       LK-WD-AMOUNT - WS-FREE-WD-ALLOW
               COMPUTE WS-SURR-CHARGE ROUNDED =
                       WS-EXCESS-AMT * LK-SURR-CHARGE-PCT
           ELSE
               MOVE ZEROES TO WS-SURR-CHARGE
           END-IF
           MOVE WS-SURR-CHARGE TO LK-SURR-CHARGE-OUT
           IF LK-PLAN-TYPE = 'Q'
               COMPUTE WS-TAXABLE-AMT = LK-WD-AMOUNT - WS-SURR-CHARGE
               COMPUTE LK-TAX-WITHHELD ROUNDED =
                       WS-TAXABLE-AMT * WS-TAX-RATE
           ELSE
               MOVE ZEROES TO LK-TAX-WITHHELD
           END-IF
           COMPUTE LK-NET-WD =
               LK-WD-AMOUNT - LK-SURR-CHARGE-OUT - LK-TAX-WITHHELD
           COMPUTE LK-NEW-ACCT-VALUE = LK-ACCT-VALUE - LK-WD-AMOUNT
           MOVE 'WITHDRAWAL PROCESSED SUCCESSFULLY' TO LK-MESSAGE.
