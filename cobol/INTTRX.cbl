      ******************************************************************
      * PROGRAM : INTTRX   - INTERNAL TRANSACTION (INTEREST CREDIT)
      * SYSTEM  : POLICY ADMIN SYSTEM - ANNUITIES
      * FUNCTION: SYSTEM-GENERATED INTERNAL TRANSACTION THAT CREDITS
      *           GUARANTEED INTEREST TO INFORCE POLICIES ON ANNIVERSARY.
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INTTRX.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY CPYPOLCY.
       COPY CPYTRANS.
       01  WS-INTEREST-AMT          PIC 9(11)V99 COMP-3.
       01  WS-DAYS-IN-YEAR          PIC 9(03) VALUE 365.
       LINKAGE SECTION.
       01  LK-INT-IN.
           05  LK-POLICY-NUMBER     PIC X(12).
           05  LK-POLICY-STATUS     PIC X(01).
           05  LK-ACCT-VALUE        PIC 9(11)V99.
           05  LK-GUAR-RATE         PIC 9(02)V9(04).
           05  LK-ACCRUAL-DAYS      PIC 9(03).
           05  LK-PROCESS-DATE      PIC 9(08).
       01  LK-INT-OUT.
           05  LK-INTEREST-CREDITED PIC 9(11)V99.
           05  LK-NEW-ACCT-VALUE    PIC 9(11)V99.
           05  LK-RETURN-CODE       PIC X(04).
           05  LK-MESSAGE           PIC X(60).
       PROCEDURE DIVISION USING LK-INT-IN LK-INT-OUT.
       0000-MAIN.
           MOVE '0000' TO LK-RETURN-CODE
           MOVE SPACES TO LK-MESSAGE
           PERFORM 1000-VALIDATE
           IF LK-RETURN-CODE = '0000'
               PERFORM 2000-CREDIT-INTEREST
           END-IF
           GOBACK.
       1000-VALIDATE.
           IF LK-POLICY-STATUS NOT = 'I'
               MOVE 'E401' TO LK-RETURN-CODE
               MOVE 'POLICY NOT INFORCE - NO INTEREST' TO LK-MESSAGE
           ELSE
               IF LK-ACCT-VALUE <= 0
                   MOVE 'E402' TO LK-RETURN-CODE
                   MOVE 'NO ACCOUNT VALUE TO CREDIT' TO LK-MESSAGE
               ELSE
                   IF LK-ACCRUAL-DAYS <= 0 OR
                      LK-ACCRUAL-DAYS > WS-DAYS-IN-YEAR
                       MOVE 'E403' TO LK-RETURN-CODE
                       MOVE 'INVALID ACCRUAL DAYS' TO LK-MESSAGE
                   END-IF
               END-IF
           END-IF.
       2000-CREDIT-INTEREST.
           COMPUTE WS-INTEREST-AMT ROUNDED =
               LK-ACCT-VALUE * LK-GUAR-RATE *
               (LK-ACCRUAL-DAYS / WS-DAYS-IN-YEAR)
           MOVE WS-INTEREST-AMT TO LK-INTEREST-CREDITED
           COMPUTE LK-NEW-ACCT-VALUE =
               LK-ACCT-VALUE + WS-INTEREST-AMT
           MOVE 'INTEREST CREDITED SUCCESSFULLY' TO LK-MESSAGE.
