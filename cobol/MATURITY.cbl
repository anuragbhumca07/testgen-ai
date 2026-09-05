      ******************************************************************
      * PROGRAM : MATURITY - POLICY MATURITY / ANNUITIZATION
      * SYSTEM  : POLICY ADMIN SYSTEM - ANNUITIES
      * FUNCTION: PROCESSES POLICY MATURITY. CONVERTS ACCOUNT VALUE TO
      *           A MONTHLY ANNUITY PAYMENT USING A SIMPLE PAYOUT
      *           FACTOR. SETS POLICY STATUS TO MATURED.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MATURITY.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY CPYPOLCY.
       01  WS-PAYOUT-YEARS          PIC 9(03).
       01  WS-TOTAL-MONTHS          PIC 9(05).
       LINKAGE SECTION.
       01  LK-MAT-IN.
           05  LK-POLICY-NUMBER     PIC X(12).
           05  LK-POLICY-STATUS     PIC X(01).
           05  LK-ACCT-VALUE        PIC 9(11)V99.
           05  LK-ANNUITANT-AGE     PIC 9(03).
           05  LK-MATURITY-DATE     PIC 9(08).
           05  LK-PROCESS-DATE      PIC 9(08).
       01  LK-MAT-OUT.
           05  LK-MONTHLY-PAYMENT   PIC 9(09)V99.
           05  LK-PAYOUT-MONTHS     PIC 9(05).
           05  LK-FINAL-STATUS      PIC X(01).
           05  LK-RETURN-CODE       PIC X(04).
           05  LK-MESSAGE           PIC X(60).
       PROCEDURE DIVISION USING LK-MAT-IN LK-MAT-OUT.
       0000-MAIN.
           MOVE '0000' TO LK-RETURN-CODE
           MOVE SPACES TO LK-MESSAGE
           PERFORM 1000-VALIDATE
           IF LK-RETURN-CODE = '0000'
               PERFORM 2000-ANNUITIZE
           END-IF
           GOBACK.
       1000-VALIDATE.
           IF LK-POLICY-STATUS NOT = 'I'
               MOVE 'E801' TO LK-RETURN-CODE
               MOVE 'POLICY NOT INFORCE - CANNOT MATURE'
                    TO LK-MESSAGE
           ELSE
               IF LK-PROCESS-DATE < LK-MATURITY-DATE
                   MOVE 'E802' TO LK-RETURN-CODE
                   MOVE 'MATURITY DATE NOT YET REACHED' TO LK-MESSAGE
               ELSE
                   IF LK-ACCT-VALUE <= 0
                       MOVE 'E803' TO LK-RETURN-CODE
                       MOVE 'NO VALUE TO ANNUITIZE' TO LK-MESSAGE
                   END-IF
               END-IF
           END-IF.
       2000-ANNUITIZE.
      *    SIMPLE PAYOUT: LIFE EXPECTANCY 100 - AGE, FLOOR OF 5 YEARS
           COMPUTE WS-PAYOUT-YEARS = 100 - LK-ANNUITANT-AGE
           IF WS-PAYOUT-YEARS < 5
               MOVE 5 TO WS-PAYOUT-YEARS
           END-IF
           COMPUTE WS-TOTAL-MONTHS = WS-PAYOUT-YEARS * 12
           COMPUTE LK-MONTHLY-PAYMENT ROUNDED =
               LK-ACCT-VALUE / WS-TOTAL-MONTHS
           MOVE WS-TOTAL-MONTHS TO LK-PAYOUT-MONTHS
           MOVE 'M' TO LK-FINAL-STATUS
           MOVE 'POLICY ANNUITIZED SUCCESSFULLY' TO LK-MESSAGE.
